//
//  ModalSheetPresentationStateMachine.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import UIKit
import DGSwiftUtilities


public class ModalSheetPresentationStateMachine {
  
  public var prevState: ModalSheetState?;
  public var currentState: ModalSheetState = .dismissed;
  
  public var didPresent = false;
  public var didDismissAfterPresented = false;
  
  public var isSheetPanGestureActive = false;
  
  public var eventDelegates:
    MulticastDelegate<ModalSheetPresentationStateEventsNotifiable> = .init();

  // MARK: - Computed Properties
  // ---------------------------
  
  public var isPresentingForTheFirstTime: Bool {
       self.currentState.isPresenting
    && !self.didPresent;
  };
  
  public var didPresentForTheFirstTime: Bool {
    self.currentState.isPresented
  };
    
  // MARK: - Methods
  // ---------------
  
  public func setStateExplicit(nextState: ModalSheetState){
    guard self.currentState != nextState else {
      return;
    };
    
    let prevState = self.prevState;
    let currentState = self.currentState;
    
    // print(
    //   "setStateExplicit",
    //   "\n - state: \(prevState?.rawValue ?? "N/A") -> \(currentState.rawValue) -> \(nextState.rawValue)",
    //   "\n"
    // );
    
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ModalSheetPresentationStateMachine.\(#function) - PRE",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - state: \(prevState?.rawValue ?? "N/A") -> \(currentState.rawValue) -> \(nextState.rawValue)",
        "\n - self.didPresent:", self.didPresent,
        "\n - self.didDismissAfterPresented:", self.didDismissAfterPresented,
        "\n"
      );
    };
    #endif
    
    self.eventDelegates.invoke {
      $0.onModalSheetStateWillChange(
        sender: self,
        prevState: prevState,
        currentState: currentState,
        nextState: nextState
      );
    };
  
    self.prevState = self.currentState;
    self.currentState = nextState;
    
    switch (prevState, currentState, nextState) {
      case (_, let currentState, let nextState)
        where !currentState.isPresented && nextState.isPresented:
        
        self.didPresent = true;
        
      case (_, let currentState, let nextState) where
        !currentState.isPresented && nextState.isPresented:
        
        self.didDismissAfterPresented = true;
      
      default:
        break;
    };
    
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ModalSheetPresentationStateMachine.\(#function) - POST",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - self.prevState:", self.prevState?.rawValue ?? "N/A",
        "\n - self.currentState:", self.currentState,
        "\n - self.didPresent:", self.didPresent,
        "\n - self.didDismissAfterPresented:", self.didDismissAfterPresented,
        "\n"
      );
    };
    #endif
    
    self.eventDelegates.invoke {
      $0.onModalSheetStateDidChange(
        sender: self,
        prevState: self.prevState,
        currentState: self.currentState
      );
    };
  };
  
  public func setState(nextState: ModalSheetState) {
    var nextStateOverride: ModalSheetState? = nil;
    
    switch (self.prevState, self.currentState, nextState) {
      case (_, .draggingViaGesture, .presenting):
        nextStateOverride = .dismissViaGestureCancelling;
        
      case (.draggingViaGesture, .dismissViaGestureCancelling, let nextState)
        where nextState.isPresented:
        
        nextStateOverride = .dismissViaGestureCancelled;
        
      case (.draggingViaGesture, .dismissingViaGesture, .dismissed):
        nextStateOverride = .dismissedViaGesture;
      
      default:
        break;
    };
    
    let nextStateUpdated = nextStateOverride ?? nextState;
    
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ModalSheetPresentationStateMachine.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - prevState:", self.prevState?.rawValue ?? "N/A",
        "\n - currentState:", self.currentState.rawValue,
        "\n - nextState, raw:", nextState,
        "\n - nextState, override:", nextStateOverride?.rawValue ?? "N/A",
        "\n"
      );
    };
    #endif
    
    /// Don't allow:
    /// * `dismissingViaGesture`        -> `dismissing`
    /// * `dismissViaGestureCancelling` -> `presenting`
    /// * `dismissedViaGesture`         -> `dismissed`
    /// * etc.
    ///
    /// Keep state as specific as possible, i.e. don't overwrite specific state
    /// w/ generic/simple state
    ///
    if nextStateUpdated.isGeneric(comparedTo: self.currentState) {
      return;
    };
    
    /// Don't allow:
    /// * `dismissingViaGesture` -> `dismissing` -> `dismissingViaGesture`
    ///
    if self.currentState.isDraggingViaGesture,
       nextStateUpdated == .dismissing,
       self.isSheetPanGestureActive
    {
      return;
    };
    
    /// Don't allow:
    /// * `dismissingViaGesture` -> `draggingViaGesture`
    ///
    /// * happe
    ///
    ///
    if self.currentState == .dismissingViaGesture,
       nextStateUpdated == .draggingViaGesture
    {
      return;
    };
    
    self.setStateExplicit(nextState: nextStateUpdated);
  };
  
  public func reset(){
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ModalSheetPresentationStateMachine.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n"
      );
    };
    #endif
    
    self.prevState = nil;
    self.currentState = .dismissed;
    
    self.didPresent = false;
    self.didDismissAfterPresented = false;
  };
  
  // MARK: - Debug-Related
  // ---------------------
  
  #if DEBUG
  public static var _debugShouldLog = false;
  #endif
};

extension ModalSheetPresentationStateMachine: ViewControllerLifecycleNotifiable {

  public func notifyOnViewWillAppear(
    sender: UIViewController,
    isAnimated: Bool,
    isFirstAppearance: Bool
  ) {
    self.setState(nextState: .presenting);
  };
  
  public func notifyOnViewIsAppearing(
    sender: UIViewController,
    isAnimated: Bool,
    isFirstAppearance: Bool
  ) {
    self.setState(nextState: .presenting);
  };
  
  public func notifyOnViewDidAppear(
    sender: UIViewController,
    isAnimated: Bool,
    isFirstAppearance: Bool
  ) {
    self.setState(nextState: .presented);
  };
  
  public func notifyOnViewWillDisappear(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    guard !self.isSheetPanGestureActive else {
      return;
    };
    
    self.setState(nextState: .dismissing);
  };
  
  public func notifyOnViewDidDisappear(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    self.setState(nextState: .dismissed);
  };
};

// MARK: - ModalSheetPresentationStateMachine+SheetViewControllerEventsNotifiable
// ------------------------------------------------------------------------------

extension ModalSheetPresentationStateMachine: ModalSheetViewControllerEventsNotifiable {
  
  public func notifyOnSheetDidAttemptToDismissViaGesture(
    sender: UIViewController,
    presentationController: UIPresentationController
  ) {
    self.setState(nextState: .presentingViaGestureCancelled);
  };
  
  public func notifyOnSheetWillDismissViaGesture(
    sender: UIViewController,
    presentationController: UIPresentationController
  ) {
    self.isSheetPanGestureActive = true;
    
    guard let transitionCoordinator = sender.transitionCoordinator else {
      return;
    };
    
    transitionCoordinator.notifyWhenInteractionChanges {
      guard sender.isBeingDismissed,
            $0.isAnimated
      else {
        return;
      };
      
      self.setState(nextState: $0.isCancelled
        ? .dismissViaGestureCancelling
        : .dismissingViaGesture
      );
    };
  };
  
  public func notifyOnSheetDidDismissViaGesture(
    sender: UIViewController,
    presentationController: UIPresentationController
  ) {
    self.setState(nextState: .dismissedViaGesture);
  };
  
  public func notifyOnSheetBeingDraggedByPanGesture(
    sender: UIViewController,
    panGesture: UIPanGestureRecognizer
  ) {
    guard sender.isBeingDismissed else {
      return;
    };
    
    switch panGesture.state {
      case .began, .changed:
        self.isSheetPanGestureActive = true;
        self.setState(nextState: .draggingViaGesture);
      
      case .ended, .cancelled, .failed:
        self.isSheetPanGestureActive = false;
        
      default:
        break;
    };
  };
};
