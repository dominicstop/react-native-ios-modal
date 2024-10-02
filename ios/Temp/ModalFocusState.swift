//
//  ModalFocusState.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/2/24.
//

import Foundation


public enum ModalFocusState: String {
  case blurred;
  case blurring;
  case focused;
  case focusing;
  
  public var isFocused: Bool {
    self == .focusing || self == .focused;
  };
  
  public var isBlurred: Bool {
    self == .blurring || self == .blurred;
  };
};
