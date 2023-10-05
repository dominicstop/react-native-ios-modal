//
//  RNIModalView.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import React

public class RNIModalView:
  UIView, RNIIdentifiable, RNIModalIdentifiable, RNIModalPresentationNotifying,
  RNIModalState, RNIModalPresentation {
  
  public typealias CompletionHandler = () -> Void;
  
  enum NativeIDKey: String {
    case modalViewContent;
  };
  
  // MARK: - Properties - RNIIdentifiable
  // ------------------------------------
  
  public static var synthesizedIdPrefix: String = "modal-id-";
  
  // MARK: - Properties
  // ------------------

  weak var bridge: RCTBridge?;
  
  var modalContentWrapper: RNIWrapperView?;
  public var modalVC: RNIModalViewController?;
  
  public var sheetDetentStringCurrent: String?;
  public var sheetDetentStringPrevious: String?;
  
  // MARK: - Properties - RNIModalPresentationNotifying
  // --------------------------------------------------
  
  public weak var modalPresentationNotificationDelegate:
    RNIModalPresentationNotifiable!;
    
  // MARK: - Properties - RNIModalIdentifiable
  // -----------------------------------------
  
  public var modalUserID: String? {
    self.modalID as? String
  };
  
  // MARK: - Properties - RNIModalState
  // ----------------------------------
  
  public var modalIndex: Int!;
  public var modalIndexPrev: Int!;
  
  public lazy var modalPresentationState = RNIModalPresentationStateMachine(
    onDismissWillCancel: { [unowned self] in
      let eventData = self.synthesizedBaseEventData;
      self.onModalDismissWillCancel?(
        eventData.synthesizedJSDictionary
      );
    },

    onDismissDidCancel: { [unowned self] in
      let eventData = self.synthesizedBaseEventData;
      self.onModalDismissDidCancel?(
        eventData.synthesizedJSDictionary
      );
    }
  );
  
  public var modalFocusState = RNIModalFocusStateMachine();
  
  // MARK: - Properties - RNIModalPresentation
  // -----------------------------------------
  
  public var modalViewController: UIViewController? {
    self.modalVC;
  };
  
  public weak var presentingViewController: UIViewController?;
  
  // MARK: - Properties: React Props - Events
  // ----------------------------------------
  
  @objc var onModalWillPresent: RCTBubblingEventBlock?;
  @objc var onModalDidPresent: RCTBubblingEventBlock?;
  
  @objc var onModalWillDismiss: RCTBubblingEventBlock?;
  @objc var onModalDidDismiss: RCTBubblingEventBlock?;
  
  @objc var onModalWillShow: RCTBubblingEventBlock?;
  @objc var onModalDidShow: RCTBubblingEventBlock?;
  
  @objc var onModalWillHide: RCTBubblingEventBlock?;
  @objc var onModalDidHide: RCTBubblingEventBlock?;
  
  @objc var onModalWillFocus: RCTBubblingEventBlock?;
  @objc var onModalDidFocus: RCTBubblingEventBlock?;
  
  @objc var onModalWillBlur: RCTBubblingEventBlock?;
  @objc var onModalDidBlur: RCTBubblingEventBlock?;
  
  @objc var onPresentationControllerWillDismiss: RCTBubblingEventBlock?;
  @objc var onPresentationControllerDidDismiss: RCTBubblingEventBlock?;
  @objc var onPresentationControllerDidAttemptToDismiss: RCTBubblingEventBlock?;
  
  @objc var onModalDetentDidCompute: RCTBubblingEventBlock?;
  @objc var onModalDidChangeSelectedDetentIdentifier: RCTBubblingEventBlock?;
  
  @objc var onModalDidSnap: RCTBubblingEventBlock?;
  
  @objc var onModalSwipeGestureStart: RCTBubblingEventBlock?;
  @objc var onModalSwipeGestureDidEnd: RCTBubblingEventBlock?;
  
  @objc var onModalDismissWillCancel: RCTBubblingEventBlock?;
  @objc var onModalDismissDidCancel: RCTBubblingEventBlock?;
  
  // MARK: - Properties: React Props - General
  // -----------------------------------------
    
  /// user-provided identifier for this modal
  @objc var modalID: NSString? = nil;
  
  @objc var modalContentPreferredContentSize: NSDictionary? {
    didSet {
      self.modalVC?.setPreferredContentSize(withWindow: self.window);
    }
  };
  
  // MARK: - Properties: React Props - BG-Related
  // --------------------------------------------
  
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
  
  // MARK: - Properties: React Props - Presentation/Transition
  // ---------------------------------------------------------
  
  @objc var modalPresentationStyle: NSString = "";
  
  @objc var modalTransitionStyle: NSString = "";
  
  @objc var hideNonVisibleModals: Bool = false;
  
  /// control modal present/dismiss by mounting/un-mounting the react subview
  /// * `true`: the modal is presented/dismissed when the view is mounted
  ///   or unmounted
  ///
  /// * `false`: the modal is presented/dismissed by calling the functions from
  ///    js/react
  ///
  @objc var presentViaMount: Bool = false;
  
  /// disable swipe gesture recognizer for this modal
  @objc var enableSwipeGesture: Bool = true {
    didSet {
      let newValue = self.enableSwipeGesture;
      guard newValue != oldValue else { return };
      
      self.modalGestureRecognizer?.isEnabled = newValue;
    }
  };
  
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
      guard #available(iOS 13.0, *),
            let vc = self.modalVC
      else { return };
      
      vc.isModalInPresentation = newValue
    }
  };
 
  // MARK: - Properties: React Props - Sheet-Related
  // -----------------------------------------------
  
  @objc var modalSheetDetents: NSArray?;
  
  @objc var sheetPrefersScrollingExpandsWhenScrolledToEdge: Bool = true {
    willSet {
      guard #available(iOS 15.0, *),
            let sheetController = self.sheetPresentationController
      else { return };
      
      sheetController.prefersScrollingExpandsWhenScrolledToEdge = newValue;
    }
  };
  
  @objc var sheetPrefersEdgeAttachedInCompactHeight: Bool = false {
    willSet {
      guard #available(iOS 15.0, *),
            let sheetController = self.sheetPresentationController
      else { return };
      
      self.sheetAnimateChangesIfNeeded {
        sheetController.prefersEdgeAttachedInCompactHeight = newValue;
      };
    }
  };
  
  @objc var sheetWidthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false {
    willSet {
      guard #available(iOS 15.0, *),
            let sheetController = self.sheetPresentationController
      else { return };
      
      sheetController
        .widthFollowsPreferredContentSizeWhenEdgeAttached = newValue;
    }
  };
  
  @objc var sheetPrefersGrabberVisible: Bool = false {
    willSet {
      guard #available(iOS 15.0, *),
            let sheetController = self.sheetPresentationController
      else { return };
      
      self.sheetAnimateChangesIfNeeded {
        sheetController.prefersGrabberVisible = newValue;
      };
    }
  };
  
  @objc var sheetShouldAnimateChanges: Bool = true;
  
  @objc var sheetLargestUndimmedDetentIdentifier: String? {
    didSet {
      guard #available(iOS 15.0, *),
            let sheetController = self.sheetPresentationController
      else { return };
      
      self.sheetAnimateChangesIfNeeded {
        sheetController.largestUndimmedDetentIdentifier =
          self.synthesizedSheetLargestUndimmedDetentIdentifier;
      };
    }
  };
  
  @objc var sheetPreferredCornerRadius: NSNumber? {
    didSet {
      let newValue = self.sheetPreferredCornerRadius;
      
      guard #available(iOS 15.0, *),
            oldValue != newValue,
            let sheetController = self.sheetPresentationController,
            let cornerRadius = newValue?.doubleValue
      else { return };
      
      self.sheetAnimateChangesIfNeeded {
        sheetController.preferredCornerRadius = cornerRadius;
      };
    }
  };
  
  @objc var sheetSelectedDetentIdentifier: String? {
    didSet {
      let newValue = self.sheetSelectedDetentIdentifier;
      
      guard oldValue != newValue,
            #available(iOS 15.0, *),
            let sheetController = self.sheetPresentationController
      else { return };
      
      let nextDetentID = self.synthesizedSheetSelectedDetentIdentifier;
      
      self.sheetAnimateChangesIfNeeded {
        sheetController.selectedDetentIdentifier = nextDetentID;
      };
      
      /// Delegate function does not get called when detent is changed via
      /// setting `selectedDetentIdentifier`, so invoke manually...
      ///
      self.sheetPresentationControllerDidChangeSelectedDetentIdentifier(
        sheetController
      );
    }
  };
  
  // MARK: - Properties: Synthesized From Props
  // ------------------------------------------
  
  public var synthesizedModalContentPreferredContentSize: RNIComputableSize? {
    guard let dict = self.modalContentPreferredContentSize,
          let computableSize = RNIComputableSize(fromDict: dict)
    else { return nil };
    
    return computableSize;
  };
  
  public var synthesizedModalPresentationStyle: UIModalPresentationStyle {
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
          + " - self.modalNativeID: \(self.modalNativeID)"
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
          + " - self.modalNativeID: \(self.modalNativeID)"
          + " - Unsupported presentation style string value"
          + " - modalPresentationStyle: '\(self.modalPresentationStyle)'"
          + " - Using default style: '\(defaultStyle)'"
        );
        #endif
        return defaultStyle;
    };
  };
  
  public var synthesizedModalTransitionStyle: UIModalTransitionStyle {
    let defaultStyle: UIModalTransitionStyle = .coverVertical ;
    
    // TODO:2023-03-22-13-18-14 - Refactor: Move `fromString` to enum init
    guard let style =
            UIModalTransitionStyle.fromString(self.modalTransitionStyle as String)
    else {
      #if DEBUG
      print(
          "Error - RNIModalView.synthesizedModalTransitionStyle "
        + " - self.modalNativeID: \(self.modalNativeID)"
        + " - Unable to parse string value"
        + " - modalPresentationStyle: '\(self.modalPresentationStyle)'"
        + " - Using default style: '\(defaultStyle)'"
      );
      #endif
      return defaultStyle;
    };
    
    return style;
  };
  
  public var synthesizedModalBGBlurEffectStyle: UIBlurEffect.Style {
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
        + " - self.modalNativeID: \(self.modalNativeID)"
        + " - Unable to parse string value"
        + " - modalPresentationStyle: '\(self.modalPresentationStyle)'"
        + " - Using default style: '\(defaultStyle)'"
      );
      #endif
      return defaultStyle;
    };
    
    return blurStyle;
  };
  
  @available(iOS 15.0, *)
  public var synthesizedModalSheetDetents: [UISheetPresentationController.Detent]? {
    self.modalSheetDetents?.compactMap {
      if let string = $0 as? String,
         let detent = UISheetPresentationController.Detent.fromString(string) {
        
        return detent;
        
      } else if #available(iOS 16.0, *),
                let dict = $0 as? Dictionary<String, Any> {
        
        let customDetent = RNIModalCustomSheetDetent(forDict: dict) {
          _, maximumDetentValue, computedDetentValue, sender in
          
          let eventData = RNIModalDetentDidComputeEventData(
            maximumDetentValue: maximumDetentValue,
            computedDetentValue: computedDetentValue,
            key: sender.key
          );
          
          self.onModalDetentDidCompute?(
            eventData.synthesizedJSDictionary
          );
        };
        
        return customDetent?.synthesizedDetent;
      };
      
      return nil;
    };
  };
  
  @available(iOS 15.0, *)
  public var synthesizedSheetLargestUndimmedDetentIdentifier:
    UISheetPresentationController.Detent.Identifier? {
    
    guard let identifierString = self.sheetLargestUndimmedDetentIdentifier
    else { return nil };
      
    return UISheetPresentationController.Detent.Identifier(
      fromString: identifierString
    );
  };
  
  @available(iOS 15.0, *)
  public var synthesizedSheetSelectedDetentIdentifier:
    UISheetPresentationController.Detent.Identifier? {
    
    guard let identifierString = self.sheetSelectedDetentIdentifier
    else { return nil };
      
    return UISheetPresentationController.Detent.Identifier(
      fromString: identifierString
    );
  };
  
  // MARK: - Properties: Synthesized
  // -------------------------------
  
  public var synthesizedBaseEventData: RNIModalBaseEventData {
    RNIModalBaseEventData(
      reactTag: self.reactTag.intValue,
      modalID: self.modalID as? String,
      modalData: self.synthesizedModalData
    );
  };
  
  // MARK: - Properties: Computed
  // ----------------------------
  
  // TODO: Move to `RNIModal+Helpers`
  @available(iOS 15.0, *)
  var sheetPresentationController: UISheetPresentationController? {
    guard let presentedVC = self.modalViewController else { return nil };
    
    switch presentedVC.modalPresentationStyle {
      case .popover:
        return presentedVC.popoverPresentationController?
          .adaptiveSheetPresentationController;
        
      case .automatic,
           .formSheet,
           .pageSheet:
        return presentedVC.sheetPresentationController;
        
      default:
        return nil;
    };
  };
  
  @available(iOS 15.0, *)
  var currentSheetDetentID: UISheetPresentationController.Detent.Identifier? {
    guard let sheetController = self.sheetPresentationController
    else { return nil };
    
    let detents = sheetController.detents;
    
    if let selectedDetent = sheetController.selectedDetentIdentifier {
      return selectedDetent;
      
    } else if #available(iOS 16.0, *),
              let firstDetent = detents.first {
      
      ///  The default value of `selectedDetentIdentifier` is nil, which means
      ///  the sheet displays at the smallest detent you specify in detents.
      return firstDetent.identifier;
    };
    
    return nil;
  };
  
  var currentSheetDetentString: String? {
    guard #available(iOS 15.0, *) else { return nil };
    return currentSheetDetentID?.rawValue;
  };
  
  var isModalViewPresentationNotificationEnabled: Bool {
    RNIModalFlagsShared.isModalViewPresentationNotificationEnabled
  };
  
  var modalGestureRecognizer: UIGestureRecognizer? {
    guard let modalVC = self.modalVC,
          let controller = modalVC.presentationController,
          let gestureRecognizers = controller.presentedView?.gestureRecognizers
    else { return nil };
    
    return gestureRecognizers.first;
  };
  
  var debugData: Dictionary<String, Any> {
    self.synthesizedModalData.synthesizedJSDictionary
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
  
  public override func didMoveToWindow() {
    super.didMoveToWindow();

    if self.presentViaMount {
      try? self.dismissModal();
    };
  };
  
  public override func didMoveToSuperview() {
    super.didMoveToSuperview();

    if self.presentViaMount {
      try? self.presentModal();
    };
  };
  
  // MARK: - React-Native Lifecycle
  // ------------------------------
  
  public override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
    
    guard let wrapperView = subview as? RNIWrapperView,
          let nativeID = subview.nativeID,
          let nativeIDKey = NativeIDKey(rawValue: nativeID)
    else { return };

    self.initControllers();
    wrapperView.isMovingToParent = true;
    
    switch nativeIDKey {
      case .modalViewContent:
        guard self.modalContentWrapper !== wrapperView,
              self.modalContentWrapper?.reactTag != wrapperView.reactTag
        else { return };
        
        if let oldModalContentWrapper = self.modalContentWrapper {
          
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
  
  public override func removeReactSubview(_ subview: UIView!) {
    super.removeReactSubview(subview);
  };
  
  // MARK: - Functions - Private
  // ----------------------------
  
  private func initControllers(){
    #if DEBUG
    print(
        "Log - RNIModalView.initControllers"
      + " - self.modalNativeID: '\(self.modalNativeID)'"
    );
    #endif
    
    self.modalVC = {
      let vc = RNIModalViewController();
      
      vc.modalViewRef = self;
      vc.lifecycleDelegate = self;
      
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
      + " - self.modalNativeID: '\(self.modalNativeID)'"
    );
    #endif
    
    self.modalVC = nil;
    self.presentingViewController = nil;
  };
  
  private func setupOnModalInitialPresent(){
    guard let panGesture = self.modalGestureRecognizer else { return };
    
    panGesture.addTarget(self,
      action: #selector(Self.handleGestureRecognizer(_:))
    );
  };
  
  private func notifyIfModalDismissCancelled(){
    guard let modalVC = self.modalVC,
          let transitionCoordinator = modalVC.transitionCoordinator
    else { return };
  
    transitionCoordinator.notifyWhenInteractionChanges {
      guard $0.isCancelled else { return };
      
      self.modalPresentationState.set(state: .DISMISS_GESTURE_CANCELLING);
      self.modalPresentationState.wasCancelledDismissViaGesture = true;
      
      self.modalPresentationNotificationDelegate
        .notifyOnModalWillShow(sender: self);
    };
    
    self.modalVC?.transitionCoordinator?.animate(alongsideTransition: nil) {
      guard $0.isCancelled else { return };
      
      self.modalPresentationNotificationDelegate
        .notifyOnModalDidShow(sender: self);
    };
  };
  
  @objc private func handleGestureRecognizer(_ sender: UIGestureRecognizer) {
    guard let window = self.window else { return };
    
    switch sender.state {
      case .began:
        let gestureEventData = RNIModalSwipeGestureEventData(
          position: sender.location(in: window)
        );
        
        self.onModalSwipeGestureStart?(
          gestureEventData.synthesizedJSDictionary
        );
        
      case .ended:
        let gestureEventData = RNIModalSwipeGestureEventData(
          position: sender.location(in: window)
        );
        
        self.onModalSwipeGestureDidEnd?(
          gestureEventData.synthesizedJSDictionary
        );
      
        guard let presentationController = self.modalVC?.presentationController,
              let presentedView = presentationController.presentedView,
              let positionAnimation =
                presentedView.layer.animation(forKey: "position")
        else { break };
        
        positionAnimation.waitUntiEnd {
          let eventData = RNIModalDidSnapEventData(
            selectedDetentIdentifier: self.currentSheetDetentString,
            modalContentSize: presentedView.bounds.size
          );
          
          self.onModalDidSnap?(
            eventData.synthesizedJSDictionary
          );
       };
       
      default: break;
    };
  };
  
  /// `TODO:2023-03-22-12-07-54`
  /// * Refactor: Move to `RNIModalManager`
  ///
  /// helper func to hide/show the other modals that are below level
  private func setIsHiddenForViewBelowLevel(_ level: Int, isHidden: Bool){
    let presentedVCList =
      RNIPresentedVCListCache.getPresentedViewControllers(forWindow: window);
    
    for (index, vc) in presentedVCList.enumerated() {
      if index < level {
        vc.view.isHidden = isHidden;
      };
    };
  };
  
  @available(iOS 15.0, *)
  private func sheetAnimateChangesIfNeeded(_ block: () -> Void){
    guard let sheetController = self.sheetPresentationController
    else { return };
    
    if self.sheetShouldAnimateChanges {
      sheetController.animateChanges {
        block();
      };
      
    } else {
      block();
    };
  };
  
  @available(iOS 15.0, *)
  private func applyModalSheetProps(
    to sheetController: UISheetPresentationController
  ){
    
    if let detents = self.synthesizedModalSheetDetents, detents.count >= 1 {
      sheetController.detents = detents;
    };
    
    sheetController.prefersScrollingExpandsWhenScrolledToEdge =
      self.sheetPrefersScrollingExpandsWhenScrolledToEdge;
    
    sheetController.prefersEdgeAttachedInCompactHeight =
      self.sheetPrefersEdgeAttachedInCompactHeight;
    
    sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached =
      self.sheetWidthFollowsPreferredContentSizeWhenEdgeAttached;
    
    sheetController.prefersGrabberVisible = self.sheetPrefersGrabberVisible;
    
    sheetController.largestUndimmedDetentIdentifier =
      self.synthesizedSheetLargestUndimmedDetentIdentifier;
    
    if let cornerRadius = self.sheetPreferredCornerRadius?.doubleValue {
      sheetController.preferredCornerRadius = cornerRadius;
    };
    
    sheetController.selectedDetentIdentifier =
      self.synthesizedSheetSelectedDetentIdentifier;
  };
  
  // MARK: - Functions - Public
  // --------------------------
  
  public func presentModal(
    animated: Bool = true,
    completion: CompletionHandler? = nil
  ) throws {
    guard self.window != nil else {
      throw RNIModalError(
        code: .runtimeError,
        message: "Guard check failed, window is nil",
        debugData: self.debugData
      );
    };
    
    guard !self.computedIsModalPresented else {
      throw RNIModalError(
        code: .modalAlreadyVisible,
        message: "Guard check failed, modal already presented",
        debugData: self.debugData
      );
    };
    
    let presentedViewControllers =
      RNIPresentedVCListCache.getPresentedViewControllers(forWindow: window);
    
    guard let topMostPresentedVC = presentedViewControllers.last else {
      throw RNIModalError(
        code: .runtimeError,
        message: "Guard check failed, could not get topMostPresentedVC",
        debugData: self.debugData
      );
    };
    
    guard let modalVC = self.modalVC else {
      throw RNIModalError(
        code: .runtimeError,
        message: "Guard check failed, could not get modalVC",
        debugData: self.debugData
      );
    };
    
    modalVC.modalTransitionStyle = self.synthesizedModalTransitionStyle;
    modalVC.modalPresentationStyle = self.synthesizedModalPresentationStyle;
    
    if #available(iOS 15.0, *),
       let sheetController = self.sheetPresentationController {
       
      sheetController.delegate = self;
      self.applyModalSheetProps(to: sheetController);
    };

    #if DEBUG
    print(
        "Log - RNIModalView.presentModal - Start presenting"
      + " - self.reactTag: \(self.reactTag ?? -1)"
      + " - self.modalNativeID: \(self.modalNativeID)"
      + " - self.modalIndex: \(self.modalIndex!)"
      + " - self.modalID: \(self.modalID ?? "N/A")"
      + " - self.presentationStyle: \(self.synthesizedModalPresentationStyle)"
      + " - self.transitionStyle: \(self.synthesizedModalTransitionStyle)"
    );
    #endif
    
    // Temporarily disable swipe gesture while it's being presented
    self.modalGestureRecognizer?.isEnabled = false;
    
    self.presentingViewController = topMostPresentedVC;
    
    /// set specific "presenting" state
    self.modalPresentationState.set(state: .PRESENTING_PROGRAMMATIC);
    
    self.onModalWillPresent?(
      self.synthesizedBaseEventData.synthesizedJSDictionary
    );
    
    topMostPresentedVC.present(modalVC, animated: animated) { [unowned self] in
      
      // Become the modal's presentation delegate after it has been presented
      // in order to not override system-defined default modal behavior
      modalVC.presentationController?.delegate = self;
      
      // Reset swipe gesture before it was temporarily disabled
      self.modalGestureRecognizer?.isEnabled = self.enableSwipeGesture;
      
      self.modalPresentationState.set(state: .PRESENTED);
      
      self.onModalDidPresent?(
        self.synthesizedBaseEventData.synthesizedJSDictionary
      );
      
      completion?();

      #if DEBUG
      print(
          "Log - RNIModalView.presentModal - Present modal finished"
        + " - self.modalNativeID: \(self.modalNativeID)"
        + " - self.modalIndex: \(self.modalIndex!)"
        + " - self.modalID: \(self.modalID ?? "N/A")"
      );
      #endif
    };
  };
  
  public func dismissModal(
    animated: Bool = true,
    completion: CompletionHandler? = nil
  ) throws {
    guard self.computedIsModalPresented else {
      throw RNIModalError(
        code: .modalAlreadyHidden,
        message: "Guard check failed, modal already dismissed",
        debugData: self.debugData
      );
    };
    
    guard let modalVC = self.modalVC else {
      throw RNIModalError(
        code: .runtimeError,
        message: "Guard check failed, Unable to get modalVC",
        debugData: self.debugData
      );
    };
    
    let isModalInFocus = self.computedIsModalInFocus;
    
    let shouldDismiss = isModalInFocus
      ? true
      : self.allowModalForceDismiss;
    
    guard shouldDismiss else {
      throw RNIModalError(
        code: .dismissRejected,
        message: "Guard check failed, shouldDismiss prop is false",
        debugData: self.debugData
      );
    };
    
    /// TODO:2023-03-22-12-12-05 - Remove?
    let presentedVC: UIViewController = isModalInFocus
      ? modalVC
      : modalVC.presentingViewController!
    
    
    #if DEBUG
    print(
        "Log - RNIModalView.dismissModal"
      + " - self.modalNativeID: \(self.modalNativeID)"
      + " - Start dismissing modal"
    );
    #endif

    self.modalGestureRecognizer?.isEnabled = false;
    
    /// set specific "dismissing" state
    self.modalPresentationState.set(state: .DISMISSING_PROGRAMMATIC);
    
    self.onModalWillDismiss?(
      self.synthesizedBaseEventData.synthesizedJSDictionary
    );
    
    presentedVC.dismiss(animated: animated){
      self.modalPresentationState.set(state: .DISMISSED);
      
      self.onModalDidDismiss?(
        self.synthesizedBaseEventData.synthesizedJSDictionary
      );
      
      completion?();
      
      #if DEBUG
      print(
          "Log - RNIModalView.dismissModal"
        + " - self.modalNativeID: \(self.modalNativeID)"
        + " - Dismiss modal finished"
      );
      #endif
    };
  };
};

// MARK: - UIAdaptivePresentationControllerDelegate
// ------------------------------------------------

/// `Note:2023-03-31-16-48-10`
///
/// * The "blur/focus"-related events in
///   `UIAdaptivePresentationControllerDelegate` only fire in response to user
///   gestures (i.e. if the user swiped the modal away).
///
/// * In other words, if the modal was closed programmatically, the
///   `UIAdaptivePresentationControllerDelegate`-related events will not get
///   invoked.
///
extension RNIModalView: UIAdaptivePresentationControllerDelegate {
  
  /// `Note:2023-03-31-17-01-57`
  ///
  /// * This gets called whenever the user starts swiping the modal down,
  ///   regardless of whether or not the swipe action was cancelled half-way
  ///   through.
  ///
  /// * Only called when the sheet is dismissed by DRAGGING.
  ///
  ///
  /// `Note:2023-04-01-14-52-05`
  ///
  /// * Invocation history when a modal is dismissed via a swipe gesture, but
  ///   was cancelled half-way
  ///
  ///   * A - Swipe dismiss gesture begin...
  ///   * 1 - `presentationControllerWillDismiss
  ///   * 2 - `viewWillDisappear`
  ///   * B - Swipe dismiss gesture cancelled...
  ///   * 3 - `viewWillAppear`
  ///   * 4 - `viewDidAppear`
  ///
  public func presentationControllerWillDismiss(
    _ presentationController: UIPresentationController
  ) {
    self.modalPresentationState.set(state: .DISMISSING_GESTURE);
    
    #if DEBUG
    print(
        "Log - RNIModalView+UIAdaptivePresentationControllerDelegate"
      + " - RNIModalView.presentationControllerWillDismiss"
      + " - self.modalNativeID: \(self.modalNativeID)"
      + " - self.modalIndex: \(self.modalIndex!)"
    );
    #endif
  };
  
  public func presentationControllerDidDismiss(
    _ presentationController: UIPresentationController
  ) {
    self.modalPresentationNotificationDelegate
      .notifyOnModalDidHide(sender: self);
    
    #if DEBUG
    print(
        "Log - RNIModalView+UIAdaptivePresentationControllerDelegate"
      + " - RNIModalView.presentationControllerDidDismiss"
      + " - self.modalNativeID: \(self.modalNativeID)"
    );
    #endif
  };
  
  /// `Note:2023-04-07-01-28-57`
  /// No other "view controller"-related lifecycle method was trigger in
  /// response to this event being invoked.
  ///
  public func presentationControllerDidAttemptToDismiss(
    _ presentationController: UIPresentationController
  ) {

    #if DEBUG
    print(
        "Log - RNIModalView+UIAdaptivePresentationControllerDelegate"
      + " - RNIModalView.presentationControllerDidAttemptToDismiss"
      + " - self.modalNativeID: \(self.modalNativeID)"
      + " - self.modalIndex: \(self.modalIndex!)"
    );
    #endif
  };
};

// MARK: - UISheetPresentationControllerDelegate
// ---------------------------------------------

@available(iOS 15.0, *)
extension RNIModalView: UISheetPresentationControllerDelegate {
  
  /// `Note:2023-04-22-03-50-59`
  ///
  /// * This function gets invoked when the sheet has snapped into a detent
  ///
  /// * However, we don't get notified whenever the user is currently dragging
  ///   the sheet.
  ///
  /// * The `presentedViewController.transitionCoordinator` is only available
  ///   during modal presentation and dismissal.
  ///
  ///
  public func sheetPresentationControllerDidChangeSelectedDetentIdentifier(
    _ sheetPresentationController: UISheetPresentationController
  ) {
    let currentDetentID = self.currentSheetDetentID;
    
    self.sheetDetentStringPrevious = self.sheetDetentStringCurrent;
    self.sheetDetentStringCurrent = currentDetentID?.description;
    
    #if DEBUG
    print(
        "Log - RNIModalView+UISheetPresentationControllerDelegate"
      + " - sheetPresentationControllerDidChangeSelectedDetentIdentifier"
      + " - sheetDetentStringPrevious: \(self.sheetDetentStringPrevious ?? "N/A")"
      + " - sheetDetentStringCurrent: \(self.sheetDetentStringCurrent ?? "N/A")"
    );
    #endif
    
    let eventData = RNIModalDidChangeSelectedDetentIdentifierEventData(
      sheetDetentStringPrevious: self.sheetDetentStringPrevious,
      sheetDetentStringCurrent: self.sheetDetentStringCurrent
    );
    
    self.onModalDidChangeSelectedDetentIdentifier?(
      eventData.synthesizedJSDictionary
    );
  };
};

// MARK: Extension: RNIModalRequestable
// ------------------------------------

extension RNIModalView: RNIModalRequestable {
  
  public func requestModalToShow(
    sender: Any,
    animated: Bool,
    completion: @escaping () -> Void
  ) throws {
    try self.presentModal(animated: animated, completion: completion);
  };
  
  public func requestModalToHide(
    sender: Any,
    animated: Bool,
    completion: @escaping () -> Void
  ) throws {
    try self.dismissModal(animated: animated, completion: completion);
  };
};

// MARK: - RNIViewControllerLifeCycleNotifiable
// --------------------------------------------

extension RNIModalView: RNIViewControllerLifeCycleNotifiable {
  
  public func viewWillAppear(sender: UIViewController, animated: Bool) {
    guard sender.isBeingPresented else { return };
    self.modalPresentationState.set(state: .PRESENTING_UNKNOWN);
    
    if self.modalPresentationState.didChange {
      self.onModalWillShow?(
        self.synthesizedBaseEventData.synthesizedJSDictionary
      );
    };
    
    if self.isModalViewPresentationNotificationEnabled {
      self.modalPresentationNotificationDelegate
        .notifyOnModalWillShow(sender: self);
    };
    
    if self.modalPresentationState.isInitialPresent {
      self.setupOnModalInitialPresent();
    };
  };
  
  public func viewDidAppear(sender: UIViewController, animated: Bool) {
    guard sender.isBeingPresented else { return };
    self.modalPresentationState.set(state: .PRESENTED_UNKNOWN);
    
    if self.modalPresentationState.didChange {
      self.onModalDidShow?(
        self.synthesizedBaseEventData.synthesizedJSDictionary
      );
    };
    
    if self.isModalViewPresentationNotificationEnabled {
      self.modalPresentationNotificationDelegate
        .notifyOnModalDidShow(sender: self);
    };
  };
  
  public func viewWillDisappear(sender: UIViewController, animated: Bool) {
    guard sender.isBeingDismissed else { return };
    self.modalPresentationState.set(state: .DISMISSING_UNKNOWN);
    
    if self.modalPresentationState.didChange {
      self.onModalWillHide?(
        self.synthesizedBaseEventData.synthesizedJSDictionary
      );
    };
    
    if self.isModalViewPresentationNotificationEnabled {
      self.modalPresentationNotificationDelegate
        .notifyOnModalWillHide(sender: self);
    };
    
    self.notifyIfModalDismissCancelled();
  };
  
  public func viewDidDisappear(sender: UIViewController, animated: Bool) {
    guard sender.isBeingDismissed else { return };
    self.modalPresentationState.set(state: .DISMISSED);
    
    if self.modalPresentationState.didChange {
      self.onModalDidHide?(
        self.synthesizedBaseEventData.synthesizedJSDictionary
      );
    };
    
    if self.isModalViewPresentationNotificationEnabled {
      self.modalPresentationNotificationDelegate
        .notifyOnModalDidHide(sender: self);
    };
    
    self.deinitControllers();
  };
};


// MARK: Extension: RNIModalFocusNotifiable
// ----------------------------------------

/// `Note:2023-03-31-17-51-56`
extension RNIModalView: RNIModalFocusNotifiable {
  
  public func onModalWillFocusNotification(sender: any RNIModal) {
    guard self.modalFocusState.didChange else { return };
    
    let eventData = RNIOnModalFocusEventData(
      modalData: self.synthesizedBaseEventData,
      senderInfo: sender.synthesizedModalData,
      isInitial: sender === self
    );
    
    self.onModalWillFocus?(
      eventData.synthesizedJSDictionary
    );
  };
  
  public func onModalDidFocusNotification(sender: any RNIModal) {
    guard self.modalFocusState.didChange else { return };
    
    let eventData = RNIOnModalFocusEventData(
      modalData: self.synthesizedBaseEventData,
      senderInfo: sender.synthesizedModalData,
      isInitial: sender === self
    );
    
    self.onModalDidFocus?(
      eventData.synthesizedJSDictionary
    );
    
    #if DEBUG
    print(
        "Log - RNIModalView.onModalDidFocusNotification"
      + " - self.modalNativeID: \(self.modalNativeID)"
      + " - self.modalIndex: \(self.modalIndex!)"
      + " - arg sender.modalNativeID: \(sender.modalNativeID)"
      + " - arg sender.modalIndex: \(sender.modalIndex!)"
    );
    #endif
    
  };
  
  public func onModalWillBlurNotification(sender: any RNIModal) {
    guard self.modalFocusState.didChange else { return };
    
    let eventData = RNIOnModalFocusEventData(
      modalData: self.synthesizedBaseEventData,
      senderInfo: sender.synthesizedModalData,
      isInitial: sender === self
    );
    
    self.onModalWillBlur?(
      eventData.synthesizedJSDictionary
    );
  };
  
  public func onModalDidBlurNotification(sender: any RNIModal) {
    guard self.modalFocusState.didChange else { return };
    
    let eventData = RNIOnModalFocusEventData(
      modalData: self.synthesizedBaseEventData,
      senderInfo: sender.synthesizedModalData,
      isInitial: sender === self
    );
    
    self.onModalDidBlur?(
      eventData.synthesizedJSDictionary
    );
    
    #if DEBUG
    print(
        "Log - RNIModalView.onModalDidBlurNotification"
      + " - self.modalNativeID: \(self.modalNativeID)"
      + " - self.modalIndex: \(self.modalIndex!)"
      + " - arg sender.modalNativeID: \(sender.modalNativeID)"
      + " - arg sender.modalIndex: \(sender.modalIndex!)"
    );
    #endif
  };
};
