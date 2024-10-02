//
//  ModalFocusEventNotifiable.swift
//
//
//  Created by Dominic Go on 6/15/24.
//

import Foundation

public protocol ModalFocusEventNotifiable: AnyObject {

  func notifyForModalFocusStateChange(
    prevState: ModalFocusState?,
    currentState: ModalFocusState,
    nextState: ModalFocusState
  );
};

// MARK: - ModalFocusEventNotifiable+Default
// -----------------------------------------

public extension ModalFocusEventNotifiable {

  func notifyForModalFocusStateChange(
    prevState: ModalFocusState?,
    currentState: ModalFocusState,
    nextState: ModalFocusState
  ) {
    // no-op
  };
};
