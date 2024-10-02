//
//  ModalViewControllerLifecycleNotifier.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/30/24.
//

import UIKit
import DGSwiftUtilities


open class ModalViewControllerLifecycleNotifier: ViewControllerLifecycleNotifier {
  
  public var isExplicitlySomeKindOfModal = false;
  public var isExplicitlyBeingDismissed = false;
  
  private(set) public var modalLifecycleEventDelegates:
    MulticastDelegate<ModalViewControllerEventsNotifiable> = .init();
    
  private(set) public var modalFocusEventDelegates:
    MulticastDelegate<ModalFocusEventNotifiable> = .init();
    
  // MARK: - View Controller Lifecycle
  // ---------------------------------
  
  public override func viewDidLoad() {
    super.viewDidLoad();
    ModalEventsManagerRegistry.shared.swizzleIfNeeded();
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    defer {
      super.viewWillAppear(animated);
    };
    
    guard self.isAppearingForTheFirstTime else {
      return;
    };
    
    self.isExplicitlySomeKindOfModal =
         self.isBeingPresented
      || self.presentingViewController?.presentedViewController === self;
      
    guard self.isExplicitlySomeKindOfModal else {
      return;
    };
    
    self.modalLifecycleEventDelegates.invoke {
      $0.notifyOnModalWillPresent(
        sender: self,
        isAnimated: animated
      );
    };
  };
  
  public override func viewDidAppear(_ animated: Bool) {
    defer {
      super.viewDidAppear(animated);
    };
    
    guard self.isAppearingForTheFirstTime,
          self.isExplicitlySomeKindOfModal
    else {
      return;
    };
    
    self.modalLifecycleEventDelegates.invoke {
      $0.notifyOnModalDidPresent(
        sender: self,
        isAnimated: animated
      );
    };
  };
  
  public override func viewWillDisappear(_ animated: Bool) {
    defer {
      super.viewWillDisappear(animated);
    };
    
    guard self.isBeingDismissed,
          self.isExplicitlySomeKindOfModal
    else {
      return;
    };
    
    guard animated,
          let transitionCoordinator = self.transitionCoordinator
    else {
      self.isExplicitlyBeingDismissed = true;
      
      self.modalLifecycleEventDelegates.invoke {
        $0.notifyOnModalWillDismiss(
          sender: self,
          isAnimated: false
        );
      };
      return;
    };
    
    transitionCoordinator.notifyWhenInteractionChanges { context in
      guard !context.isCancelled else {
        self.isExplicitlyBeingDismissed = false;
        return;
      };
      
      self.isExplicitlyBeingDismissed = true;
      self.modalLifecycleEventDelegates.invoke {
        $0.notifyOnModalWillDismiss(
          sender: self,
          isAnimated: context.isAnimated
        );
      };
    };
  };
  
  public override func viewDidDisappear(_ animated: Bool) {
    defer {
      super.viewDidDisappear(animated);
    };
    
    guard self.isBeingDismissed,
          self.isExplicitlySomeKindOfModal,
          self.isExplicitlyBeingDismissed
    else {
      return;
    };
    
    self.modalLifecycleEventDelegates.invoke {
      $0.notifyOnModalDidDismiss(
        sender: self,
        isAnimated: animated
      );
    };
  };
  
  // MARK: - Methods
  // ---------------
  
  open override func present(
    _ viewControllerToPresent: UIViewController,
    animated flag: Bool,
    completion: (() -> Void)? = nil
  ) {
    if let modalVC = viewControllerToPresent as? ModalViewControllerLifecycleNotifier {
      modalVC.isExplicitlySomeKindOfModal = true;
    };
    
    super.present(
      viewControllerToPresent,
      animated: flag,
      completion: completion
    );
  };
  
  open override func dismiss(
    animated flag: Bool,
    completion: (() -> Void)? = nil
  ) {
    self.isExplicitlyBeingDismissed = true;
    super.dismiss(animated: flag, completion: completion);
  };
};

extension ModalViewControllerLifecycleNotifier: ModalFocusEventNotifiable {
  
  public func notifyForModalFocusStateChange(
    forViewController viewController: UIViewController,
    prevState: ModalFocusState?,
    currentState: ModalFocusState,
    nextState: ModalFocusState
  ) {
    self.modalFocusEventDelegates.invoke {
      $0.notifyForModalFocusStateChange(
        forViewController: viewController,
        prevState: prevState,
        currentState: currentState,
        nextState: nextState
      );
    };
  };
};
