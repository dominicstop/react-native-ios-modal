//
//  RNIModalView.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


class RNIModalView: UIView, RNIIdentifiable, RNIModalFocusNotifying,
                    RNIModalState, RNIModalPresentation {
  
  typealias CompletionHandler = (_ isSuccess: Bool, _ error: RNIModalViewError?) -> Void;
  
  enum NativeIDKey: String {
    case modalViewContent;
  };
  
  // MARK: - Properties - RNIIdentifiable
  // ------------------------------------
  
  static var synthesizedIdPrefix: String = "modal-id-";
  
  // MARK: - Properties
  // ------------------

  weak var bridge: RCTBridge?;
  
  var modalContentWrapper: RNIWrapperView?;
  var modalVC: RNIModalViewController?;
  
  
  // MARK: - Properties - RNIModalFocusNotifying
  // -------------------------------------------
  
  weak var modalFocusDelegate: RNIModalFocusNotifiable!;
  
  // MARK: - Properties - RNIModalIdentity
  // -------------------------------------
  
  var modalIndex: Int!;
  var modalIndexPrev: Int!;
  
  
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
          "Error - RNIModalView.synthesizedModalPresentationStyle"
          + " - self.synthesizedStringID: \(self.synthesizedStringID)"
        + " - Unable to parse presentation style string"
        + " - modalPresentationStyle: '\(self.modalPresentationStyle)'"
        + " - using default style: '\(defaultStyle)'"
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
            "Error - RNIModalView.synthesizedModalPresentationStyle"
          + " - self.synthesizedStringID: \(self.synthesizedStringID)"
          + " - Unsupported presentation style string value"
          + " - modalPresentationStyle: '\(self.modalPresentationStyle)'"
          + " - Using default style: '\(defaultStyle)'"
        );
        #endif
        return defaultStyle;
    };
  };
  
  var synthesizedModalTransitionStyle: UIModalTransitionStyle {
    let defaultStyle: UIModalTransitionStyle = .coverVertical ;
    
    // TODO:2023-03-22-13-18-14 - Refactor: Move `fromString` to enum init
    guard let style =
            UIModalTransitionStyle.fromString(self.modalTransitionStyle as String)
    else {
      #if DEBUG
      print(
          "Error - RNIModalView.synthesizedModalTransitionStyle "
        + " - self.synthesizedStringID: \(self.synthesizedStringID)"
        + " - Unable to parse string value"
        + " - modalPresentationStyle: '\(self.modalPresentationStyle)'"
        + " - Using default style: '\(defaultStyle)'"
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
          "Error - RNIModalView.synthesizedModalBGBlurEffectStyle"
        + " - self.synthesizedStringID: \(self.synthesizedStringID)"
        + " - Unable to parse string value"
        + " - modalPresentationStyle: '\(self.modalPresentationStyle)'"
        + " - Using default style: '\(defaultStyle)'"
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
    RNIModalManagerShared.register(modal: self);
  };
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
    fatalError("Not implemented");
  };
  
  // MARK: - UIKit Lifecycle
  // -----------------------
  
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
    
    guard let wrapperView = subview as? RNIWrapperView,
          let nativeID = subview.nativeID,
          let nativeIDKey = NativeIDKey(rawValue: nativeID)
    else { return };

    self.initControllers();
    wrapperView.isMovingToParent = true;
    
    switch nativeIDKey {
      case .modalViewContent:
        if let oldModalContentWrapper = self.modalContentWrapper,
           wrapperView !== oldModalContentWrapper {
          
          oldModalContentWrapper.cleanup();
          self.modalContentWrapper = nil;
          
          self.deinitControllers();
        };
        
        self.modalContentWrapper = wrapperView;
        self.initControllers();
    };
    
    wrapperView.removeFromSuperview();
    wrapperView.isMovingToParent = false;
  };
  
  override func removeReactSubview(_ subview: UIView!) {
    super.removeReactSubview(subview);
  };
  
  // MARK: - Functions - Private
  // ----------------------------
  
  private func initControllers(){
    #if DEBUG
    print(
        "Log - RNIModalView.initControllers"
      + " - self.synthesizedStringID: '\(self.synthesizedStringID)'"
    );
    #endif
    
    self.modalVC = {
      let vc = RNIModalViewController();
      vc.modalViewRef = self;
      
      vc.isBGBlurred     = self.isModalBGBlurred;
      vc.isBGTransparent = self.isModalBGTransparent;
      
      vc.blurEffectStyle = self.synthesizedModalBGBlurEffectStyle;
      
      return vc;
    }();
  };
  
  private func deinitControllers(){
    #if DEBUG
    print(
        "Log - RNIModalView.deinitControllers"
      + " - self.synthesizedStringID: '\(self.synthesizedStringID)'"
    );
    #endif
    
    self.modalVC = nil;
    self.presentingViewController = nil;
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
    let presentedVCList =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    for (index, vc) in presentedVCList.enumerated() {
      if index < level {
        vc.view.isHidden = isHidden;
      };
    };
  };
  
  // MARK: - Functions - Public
  // --------------------------
  
  public func presentModal(completion: CompletionHandler? = nil) {
    guard self.window != nil else {
      #if DEBUG
      print(
          "Error - RNIModalView.presentModal"
        + " - self.synthesizedStringID: \(self.synthesizedStringID)"
        + " - Guard check failed: no window"
      );
      #endif
      completion?(false, nil);
      return;
    };
    
    guard !self.synthesizedIsModalPresented else {
      #if DEBUG
      print(
          "Error - RNIModalView.presentModal"
        + " - self.synthesizedStringID: \(self.synthesizedStringID)"
        + " - Guard check failed: modal already presented"
      );
      #endif
      completion?(false, .modalAlreadyPresented);
      return;
    };
    
    let presentedViewControllers =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    guard let topMostPresentedVC = presentedViewControllers.last else {
      #if DEBUG
      print(
          "Error - RNIModalView.presentModal"
        + " - self.synthesizedStringID: \(self.synthesizedStringID)"
        + " - Guard check failed: could not get topMostPresentedVC"
      );
      #endif
      completion?(false, nil);
      return;
    };
    
    guard let modalVC = self.modalVC else {
      #if DEBUG
      print(
          "Error - RNIModalView.presentModal"
        + " - self.synthesizedStringID: \(self.synthesizedStringID)"
        + " - Guard check failed: Could not get modalVC"
      );
      #endif
      completion?(false, nil);
      return;
    };
    
    /// `Note:2023-03-30-15-20-27`
    ///
    /// * Weird bug where you cannot present set the modal to present in
    ///   fullscreen if `presentationController` delegate is set.
    ///
    /// * So don't set the delegate when we are using a "fullscreen-like"
    ///   presentation
    ///
    switch self.synthesizedModalPresentationStyle {
      case .overFullScreen,
           .fullScreen:
        // no-op
        break;
        
      default:
        modalVC.presentationController?.delegate = self;
    };
    
    modalVC.modalTransitionStyle = self.synthesizedModalTransitionStyle;
    modalVC.modalPresentationStyle = self.synthesizedModalPresentationStyle;

    #if DEBUG
    print(
        "Log - RNIModalView.presentModal - Start presenting"
      + " - self.reactTag: \(self.reactTag ?? -1)"
      + " - self.synthesizedStringID: \(self.synthesizedStringID)"
      + " - self.modalIndex: \(self.modalIndex!)"
      + " - self.modalID: \(self.modalID ?? "N/A")"
      + " - self.presentationStyle: \(self.synthesizedModalPresentationStyle)"
      + " - self.transitionStyle: \(self.synthesizedModalTransitionStyle)"
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
      print(
          "Log - RNIModalView.presentModal - Present modal finished"
        + " - self.synthesizedStringID: \(self.synthesizedStringID)"
        + " - self.modalIndex: \(self.modalIndex!)"
        + " - self.modalID: \(self.modalID ?? "N/A")"
      );
      #endif
    };
  };
  
  public func dismissModal(completion: CompletionHandler? = nil) {
    guard self.synthesizedIsModalPresented else {
      #if DEBUG
      print(
          "Error - RNIModalView.dismissModal"
        + " - self.synthesizedStringID: \(self.synthesizedStringID)"
        + " - self.modalIndex: \(self.modalIndex!)"
        + " - Guard check failed: Modal presented state unknown"
      );
      #endif
      completion?(false, .modalAlreadyDismissed);
      return;
    };
    
    guard let modalVC = self.modalVC else {
      #if DEBUG
      print(
          "Error - RNIModalView.dismissModal"
        + " - self.synthesizedStringID: \(self.synthesizedStringID)"
        + " - Guard check failed: Unable to get modalVC"
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
      print(
          "Error - RNIModalView.dismissModal"
        + " - self.synthesizedStringID: \(self.synthesizedStringID)"
        + " - Guard check failed: Unable to dismiss"
        + " - shouldDismiss: \(shouldDismiss)"
        + " - isModalInFocus: \(isModalInFocus)"
      );
      #endif
      completion?(false, .modalDismissFailedNotInFocus);
      return;
    };
    
    /// TODO:2023-03-22-12-12-05 - Remove?
    let presentedVC: UIViewController = isModalInFocus
      ? modalVC
      : modalVC.presentingViewController!
    
    
    #if DEBUG
    print(
        "Log - RNIModalView.dismissModal"
      + " - self.synthesizedStringID: \(self.synthesizedStringID)"
      + " - Start dismissing modal"
    );
    #endif
    
    /// begin temp. hiding modals that are no longer visible if needed
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
      print(
          "Log - RNIModalView.dismissModal"
        + " - self.synthesizedStringID: \(self.synthesizedStringID)"
        + " - Dismiss modal finished"
      );
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
    print(
        "Log - RNIModalView.presentationControllerWillDismiss"
      + " - self.synthesizedStringID: \(self.synthesizedStringID)"
      + " - self.modalIndex: \(self.modalIndex!)"
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
    print(
        "Log - RNIModalView.presentationControllerDidDismiss"
      + " - self.synthesizedStringID: \(self.synthesizedStringID)"
    );
    #endif
  };
  
  func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
    self.onModalAttemptDismiss?(
      self.synthesizedBaseEventData.synthesizedDictionary
    );
    
    #if DEBUG
    print(
        "Log - RNIModalView.presentationControllerDidAttemptToDismiss"
      + " - self.synthesizedStringID: \(self.synthesizedStringID)"
      + " - self.modalIndex: \(self.modalIndex!)"
    );
    #endif
  };
};

// MARK: Extension: RNIModalRequestable
// ------------------------------------

extension RNIModalView: RNIModalRequestable {
  
  func requestModalToShow(
    sender:any RNIModal,
    onRequestApprovedBlock: () -> Void,
    onRequestDeniedBlock: (String) -> Void
  ) {
    /// `TODO:2023-03-24-09-58-50` - Refactor `RNIModalView` to use `RNIModalManager`.
    /// No-op - TBA
  };
  
  func requestModalToHide(
    sender: any RNIModal,
    onRequestApprovedBlock: () -> Void,
    onRequestDeniedBlock: (String) -> Void
  ) {
    /// `TODO:2023-03-24-09-58-50` - Refactor `RNIModalView` to use `RNIModalManager`.
    /// No-op - TBA
  };
};


// MARK: Extension: RNIModalFocusNotifiable
// ----------------------------------------

extension RNIModalView: RNIModalFocusNotifiable {
  
  func onModalWillFocusNotification(sender: any RNIModal) {
    /// No-op - TBA
  };
  
  func onModalDidFocusNotification(sender: any RNIModal) {
    
    let eventData = RNIOnModalFocusEventData(
      modalData: self.synthesizedBaseEventData,
      senderInfo: sender.synthesizedModalData,
      isInitial: sender === self
    );
    
    #if DEBUG
    print(
        "Log - RNIModalView.onModalDidFocusNotification"
      + " - self.synthesizedStringID: \(self.synthesizedStringID)"
      + " - self.modalIndex: \(self.modalIndex!)"
      + " - arg modal.synthesizedStringID: \(sender.synthesizedStringID)"
      + " - arg modal.modalIndex: \(sender.modalIndex!)"
    );
    #endif
    
    self.onModalFocus?(
      eventData.synthesizedDictionary
    );
  };
  
  func onModalWillBlurNotification(sender: any RNIModal) {
    /// No-op - TBA
  };
  
  func onModalDidBlurNotification(sender: any RNIModal) {
    let eventData = RNIOnModalFocusEventData(
      modalData: self.synthesizedBaseEventData,
      senderInfo: sender.synthesizedModalData,
      isInitial: sender === self
    );
    
    #if DEBUG
    print(
        "Log - RNIModalView.onModalDidBlurNotification"
      + " - self.synthesizedStringID: \(self.synthesizedStringID)"
      + " - self.modalIndex: \(self.modalIndex!)"
      + " - arg modal.synthesizedStringID: \(sender.synthesizedStringID)"
      + " - arg modal.modalIndex: \(sender.modalIndex!)"
    );
    #endif
    
    self.onModalBlur?(
      eventData.synthesizedDictionary
    );
  };
};
