//
//  ModalSheetViewControllerLifecycleNotifier.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import UIKit
import DGSwiftUtilities


open class ModalSheetViewControllerLifecycleNotifier: ViewControllerLifecycleNotifier {

  private var _didSetup = false;
  
  private(set) public var sheetLifecycleEventDelegates:
    MulticastDelegate<SheetViewControllerEventsNotifiable> = .init();
    
  /// The return value used for
  /// `UIAdaptivePresentationControllerDelegate.presentationControllerShouldDismiss`
  ///
  public var shouldAllowDismissal = true;
  
  /// Will receive `UIAdaptivePresentationControllerDelegate` invocations
  /// that were not handled by this class
  ///
  public var presentationControllerDelegateProxy: UIAdaptivePresentationControllerDelegate?;
  
  public weak var sheetGesture: UIPanGestureRecognizer?;
  public weak var sheetDropShadowView: UIView?;
    
  // MARK: - View Controller Lifecycle
  // ---------------------------------
  
  public override func viewDidLoad() {
    super.viewDidLoad();
    self.setupIfNeeded();
  };
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    self.setupSheetGestureIfNeeded();
  };
    
  // MARK: - Setup
  // -------------
  
  public func setupIfNeeded(){
    guard !self._didSetup,
          let presentationController = self.presentationController
    else {
      return;
    };
    
    if presentationController.delegate != nil {
      self.presentationControllerDelegateProxy = self;
    };
    
    presentationController.delegate = self;
    self._didSetup = true;
  };
  
  public func setupSheetGestureIfNeeded(){
    guard self.sheetGesture == nil,
          let closestSheetPanGesture = self.closestSheetPanGesture
    else {
      return;
    };
    
    closestSheetPanGesture.addTarget(
      self,
      action: #selector(Self._handleSheetGesture(_:))
    );
    
    self.sheetGesture = closestSheetPanGesture;
  };
  
  // MARK: - Methods
  // ---------------
  
  public override func addEventDelegate(_ delegate: AnyObject){
    super.addEventDelegate(delegate);
    guard let delegate = delegate as? SheetViewControllerEventsNotifiable else {
      return;
    };
    
    self.sheetLifecycleEventDelegates.add(delegate);
  };
  
  @objc
  private func _handleSheetGesture(_ panGesture: UIPanGestureRecognizer){
    guard let presentationController = self.presentationController,
          let presentedView = presentationController.presentedView
    else {
      return;
    };
  
    let gesturePoint = panGesture.translation(in: presentedView);
    
    self.sheetLifecycleEventDelegates.invoke {
      $0.notifyOnSytemSheetPanGestureInvoked(
        sender: self,
        panGesture: panGesture,
        gesturePoint: gesturePoint
      );
    };
  };
};

extension ModalSheetViewControllerLifecycleNotifier: UIAdaptivePresentationControllerDelegate {

  public func adaptivePresentationStyle(
    for controller: UIPresentationController
  ) -> UIModalPresentationStyle {
  
    if let delegate = self.presentationControllerDelegateProxy,
       let presentationStyle = delegate.adaptivePresentationStyle?(for: controller)
    {
      return presentationStyle;
    };
    
    return .pageSheet;
  };

  public func adaptivePresentationStyle(
    for controller: UIPresentationController,
    traitCollection: UITraitCollection
  ) -> UIModalPresentationStyle {
  
    if let delegate = self.presentationControllerDelegateProxy,
       let presentationStyle = delegate.adaptivePresentationStyle?(for: controller, traitCollection: traitCollection)
    {
      return presentationStyle;
    };
    
    return .none;
  };

  @available(iOS 15.0, *)
  public func presentationController(
    _ presentationController: UIPresentationController,
    prepare adaptivePresentationController: UIPresentationController
  ) {
    self.presentationControllerDelegateProxy?.presentationController?(
      presentationController,
      prepare: adaptivePresentationController
    );
  };
  
  public func presentationController(
    _ controller: UIPresentationController,
    viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle
  ) -> UIViewController? {
    
    return self.presentationControllerDelegateProxy?.presentationController?(
      controller,
      viewControllerForAdaptivePresentationStyle: style
    );
  };

  public func presentationController(
    _ presentationController: UIPresentationController,
    willPresentWithAdaptiveStyle style: UIModalPresentationStyle,
    transitionCoordinator: UIViewControllerTransitionCoordinator?
  ) {
    
    self.presentationControllerDelegateProxy?.presentationController?(
      presentationController,
      willPresentWithAdaptiveStyle: style,
      transitionCoordinator: transitionCoordinator
    );
  };

  public func presentationControllerShouldDismiss(
    _ presentationController: UIPresentationController
  ) -> Bool {
  
    let shouldDismiss: Bool? =
      self.presentationControllerDelegateProxy?.presentationControllerShouldDismiss?(presentationController);
    
    return shouldDismiss ?? self.shouldAllowDismissal;
  };

  public func presentationControllerWillDismiss(
    _ presentationController: UIPresentationController
  ) {
    self.presentationControllerDelegateProxy?
      .presentationControllerWillDismiss?(presentationController);

    self.sheetLifecycleEventDelegates.invoke {
      $0.notifyOnSheetWillDismissViaGesture(
        sender: self,
        presentationController: presentationController
      );
    };
  };

  public func presentationControllerDidDismiss(
    _ presentationController: UIPresentationController
  ) {
    
    self.presentationControllerDelegateProxy?
      .presentationControllerDidDismiss?(presentationController);

    self.sheetLifecycleEventDelegates.invoke {
      $0.notifyOnSheetDidDismissViaGesture(
        sender: self,
        presentationController: presentationController
      );
    };
  };

  public func presentationControllerDidAttemptToDismiss(
    _ presentationController: UIPresentationController
  ) {
  
    self.presentationControllerDelegateProxy?
      .presentationControllerDidAttemptToDismiss?(presentationController);

    self.sheetLifecycleEventDelegates.invoke {
      $0.notifyOnSheetDidAttemptToDismissViaGesture(
        sender: self,
        presentationController: presentationController
      );
    };
  };
};
