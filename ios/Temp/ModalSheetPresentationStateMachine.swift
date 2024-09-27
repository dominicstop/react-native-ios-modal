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
    MulticastDelegate<ModalSheetStateEventNotifiable> = .init();
  
  public func setStateExplicit(nextState: ModalSheetState){
    let prevState = self.prevState;
    let currentState = self.currentState;
  
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
  };
  
  public func setState(nextState: ModalSheetState){
    switch (self.prevState, self.currentState, nextState) {
      
      default:
        break;
    };
    
    self.setStateExplicit(nextState: nextState);
  };
  
  public func reset(){
    self.prevState = nil;
    self.currentState = .dismissed;
    
    self.didPresent = false;
    self.didDismissAfterPresented = false;
  };
};

extension ModalSheetPresentationStateMachine: ViewControllerLifecycleNotifiable {
  
  public func notifyOnViewDidLoad(sender: UIViewController) {
    // no-op
  };

  public func notifyOnViewWillAppear(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    
    self.setState(nextState: .presenting);
  };
  
  public func notifyOnViewIsAppearing(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    
    self.setState(nextState: .presenting);
  };
  
  public func notifyOnViewDidAppear(
    sender: UIViewController,
    isAnimated: Bool
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
