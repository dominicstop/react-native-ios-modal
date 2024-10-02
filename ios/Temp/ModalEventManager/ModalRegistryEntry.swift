//
//  ModalRegistryEntry.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/2/24.
//

import UIKit


public class ModalRegistryEntry {
  
  public weak var viewController: UIViewController?;
  
  public var modalFocusIndex: Int;
  public var modalInstanceID: String;
  
  public var modalFocusState: ModalFocusState;
  public var modalFocusStatePrev: ModalFocusState?;
  
  public var isValidEntry: Bool {
    self.viewController != nil;
  };
  
  public init(
    viewController: UIViewController,
    modalFocusIndex: Int,
    modalState: ModalFocusState = .blurred
  ) {
    self.viewController = viewController;
    self.modalFocusIndex = modalFocusIndex;
    self.modalFocusState = modalState;
    
    self.modalInstanceID = viewController.synthesizedStringID;
  };
  
  public func setModalFocusState(_ modalStateNext: ModalFocusState){
    guard let viewController = self.viewController else {
      return;
    };
    
    let modalStatePrev = self.modalFocusStatePrev;
    let modalStateCurrent = self.modalFocusState;
    
    guard modalStateCurrent != modalStateNext else {
      return;
    };
    
    self.modalFocusState = modalStateNext;
    self.modalFocusStatePrev = modalStateCurrent;
    
    if let eventDelegate = self.viewController as? ModalFocusEventNotifiable {
      eventDelegate.notifyForModalFocusStateChange(
        forViewController: viewController,
        prevState: modalStatePrev,
        currentState: modalStateCurrent,
        nextState: modalStateNext
      );
    };
  };
};
