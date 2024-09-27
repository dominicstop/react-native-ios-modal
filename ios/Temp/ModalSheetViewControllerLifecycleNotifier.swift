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
  
    #if DEBUG
    if Self._debugShouldLogGesture {
      print(
        "ModalSheetViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - panGesture:", panGesture.debugDescription,
        "\n - panGesture.state:", panGesture.state,
        "\n - panGesture, gesturePoint:", gesturePoint,
        "\n - isBeingDismissed:", self.isBeingDismissed,
        "\n - isBeingPresented:", self.isBeingPresented,
        "\n"
      );
    };
    #endif
    
    self.sheetLifecycleEventDelegates.invoke {
      $0.notifyOnSytemSheetPanGestureInvoked(
        sender: self,
        panGesture: panGesture,
        gesturePoint: gesturePoint
      );
    };
  };
  
  // MARK: - Debug-Related
  // ---------------------
  
  #if DEBUG
  public static var _debugShouldLogSheetEvents = false;
  public static var _debugShouldLogGesture = false;
  #endif
};

extension ModalSheetViewControllerLifecycleNotifier: UIAdaptivePresentationControllerDelegate {

  public func adaptivePresentationStyle(
    for controller: UIPresentationController
  ) -> UIModalPresentationStyle {
    
    let nextPresentationStyle: UIModalPresentationStyle = {
      guard let delegate = self.presentationControllerDelegateProxy,
            let presentationStyle = delegate.adaptivePresentationStyle?(for: controller)
      else {
        return .pageSheet;
      };

      return presentationStyle;
    }();
    
    #if DEBUG
    if Self._debugShouldLogSheetEvents {
      print(
        "ModalSheetViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - presentationControllerDelegateProxy:", self.presentationControllerDelegateProxy?.debugDescription ?? "N/A",
        "\n - arg, controller:", controller.debugDescription,
        "\n - arg, nextPresentationStyle:", nextPresentationStyle,
        "\n"
      );
    };
    #endif
    
    return nextPresentationStyle;
  };

  public func adaptivePresentationStyle(
    for controller: UIPresentationController,
    traitCollection: UITraitCollection
  ) -> UIModalPresentationStyle {
  
    let nextPresentationStyle: UIModalPresentationStyle = {
      guard let delegate = self.presentationControllerDelegateProxy,
            let presentationStyle =
              delegate.adaptivePresentationStyle?(for: controller, traitCollection: traitCollection)
      else {
        return .none;
      };

      return presentationStyle;
    }();
    
    #if DEBUG
    if Self._debugShouldLogSheetEvents {
      print(
        "ModalSheetViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - presentationControllerDelegateProxy:", self.presentationControllerDelegateProxy?.debugDescription ?? "N/A",
        "\n - arg, controller:", controller.debugDescription,
        "\n - arg, traitCollection:", traitCollection.debugDescription,
        "\n - arg, nextPresentationStyle:", nextPresentationStyle,
        "\n"
      );
    };
    #endif
    
    return nextPresentationStyle;
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
    
    #if DEBUG
    if Self._debugShouldLogSheetEvents {
      print(
        "ModalSheetViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - presentationControllerDelegateProxy:", self.presentationControllerDelegateProxy?.debugDescription ?? "N/A",
        "\n - arg, presentationController:", presentationController.debugDescription,
        "\n"
      );
    };
    #endif
  };
  
  public func presentationController(
    _ controller: UIPresentationController,
    viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle
  ) -> UIViewController? {
  
    let nextController = self.presentationControllerDelegateProxy?.presentationController?(
      controller,
      viewControllerForAdaptivePresentationStyle: style
    );
  
    #if DEBUG
    if Self._debugShouldLogSheetEvents {
      print(
        "ModalSheetViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - presentationControllerDelegateProxy:", self.presentationControllerDelegateProxy?.debugDescription ?? "N/A",
        "\n - arg, controller:", controller.debugDescription,
        "\n - arg, viewControllerForAdaptivePresentationStyle:", style.caseString,
        "\n - arg, nextController:", nextController?.debugDescription ?? "N/A",
        "\n"
      );
    };
    #endif
    
    return nextController;
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
    
    #if DEBUG
    if Self._debugShouldLogSheetEvents {
      print(
        "ModalSheetViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - presentationControllerDelegateProxy:", self.presentationControllerDelegateProxy?.debugDescription ?? "N/A",
        "\n - arg, presentationController:", presentationController.debugDescription,
        "\n - arg, willPresentWithAdaptiveStyle:", style.caseString,
        "\n - arg, transitionCoordinator:", transitionCoordinator?.debugDescription ?? "N/A",
        "\n"
      );
    };
    #endif
  };

  public func presentationControllerShouldDismiss(
    _ presentationController: UIPresentationController
  ) -> Bool {
  
    let shouldDismiss: Bool =
         self.presentationControllerDelegateProxy?.presentationControllerShouldDismiss?(presentationController)
      ?? self.shouldAllowDismissal;
      
    #if DEBUG
    if Self._debugShouldLogSheetEvents {
      print(
        "ModalSheetViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - presentationControllerDelegateProxy:", self.presentationControllerDelegateProxy?.debugDescription ?? "N/A",
        "\n - arg, presentationController:", presentationController.debugDescription,
        "\n - shouldDismiss:", shouldDismiss,
        "\n"
      );
    };
    #endif
    
    return shouldDismiss;
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
    
    #if DEBUG
    if Self._debugShouldLogSheetEvents {
      print(
        "ModalSheetViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - presentationControllerDelegateProxy:", self.presentationControllerDelegateProxy?.debugDescription ?? "N/A",
        "\n - arg, presentationController:", presentationController.debugDescription,
        "\n - isBeingDismissed: ", self.isBeingDismissed,
        "\n - isBeingPresented: ", self.isBeingPresented,
        "\n"
      );
    };
    #endif
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
    
    #if DEBUG
    if Self._debugShouldLogSheetEvents {
      print(
        "ModalSheetViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - presentationControllerDelegateProxy:", self.presentationControllerDelegateProxy?.debugDescription ?? "N/A",
        "\n - arg, presentationController:", presentationController.debugDescription,
        "\n - isPresentedAsModal", self.isPresentedAsModal,
        "\n"
      );
    };
    #endif
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
    
    #if DEBUG
    if Self._debugShouldLogSheetEvents {
      print(
        "ModalSheetViewControllerLifecycleNotifier.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - className:", self.className,
        "\n - presentationControllerDelegateProxy:", self.presentationControllerDelegateProxy?.debugDescription ?? "N/A",
        "\n - arg, presentationController:", presentationController.debugDescription,
        "\n - isPresentedAsModal", self.isPresentedAsModal,
        "\n"
      );
    };
    #endif
  };
};
