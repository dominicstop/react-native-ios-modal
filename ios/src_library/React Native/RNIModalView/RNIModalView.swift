//
//  RNIModalView.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


class RNIModalView: UIView, RNIModalFocusNotifying, RNIModalIdentity,
                    RNIModalState, RNIModalPresentation {

  typealias CompletionHandler = (_ isSuccess: Bool, _ error: RNIModalViewError?) -> Void;
  
  // MARK: - Properties
  // ------------------

  weak var bridge: RCTBridge?;
  
  private var modalVC: RNIModalViewController?;
  
  private var touchHandler: RCTTouchHandler!;
  private var reactSubview: UIView?;
  
  // MARK: - Properties - RNIModalFocusNotifying
  // -------------------------------------------
  
  var modalFocusDelegate: RNIModalFocusNotifiable!;
  
  // MARK: - Properties - RNIModalIdentity
  // -------------------------------------
  
  var modalIndex: Int!;
  var modalNativeID: String!;
  
  // MARK: - Properties - RNIModalState
  // ----------------------------------
  
  var isModalPresented: Bool = false;
  var isModalInFocus: Bool = false;
  
  
  // MARK: - Properties - RNIModalPresentation
  // -----------------------------------------
  
  var modalViewController: UIViewController? {
    self.modalVC;
  };
  
  weak var presentingViewController: UIViewController?;
  
  // MARK: - Properties: React Props - Events
  // ----------------------------------------
  
  /// RN event callbacks for whenever a modal is presented/dismissed
  /// via functions or from swipe to dismiss gestures
  @objc var onModalShow: RCTDirectEventBlock?;
  @objc var onModalDismiss: RCTDirectEventBlock?;
  
  /// RN event callbacks for: UIAdaptivePresentationControllerDelegate
  /// Note: that these are only invoked in response to dismiss gestures
  @objc var onModalDidDismiss: RCTDirectEventBlock?;
  @objc var onModalWillDismiss: RCTDirectEventBlock?;
  @objc var onModalAttemptDismiss: RCTDirectEventBlock?;
  
  /// RN event callbacks whenever a modal is focused/blurred
  /// note: is not called when the modal is topmost to prevent duplication
  /// of the onModalShow/onModalDismiss events
  @objc var onModalBlur: RCTDirectEventBlock?;
  @objc var onModalFocus: RCTDirectEventBlock?;
  

  // MARK: - Properties: React Props - Value
  // ---------------------------------------
  
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
  
  @objc var modalBGBlurEffectStyle: NSString = "" {
    didSet {
      guard oldValue != self.modalBGBlurEffectStyle
      else { return };
      
      self.modalVC?.blurEffectStyle = self.synthesizedModalBGBlurEffectStyle;
    }
  };
  
  @objc var modalPresentationStyle: NSString = "";
  
  @objc var modalTransitionStyle: NSString = "";
  
  /// user-provided identifier for this modal
  @objc var modalID: NSString? = nil;
  
  /// disable swipe gesture recognizer for this modal
  @objc var enableSwipeGesture: Bool = true {
    didSet {
      let newValue = self.enableSwipeGesture;
      guard newValue != oldValue else { return };
      
      self.enableSwipeGesture(newValue);
    }
  };
  
  @objc var hideNonVisibleModals: Bool = false;
  
  /// control modal present/dismiss by mounting/un-mounting the react subview
  /// * `true`: the modal is presented/dismissed when the view is mounted
  ///   or unmounted
  ///
  /// * `false`: the modal is presented/dismissed by calling the functions from
  ///    js/react
  ///
  @objc var presentViaMount: Bool = false;
  
  /// allow modal to be programmatically closed even when not current focused
  /// * `true`: the modal can be dismissed even when it's not the topmost
  ///    presented modal.
  ///
  /// * `false`: the modal can only be dismissed if it's in focus, otherwise
  ///    error.
  ///
  @objc var allowModalForceDismiss: Bool = true;
  
  @objc var isModalInPresentation: Bool = false {
    willSet {
      if #available(iOS 13.0, *) {
        guard let vc = self.modalVC else { return };
        vc.isModalInPresentation = newValue
      };
    }
  };
  
  // MARK: - Properties: Synthesized From Props
  // ------------------------------------------
  
  var synthesizedModalPresentationStyle: UIModalPresentationStyle {
    let defaultStyle: UIModalPresentationStyle = {
      guard #available(iOS 13.0, *) else { return .overFullScreen };
      return .automatic;
    }();

    guard let style = UIModalPresentationStyle(
      string: self.modalPresentationStyle as String
    ) else {
      #if DEBUG
      print(
          "RNIModalView - synthesizedModalPresentationStyle: Unable to parse "
        + "presentation style string: '\(self.modalPresentationStyle)' - "
        + "using default style: '\(defaultStyle)'"
      );
      #endif
      return defaultStyle;
    };
    
    switch style {
      case .automatic,
           .pageSheet,
           .formSheet,
           .fullScreen,
           .overFullScreen:
        
        return style;

      default:
        #if DEBUG
        print(
            "RNIModalView - synthesizedModalPresentationStyle: Unsupported "
          + "presentation style - '\(self.modalPresentationStyle)' is not a "
          + "supported presentation style - using default style: "
          + "'\(defaultStyle)'"
        );
        #endif
        return defaultStyle;
    };
  };
  
  var synthesizedModalTransitionStyle: UIModalTransitionStyle {
    let defaultStyle: UIModalTransitionStyle = .coverVertical ;
    
    // TODO:2023-03-22-13-18-14 - Refactor: Move `fromString` to enum init
    guard let style = UIModalTransitionStyle.fromString(self.modalTransitionStyle as String)
    else {
      #if DEBUG
      print(
          "RNIModalView - synthesizedModalTransitionStyle: Unsupported "
        + "modalTransitionStyle style string: '\(self.modalPresentationStyle)'"
        + " - using default style: '\(defaultStyle)'"
      );
      #endif
      return defaultStyle;
    };
    
    return style;
  };
  
  var synthesizedModalBGBlurEffectStyle: UIBlurEffect.Style {
    // Provide default value
    let defaultStyle: UIBlurEffect.Style = {
      guard #available(iOS 13.0, *) else { return .light };
      return .systemThinMaterial;
    }();
    
    guard let blurStyle = UIBlurEffect.Style(
      string: self.modalBGBlurEffectStyle as String
    ) else {
      #if DEBUG
      print(
          "RNIModalView - synthesizedModalBGBlurEffectStyle: Unsupported "
        + "modalBGBlurEffectStyle style string: "
        + "'\(self.modalPresentationStyle)' - using default style: "
        + "'\(defaultStyle)'"
      );
      #endif
      return defaultStyle;
    };
    
    return blurStyle;
  };
  
  // MARK: - Properties: Synthesized
  // -------------------------------
  
  var synthesizedBaseEventData: RNIModalBaseEventData {
    RNIModalBaseEventData(
      reactTag: self.reactTag.intValue,
      modalID: self.modalID as? String,
      modalData: self.synthesizedModalData
    );
  };
  
  // MARK: - Init
  // ------------
  
  init(bridge: RCTBridge) {
    super.init(frame: CGRect());
    
    self.bridge = bridge;
    self.touchHandler = RCTTouchHandler(bridge: self.bridge);
    
    RNIModalManagerShared.register(modal: self);
  };
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    fatalError("Not implemented");
  };
  
  // MARK: - UIKit Lifecycle
  // -----------------------
  
  override func layoutSubviews() {
    super.layoutSubviews();
    
    guard
      let modalVC      = self.modalVC,
      let reactSubview = self.reactSubview else { return };
    
    #if DEBUG
    print("RNIModalView, layoutSubviews - for reactTag: \(self.reactTag ?? -1)");
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
  
  // MARK: - React-Native Lifecycle
  // ------------------------------
  
  override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
    
    guard (self.reactSubview == nil) else {
      #if DEBUG
      print("RNIModalView, insertReactSubview: Modal view can only have one subview");
      #endif
      return;
    };
    
    #if DEBUG
    print("RNIModalView, insertReactSubview - for reactTag: \(self.reactTag ?? -1)");
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
    
    // modal contents has been mounted, and is about to be presented so
    // prepare for modal presentation and init the vc's
    self.initControllers();
  };
  
  override func removeReactSubview(_ subview: UIView!) {
    super.removeReactSubview(subview);
    
    guard self.reactSubview == subview else {
      #if DEBUG
      print("RNIModalView, removeReactSubview: Cannot remove view other than modal view");
      #endif
      return;
    };
    
    #if DEBUG
    print("RNIModalView, removeReactSubview - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
    // modal contents has been unmounted so reset react subview
    self.reactSubview = nil;
    self.modalVC?.reactView = nil;
    
    // cleanup
    self.touchHandler.detach(from: subview);
    self.deinitControllers();
  };
  
  // MARK: - Functions - Private
  // ----------------------------
  
  private func initControllers(){
    #if DEBUG
    print(
        "RNIModalView init - initControllers"
      + " - modalNativeID: '\(self.modalNativeID!)'"
    );
    #endif
    
    self.modalVC = {
      let vc = RNIModalViewController();
      vc.modalViewRef = self;
      
      vc.isBGBlurred     = self.isModalBGBlurred;
      vc.isBGTransparent = self.isModalBGTransparent;
      
      vc.blurEffectStyle = self.synthesizedModalBGBlurEffectStyle;
      
      vc.boundsDidChangeBlock = { [weak self] (newBounds: CGRect) in
        self?.notifyForBoundsChange(newBounds);
      };
      
      vc.presentationController?.delegate = self;
      
      return vc;
    }();
  };
  
  /// TODO:2023-03-22-12-18-37 - Refactor: Remove `deinitControllers`
  /// * Refactor so that we don't have to constantly cleanup...
  private func deinitControllers(){
    #if DEBUG
    print(
        "RNIModalView init - deinitControllers"
      + " - modalNativeID: '\(self.modalNativeID!)'"
    );
    #endif
    
    self.modalVC?.reactView = nil;
    
    self.modalVC = nil;
    self.presentingViewController = nil;
  };
  
  private func notifyForBoundsChange(_ newBounds: CGRect){
    guard self.synthesizedIsModalPresented,
          let bridge = self.bridge,
          let reactSubview = self.reactSubview
    else {
      #if DEBUG
      print("RNIModalView, notifyForBoundsChange: guard check failed");
      #endif
      return;
    };
    
    #if DEBUG
    print("RNIModalView, notifyForBoundsChange - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
    bridge.uiManager.setSize(newBounds.size, for: reactSubview);
  };
  
  private func getPresentedVCList() -> [UIViewController] {
    guard let rootVC = UIWindow.key?.rootViewController else {
      #if DEBUG
      print("RNIModalView, getTopMostVC Error: could not get root VC. ");
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
  
  private func enableSwipeGesture(_ flag: Bool? = nil){
    self.modalVC?
        .presentationController?
        .presentedView?
        .gestureRecognizers?[0]
        .isEnabled = flag ?? self.enableSwipeGesture;
  };
  
  
  /// TODO:2023-03-22-12-07-54 - Refactor: Move to `RNIModalManager`
  /// helper func to hide/show the other modals that are below level
  private func setIsHiddenForViewBelowLevel(_ level: Int, isHidden: Bool){
    let presentedVCList = self.getPresentedVCList();
    
    for (index, vc) in presentedVCList.enumerated() {
      if index < level {
        vc.view.isHidden = isHidden;
      };
    };
  };
  
  // MARK: - Functions - Internal
  // ----------------------------
  
  
  // MARK: - Functions - Public
  // --------------------------
  
  public func presentModal(completion: CompletionHandler? = nil) {
    guard self.window != nil else {
      #if DEBUG
      print("RNIModalView - presentModal - guard check failed - no window");
      #endif
      completion?(false, nil);
      return;
    };
    
    guard !self.synthesizedIsModalPresented else {
      #if DEBUG
      print("RNIModalView - presentModal: modal already presented");
      #endif
      completion?(false, .modalAlreadyPresented);
      return;
    };
    
    let presentedViewControllers =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    let lastModalIndex = presentedViewControllers.count - 1;
    
    guard let topMostPresentedVC = presentedViewControllers.last else {
      #if DEBUG
      print("RNIModalView - presentModal: could not get vc");
      #endif
      completion?(false, nil);
      return;
    };
    
    guard let modalVC = self.modalVC else {
      #if DEBUG
      print("RNIModalView - presentModal: could not get modalVC");
      #endif
      completion?(false, nil);
      return;
    };
    
    // weird bug where you cant present fullscreen if `presentationController`
    // delegate is set so only set the delegate when we are using a page sheet
    switch self.synthesizedModalPresentationStyle {
      case .automatic, .pageSheet, .formSheet:
        modalVC.presentationController?.delegate = self;
      default: break;
    };
    
    modalVC.modalTransitionStyle = self.synthesizedModalTransitionStyle;
    modalVC.modalPresentationStyle = self.synthesizedModalPresentationStyle;

    #if DEBUG
    print("RNIModalView, presentModal: Start"
      + " - for reactTag: \(self.reactTag ?? -1)"
      + " - modalIndex: \(self.modalIndex!)"
      + " - modalID: \(self.modalID ?? "N/A")"
      + " - with presentationStyle: \(self.synthesizedModalPresentationStyle)"
      + " - with transitionStyle: \(self.synthesizedModalTransitionStyle)"
    );
    #endif
    
    // Temporarily disable swipe gesture while it's being presented
    self.enableSwipeGesture(false);
    
    self.presentingViewController = topMostPresentedVC;
    
    self.modalFocusDelegate.onModalWillFocusNotification(sender: self);
    
    topMostPresentedVC.present(modalVC, animated: true) {
      if self.hideNonVisibleModals {
        self.setIsHiddenForViewBelowLevel(self.modalIndex - 1, isHidden: true);
      };
      
      // Reset swipe gesture before it was temporarily disabled
      self.enableSwipeGesture();
      
      self.modalFocusDelegate.onModalDidFocusNotification(sender: self);
      
      self.onModalShow?(
        self.synthesizedBaseEventData.synthesizedDictionary
      );
      
      completion?(true, nil);
      
      #if DEBUG
      print("RNIModalView, presentModal: Finished");
      #endif
    };
  };
  
  public func dismissModal(completion: CompletionHandler? = nil) {
    guard self.synthesizedIsModalPresented else {
      #if DEBUG
      print("RNIModalView - dismissModal failed:"
        + " - synthesizedIsModalPresented: \(self.synthesizedIsModalPresented)"
      );
      #endif
      completion?(false, .modalAlreadyDismissed);
      return;
    };
    
    guard let modalVC = self.modalVC else {
      #if DEBUG
      print("RNIModalView, dismissModal failed:"
        + " - `modalVC` is `nil`"
      );
      #endif
      completion?(false, .none);
      return;
    };
    
    let isModalInFocus = self.synthesizedIsModalInFocus;
    
    let shouldDismiss = isModalInFocus
      ? true
      : self.allowModalForceDismiss;
    
    guard shouldDismiss else {
      #if DEBUG
      print("RNIModalView, dismissModal failed: Modal not in focus");
      #endif
      completion?(false, .modalDismissFailedNotInFocus);
      return;
    };
    
    /// TODO:2023-03-22-12-12-05 - Remove?
    let presentedVC: UIViewController = isModalInFocus
      ? modalVC
      : modalVC.presentingViewController!
    
    #if DEBUG
    print("RNIModalView, dismissModal: Start - for reactTag: \(self.reactTag ?? -1)");
    #endif
    
    /// begin temp. hiding modals that are no longer visibile
    if self.hideNonVisibleModals {
      self.setIsHiddenForViewBelowLevel(self.modalIndex, isHidden: false);
    };
    
    self.enableSwipeGesture(false);
    
    presentedVC.dismiss(animated: true){
      self.onModalDismiss?(
        self.synthesizedBaseEventData.synthesizedDictionary
      );
      
      self.deinitControllers();
      completion?(true, nil);
      
      #if DEBUG
      print("RNIModalView, dismissModal: Finished");
      #endif
    };
  };
  
  // MARK: - Functions - Module-Related
  // ----------------------------------
  
  public func setModalVisibility(
    visibility: Bool,
    completion: CompletionHandler? = nil
  ){
    var params: Dictionary<AnyHashable, Any> = [
      "visibility": visibility,
    ];
    
    let baseEventDataDict =
      self.synthesizedBaseEventData.synthesizedDictionary;
    
    baseEventDataDict.forEach { (key, value) in
      params[key] = value
    };
    
    let modalAction = visibility
      ? self.presentModal
      : self.dismissModal;
    
    modalAction() { (success, error) in
      params["success"] = success;
      
      if let errorCode = error {
        params["errorCode"] = errorCode.rawValue;
        params["errorMessage"] = RNIModalViewError.getErrorMessage(for: errorCode);
      };
      
      completion?(success, error);
    };
  };
};

// MARK: - UIAdaptivePresentationControllerDelegate
// ------------------------------------------------

extension RNIModalView: UIAdaptivePresentationControllerDelegate {
    
  func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
    self.modalFocusDelegate.onModalWillBlurNotification(sender: self);
    
    if self.hideNonVisibleModals {
      self.setIsHiddenForViewBelowLevel(self.modalIndex, isHidden: false);
    };
    
    self.onModalWillDismiss?(
      self.synthesizedBaseEventData.synthesizedDictionary
    );
    
    #if DEBUG
    print("RNIModalView, presentationControllerWillDismiss"
      + " - for reactTag: \(self.reactTag ?? -1)"
    );
    #endif
  };
  
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    self.modalFocusDelegate.onModalDidBlurNotification(sender: self);

    self.onModalDidDismiss?(
      self.synthesizedBaseEventData.synthesizedDictionary
    );
    
    self.onModalDismiss?(
      self.synthesizedBaseEventData.synthesizedDictionary
    );
    
    self.deinitControllers();
    
    #if DEBUG
    print("RNIModalView, presentationControllerDidDismiss"
      + " - for reactTag: \(self.reactTag ?? -1)"
    );
    #endif
  };
  
  func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
    self.onModalAttemptDismiss?(
      self.synthesizedBaseEventData.synthesizedDictionary
    );
    
    #if DEBUG
    print("RNIModalView, presentationControllerDidAttemptToDismiss"
      + " - for reactTag: \(self.reactTag ?? -1)"
    );
    #endif
  };
};

// MARK: Extension: RNIModalRequestable
// ------------------------------------

extension RNIModalView: RNIModalRequestable {
  
  func requestModalToShow(sender: RNIModal, onRequestApprovedBlock: () -> Void, onRequestDeniedBlock: (String) -> Void) {
    /// `TODO:2023-03-24-09-58-50` - Refactor `RNIModalView` to use `RNIModalManager`.
    /// No-op - TBA
  };
  
  func requestModalToHide(sender: RNIModal, onRequestApprovedBlock: () -> Void, onRequestDeniedBlock: (String) -> Void) {
    /// `TODO:2023-03-24-09-58-50` - Refactor `RNIModalView` to use `RNIModalManager`.
    /// No-op - TBA
  };
};


// MARK: Extension: RNIModalFocusNotifiable
// ----------------------------------------

extension RNIModalView: RNIModalFocusNotifiable {
  
  func onModalWillFocusNotification(sender modal: RNIModal) {
    /// No-op - TBA
  };
  
  func onModalDidFocusNotification(sender modal: RNIModal) {
    
    let eventData = RNIOnModalFocusEventData(
      modalData: self.synthesizedBaseEventData,
      senderInfo: modal.synthesizedModalData,
      isInitial: modal === self
    );
    
    print(
      "\nRNIModalFocusNotifiable - onModalDidFocusNotification - ",
      "eventData: \(eventData.synthesizedDictionary)\n"
    );
    
    self.onModalFocus?(
      eventData.synthesizedDictionary
    );
  };
  
  func onModalWillBlurNotification(sender modal: RNIModal) {
    /// No-op - TBA
  };
  
  func onModalDidBlurNotification(sender modal: RNIModal) {
    let eventData = RNIOnModalFocusEventData(
      modalData: self.synthesizedBaseEventData,
      senderInfo: modal.synthesizedModalData,
      isInitial: modal === self
    );
    
    print(
      "\nRNIModalFocusNotifiable - onModalDidBlurNotification - ",
      "eventData: \(eventData.synthesizedDictionary)\n"
    );
    
    self.onModalBlur?(
      eventData.synthesizedDictionary
    );
  };
};
