//
//  RCTModalView.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

typealias completionResult = ((_ isSuccess: Bool, _ error: RCTModalViewError?) -> ())?;

fileprivate struct DefaultValues {
  static let presentationStyle: UIModalPresentationStyle = {
    guard #available(iOS 13.0, *) else { return .fullScreen };
    return .automatic;
  }();
  
  static let presentationStyleString =
    Self.presentationStyle.stringDescription() as NSString;
  
  static let modalBGBlurEffectStyle: UIBlurEffect.Style = {
    guard #available(iOS 13.0, *) else { return .regular };
    return .systemThinMaterial;
  }();
  
  static let modalBGBlurEffectStyleString =
    Self.modalBGBlurEffectStyle.stringDescription() as NSString;
};

class RCTModalView: UIView {
  
  // ----------------
  // MARK: Properties
  // ----------------

  weak var bridge  : RCTBridge?;
  weak var delegate: RCTModalViewPresentDelegate?;
  
  var isInFocus  : Bool = false;
  var isPresented: Bool = false;
  
  private var modalVC     : RCTModalViewController?;
  private var modalNVC    : UINavigationController?;
  private var touchHandler: RCTTouchHandler!;
  private var reactSubview: UIView?;
  
  var modalLevelPrev = -1;
  var modalLevel = -1 {
    didSet {
      self.modalLevelPrev = oldValue;
    }
  };
  
  let modalUUID = UUID().uuidString;
  
  // ------------------------------------------------
  // MARK: Properties: React Props - Events/Callbacks
  // ------------------------------------------------
  
  // RN event callback for when a RCTModalViewManager "command"
  // has been completed via dispatchViewManagerCommand from js.
  // Used in js/rn-side for wrapping UIManager commands inside
  // promises so they can be resolved/rejected.
  @objc var onRequestResult: RCTDirectEventBlock?;
  
  // RN event callbacks for whenever a modal is presented/dismissed
  // via functions or from swipe to dismiss gestures
  @objc var onModalShow   : RCTDirectEventBlock?;
  @objc var onModalDismiss: RCTDirectEventBlock?;
  
  // RN event callbacks for: UIAdaptivePresentationControllerDelegate
  // Note: that these are only invoked in response to dismiss gestures
  @objc var onModalDidDismiss    : RCTDirectEventBlock?;
  @objc var onModalWillDismiss   : RCTDirectEventBlock?;
  @objc var onModalAttemptDismiss: RCTDirectEventBlock?;
  
  // RN event callbacks whenever a modal is focused/blurred
  // note: is not called when the modal is topmost to prevent duplication
  // of the onModalShow/onModalDismiss events
  @objc var onModalBlur : RCTDirectEventBlock?;
  @objc var onModalFocus: RCTDirectEventBlock?;
  
  // ---------------------------------------------
  // MARK: Properties: React Props - "Value" Props
  // ---------------------------------------------
  
  @objc var isModalBGBlurred: Bool = true {
    didSet {
      guard oldValue != self.isModalBGBlurred else { return };
      self.modalVC?.isBGBlurred = self.isModalBGBlurred;
    }
  };
  
  @objc var isModalBGTransparent: Bool = true {
    didSet {
      guard oldValue != self.isModalBGTransparent else { return };
      self.modalVC?.isBGTransparent = self.isModalBGTransparent;
    }
  };
  
  @objc var modalBGBlurEffectStyle: NSString = DefaultValues.modalBGBlurEffectStyleString {
    didSet {
      guard oldValue != self.modalBGBlurEffectStyle
      else { return };
      
      guard let blurStyle = UIBlurEffect.Style.fromString(self.modalBGBlurEffectStyle)
      else {
        RCTLogWarn(
            "RCTModalView, modalBGBlurEffectStyle: Invalid value - "
          + "\(self.modalBGBlurEffectStyle) is not a valid blur style"
        );
        return;
      };
      
      self.modalVC?.blurEffectStyle = blurStyle;
    }
  };
  
  private var _modalPresentationStyle = DefaultValues.presentationStyle;
  
  @objc var modalPresentationStyle: NSString = DefaultValues.presentationStyleString {
    didSet {
      guard oldValue != self.modalPresentationStyle
      else { return };
      
      guard let style = UIModalPresentationStyle.fromString(self.modalPresentationStyle)
      else {
        RCTLogWarn(
            "RCTModalView, modalPresentationStyle: Invalid value - "
          + "\(self.modalPresentationStyle) is not a valid presentation style"
        );
        return;
      };
      
      switch style {
        case .automatic,
             .pageSheet,
             .formSheet,
             .fullScreen,
             .overFullScreen:
          
          self._modalPresentationStyle = style;
          #if DEBUG
          print("RCTModalView, modalPresentationStyle didSet: \(style.stringDescription())");
          #endif

        default:
          RCTLogWarn(
              "RCTModalView, modalPresentationStyle: Unsupported Presentation Style - "
            + "\(self.modalPresentationStyle) is not a supported presenatation style"
          );
      };
    }
  };
  
  private var _modalTransitionStyle: UIModalTransitionStyle = .coverVertical;
  @objc var modalTransitionStyle: NSString = "coverVertical" {
    didSet {
      guard oldValue != self.modalTransitionStyle
      else { return };
      
      guard let style = UIModalTransitionStyle.fromString(self.modalTransitionStyle as String)
      else {
        RCTLogWarn("RCTModalView, modalTransitionStyle: Invalid value");
        return;
      };
      
      self._modalTransitionStyle = style;
      #if DEBUG
      print("RCTModalView, modalTransitionStyle didSet: \(style.stringDescription())");
      #endif
    }
  };
  
  // unique identifier for this modal
  @objc var modalID: NSString? = nil {
    willSet {
      self.modalVC?.modalID = newValue;
    }
  };
  
  // disable swipe gesture recognizer for this modal
  @objc var enableSwipeGesture: Bool = true {
    didSet {
      guard self.enableSwipeGesture != oldValue else { return };
      self.enableSwipeGesture(self.enableSwipeGesture);
    }
  };
  
  @objc var hideNonVisibleModals: Bool = true;
  
  // control modal present/dismiss by mounting/unmounting the react subview
  // * true : the modal is presented/dismissed when the view is mounted/unmounted
  // * false: the modal is presented/dismissed by calling the functions from js
  @objc var presentViaMount: Bool = false;
  
  // allow modal to be programatically closed even when not current focused
  // * true : the modal can be dismissed even when it's not the topmost presented modal
  // * false: the modal can only be dismissed if it's in focus, otherwise error
  @objc var allowModalForceDismiss: Bool = true;
  
  @objc var isModalInPresentation: Bool = false {
    willSet {
      if #available(iOS 13.0, *) {
        guard let vc = self.modalVC else { return };
        vc.isModalInPresentation = newValue
      };
    }
  };
  
  // -------------------------------
  // MARK: Swift/UIKit Related Logic
  // -------------------------------
  
  init(bridge: RCTBridge) {
    super.init(frame: CGRect());
    
    self.bridge = bridge;
    self.touchHandler = RCTTouchHandler(bridge: self.bridge);
  };
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    fatalError("Not implemented");
  };
  
  override func layoutSubviews() {
    super.layoutSubviews();
    
    guard
      let modalVC      = self.modalVC,
      let reactSubview = self.reactSubview else { return };
    
    #if DEBUG
    print("RCTModalView, layoutSubviews - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
    if !reactSubview.isDescendant(of: modalVC.view) {
      modalVC.reactView = reactSubview;
    };
  };
  
  override func didMoveToWindow() {
    super.didMoveToWindow();
    if self.presentViaMount {
      self.dismissModal();
    };
  };
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview();
    if self.presentViaMount {
      self.presentModal();
    };
  };
  
  // ----------------------
  // MARK: RN Related Logic
  // ----------------------
  
  override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
    
    guard (self.reactSubview == nil) else {
      RCTLogWarn("RCTModalView, insertReactSubview: Modal view can only have one subview");
      return;
    };
    
    #if DEBUG
    print("RCTModalView, insertReactSubview - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
    subview.removeFromSuperview();
    subview.frame = CGRect(
      origin: CGPoint(x: 0, y: 0),
      size  : CGSize(width: 0, height: 0)
    );
    
    if let newBounds = modalVC?.view.bounds {
      self.bridge?.uiManager.setSize(newBounds.size, for: subview);
    };
    
    self.reactSubview = subview;
    self.touchHandler.attach(to: subview);
  };
  
  override func removeReactSubview(_ subview: UIView!) {
    super.removeReactSubview(subview);
    
    guard self.reactSubview == subview else {
      RCTLogWarn("RCTModalView, removeReactSubview: Cannot remove view other than modal view");
      return;
    };
    
    #if DEBUG
    print("RCTModalView, removeReactSubview - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
    self.reactSubview = nil;
    self.modalVC?.reactView = nil;
    self.touchHandler.detach(from: subview);
  };
  
  // ----------------------
  // MARK: Public Functions
  // ----------------------
  
  public func presentModal(completion: completionResult = nil) {
    let hasWindow: Bool = (self.window != nil);
    
    /// this view is going to be rendered, so we should init the controllers
    if self.modalVC == nil || self.modalNVC == nil {
      self.initControllers();
    };
    
    guard (hasWindow && !self.isPresented),
      let modalNVC = self.modalNVC,
      let (index, topMostPresentedVC) = self.getTopMostPresentedVC()
    else {
      #if DEBUG
      print("RCTModalView, presentModal: guard check failed");
      #endif
      completion?(false, .modalAlreadyPresented);
      return;
    };
    
    /// weird bug where you cant present fullscreen if `presentationController` delegate is set
    /// so only set the delegate when we are using a page sheet
    switch self._modalPresentationStyle {
      case .automatic, .pageSheet, .formSheet:
        modalNVC.presentationController?.delegate = self;
      default: break;
    };
    
    modalNVC.modalTransitionStyle   = self._modalTransitionStyle;
    modalNVC.modalPresentationStyle = self._modalPresentationStyle;
    
    self.modalLevel  = index + 1;
    self.isInFocus   = true;
    self.isPresented = true;
    
    #if DEBUG
    print("RCTModalView, presentModal: Start"
      + " - for reactTag: \(self.reactTag ?? -1)"
      + " - modalLevel: \(self.modalLevel)"
      + " - modalID: \(self.modalID ?? "N/A")"
      + " - with presentationStyle: \(self._modalPresentationStyle.stringDescription())"
      + " - with transitionStyle: \(self._modalTransitionStyle.stringDescription())"
    );
    #endif
    
    self.enableSwipeGesture(false);
    
    topMostPresentedVC.present(modalNVC, animated: true) {
      if self.hideNonVisibleModals {
        self.setIsHiddenForViewBelowLevel(self.modalLevel - 1, isHidden: true);
      };
      
      self.enableSwipeGesture();
      
      self.onModalShow?([:]);
      self.delegate?.onPresentModalView(modalView: self);
      completion?(true, nil);
      
      #if DEBUG
      print("RCTModalView, presentModal: Finished");
      #endif
    };
  };
  
  public func dismissModal(completion: completionResult = nil) {
    guard self.isPresented,
      let modalVC = self.modalVC
    else {
      #if DEBUG
      print("RCTModalView, dismissModal failed:"
        + " - isPresented \(self.isPresented)"
      );
      #endif
      completion?(false, .modalAlreadyDismissed);
      return;
    };
    
    let isModalInFocus = self.isModalInFocus();
    guard isModalInFocus, self.allowModalForceDismiss else {
      #if DEBUG
      print("RCTModalView, dismissModal failed: Modal not in focus");
      #endif
      completion?(false, .modalDismissFailedNotInFocus);
      return;
    };
    
    let presentedVC: UIViewController = isModalInFocus
      ? modalVC
      : modalVC.presentingViewController!
    
    #if DEBUG
    print("RCTModalView, dismissModal: Start - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
    /// begin temp. hiding modals that are no longer visibile
    if self.hideNonVisibleModals {
      self.setIsHiddenForViewBelowLevel(self.modalLevel, isHidden: false);
    };
    
    self.modalLevel  = -1;
    self.isInFocus   = false;
    self.isPresented = false;
    self.enableSwipeGesture(false);
    
    presentedVC.dismiss(animated: true){
      self.onModalDismiss?([:]);
      self.delegate?.onDismissModalView(modalView: self);
      completion?(true, nil);
      
      self.deinitControllers();
      
      #if DEBUG
      print("RCTModalView, dismissModal: Finished");
      #endif
    };
  };
  
  // --------------------------------------
  // MARK: Public Functions for ViewManager
  // --------------------------------------
  
  // called by RCTModalViewManager
  // set isModalInPresentation for this modal from RN
  public func requestModalPresentation(
    _ requestID : NSNumber,
    _ visibility: Bool    ,
      completion: completionResult = nil
  ){
    var params: Dictionary<String, Any> = [
      "requestID" : requestID ,
      "visibility": visibility,
    ];
    
    let modalAction = visibility
      ? self.presentModal
      : self.dismissModal
    
    modalAction(){ (success, error) in
      params["success"] = success;
      if let errorCode = error {
        params["errorCode"   ] = errorCode.rawValue;
        params["errorMessage"] = RCTModalViewError.getErrorMessage(for: errorCode);
      };
      
      completion?(success, error);
      self.onRequestResult?(params);
    };
  };
};

// ----------------------------------
// MARK: Extension: Private Functions
// ----------------------------------

extension RCTModalView {
  
  private func initControllers(){
    #if DEBUG
    print("RCTModalView init - initControllers for modal: \(self.modalID ?? self.modalUUID as NSString)");
    #endif
    
    self.modalVC = {
      let vc = RCTModalViewController();
      vc.modalViewRef = self;
      
      vc.isBGBlurred     = self.isModalBGBlurred;
      vc.isBGTransparent = self.isModalBGTransparent;
      
      if let blurStyle = UIBlurEffect.Style.fromString(self.modalBGBlurEffectStyle) {
        vc.blurEffectStyle = blurStyle;
      };
      
      vc.boundsDidChangeBlock = { [weak self] (newBounds: CGRect) in
        self?.notifyForBoundsChange(newBounds);
      };
      
      return vc;
    }();
    
    self.modalNVC = {
      /// by this time, `modalVC` will already be init. so it's ok to force unwrap
      let nvc = UINavigationController(rootViewController: self.modalVC!);
      nvc.setNavigationBarHidden(true, animated: false);
      
      return nvc;
    }();
  };
  
  private func deinitControllers(){
    #if DEBUG
    print("RCTModalView init - deinitControllers for modal: \(self.modalID ?? self.modalUUID as NSString)");
    #endif
    
    self.modalVC?.reactView = nil;
    self.modalNVC?.viewControllers.removeAll();
    
    self.modalVC  = nil;
    self.modalNVC = nil;
  };
  
  private func notifyForBoundsChange(_ newBounds: CGRect){
    guard (self.isPresented),
      let bridge       = self.bridge,
      let reactSubview = self.reactSubview
    else {
      #if DEBUG
      print("RCTModalView, notifyForBoundsChange: guard check failed");
      #endif
      return;
    };
    
    #if DEBUG
    print("RCTModalView, notifyForBoundsChange - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
    bridge.uiManager.setSize(newBounds.size, for: reactSubview);
  };
  
  private func getTopMostPresentedVC() -> (topLevel: Int, topVC: UIViewController)? {
    guard let rootVC = UIWindow.key?.rootViewController else {
      #if DEBUG
      print("RCTModalView, getTopMostVC Error: could not get root VC. ");
      #endif
      return nil;
    };
    
    var index = 0;
    var topmostVC = rootVC;
    
    // climb the vc hierarchy to find the topmost presented vc
    while topmostVC.presentedViewController != nil {
      if let parent = topmostVC.presentedViewController {
        index += 1;
        topmostVC = parent;
      };
    };
    
    return (index, topmostVC);
  };
  
  private func getPresentedVCList() -> [UIViewController] {
    guard let rootVC = UIWindow.key?.rootViewController else {
      #if DEBUG
      print("RCTModalView, getTopMostVC Error: could not get root VC. ");
      #endif
      return [];
    };
    
    var vcList: [UIViewController] = [];
    vcList.append(rootVC);
    
    // climb the vc hierarchy to find the topmost presented vc
    while let presentedVC = vcList.last?.presentedViewController {
      vcList.append(presentedVC);
    };
    
    return vcList;
  };
  
  private func isModalInFocus() -> Bool {
    guard let (_, vc) = self.getTopMostPresentedVC()
      else { return false };
    
    return vc === self.modalNVC;
  };
  
  private func enableSwipeGesture(_ flag: Bool? = nil){
    self.modalNVC?
        .presentationController?
        .presentedView?
        .gestureRecognizers?[0]
        .isEnabled = flag ?? self.enableSwipeGesture;
  };
  
  private func setIsHiddenForViewBelowLevel(_ level: Int, isHidden: Bool){
    let presentedVCList = self.getPresentedVCList();
    
    for (index, vc) in presentedVCList.enumerated() {
      if index < level {
        vc.view.isHidden = isHidden;
      };
    };
  };
};

// ---------------------------------------------------------
// MARK: Extension: UIAdaptivePresentationControllerDelegate
// ---------------------------------------------------------

extension RCTModalView: UIAdaptivePresentationControllerDelegate {
    
  func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
    if self.hideNonVisibleModals {
      self.setIsHiddenForViewBelowLevel(self.modalLevel, isHidden: false);
    };
    
    self.onModalWillDismiss?([:]);
    
    #if DEBUG
    print("RCTModalView, presentationControllerWillDismiss"
      + " - for reactTag: \(self.reactTag ?? -1)"
    );
    #endif
  };
  
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    self.modalLevel  = -1;
    self.isInFocus   = false;
    self.isPresented = false;
    
    self.onModalDismiss?([:]);
    self.onModalDidDismiss?([:]);
    self.delegate?.onDismissModalView(modalView: self);
    
    self.deinitControllers();
    
    #if DEBUG
    print("RCTModalView, presentationControllerDidDismiss"
      + " - for reactTag: \(self.reactTag ?? -1)"
    );
    #endif
  };
  
  func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
    self.onModalAttemptDismiss?([:]);
    
    #if DEBUG
    print("RCTModalView, presentationControllerDidAttemptToDismiss"
      + " - for reactTag: \(self.reactTag ?? -1)"
    );
    #endif
  };
};

// ------------------------------------------
// MARK: Extension: RCTModalViewFocusDelegate
// ------------------------------------------

extension RCTModalView: RCTModalViewFocusDelegate {
  
  func onModalChangeFocus(modalLevel: Int, modalUUID: String, isInFocus: Bool) {
    guard
      /// defer if the receiver of the event is the same as the sender
      /// i.e defer  if this instance of `RCTModalView` was the one who broadcasted the event
      self.modalUUID != modalUUID,
      /// defer if the modal is not currently presented or if the modalLevel is -1
      self.isPresented && self.modalLevel > 0 else { return };
    
    if isInFocus && self.isInFocus {
      /// a new `RCTModalView` instance is in focus and this modal was prev. in focus so
      /// this modal shoud be now 'blurred'
      self.isInFocus = false;
      self.onModalBlur?([:]);
      
    } else if !isInFocus && !self.isInFocus {
      /// a  `RCTModalView` instance has lost focus, so the prev modal shoul be focused
      /// defer if the receiver's modalLevel isn't 1 value below the sender's modalLevel
      guard self.modalLevel + 1 >= modalLevel else { return };
      
      self.isInFocus = true;
      self.onModalFocus?([:]);
    };
  };
};
