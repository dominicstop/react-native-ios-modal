//
//  ModalSheetPresentationStateEventsNotifiable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import Foundation

public protocol ModalSheetPresentationStateEventsNotifiable: AnyObject {
  
  func onModalSheetStateWillChange(
    sender: ModalSheetPresentationStateMachine,
    prevState: ModalSheetState?,
    currentState: ModalSheetState,
    nextState: ModalSheetState
  );
  
  func onModalSheetStateDidChange(
    sender: ModalSheetPresentationStateMachine,
    prevState: ModalSheetState?,
    currentState: ModalSheetState
  );
};

// MARK: - ModalSheetPresentationStateEventsNotifiable+Default
// -----------------------------------------------------------

public extension ModalSheetPresentationStateEventsNotifiable {
  
  func onModalSheetStateWillChange(
    sender: ModalSheetPresentationStateMachine,
    prevState: ModalSheetState?,
    currentState: ModalSheetState,
    nextState: ModalSheetState
  ) {
    // no-op
  };
  
  func onModalSheetStateDidChange(
    sender: ModalSheetPresentationStateMachine,
    prevState: ModalSheetState?,
    currentState: ModalSheetState
  ) {
    // no-op
  };
};
