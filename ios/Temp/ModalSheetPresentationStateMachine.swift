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
  
  public var eventDelegates:
    MulticastDelegate<ModalSheetPresentationStateEventsNotifiable> = .init();
    
  // MARK: - Methods
  // ---------------
  
  public func setStateExplicit(nextState: ModalSheetState){
    let prevState = self.prevState;
    let currentState = self.currentState;
    
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ModalSheetPresentationStateMachine.\(#function) - PRE",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - prevState:", prevState?.rawValue ?? "N/A",
        "\n - currentState:", currentState,
        "\n - arg, nextState:", nextState,
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
    #if DEBUG
    if Self._debugShouldLog {
      print(
        "ModalSheetPresentationStateMachine.\(#function)",
        "\n - instance:", Unmanaged.passUnretained(self).toOpaque(),
        "\n - arg, nextState:", nextState,
        "\n"
      );
    };
    #endif
    
    switch (self.prevState, self.currentState, nextState) {
      
      default:
        break;
    };
    
    self.setStateExplicit(nextState: nextState);
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
  public static var _debugShouldLog = true;
  #endif
};

extension ModalSheetPresentationStateMachine: ViewControllerLifecycleNotifiable {
  
  public func notifyOnViewDidLoad(sender: UIViewController) {
    // no-op
  };

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
    
    self.setState(nextState: .dismissing);
  };
  
  public func notifyOnViewDidDisappear(
    sender: UIViewController,
    isAnimated: Bool
  ) {
  
    self.setState(nextState: .dismissed);
  };
};
