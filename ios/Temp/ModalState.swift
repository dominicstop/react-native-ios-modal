//
//  ModalState.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import Foundation


public enum ModalState: String {

  case presenting;
  case presented;
  case dismissing;
  case dismissed;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var isPresenting: Bool {
    self == .presenting;
  };
  
  public var isPresented: Bool {
    self == .presented;
  };
  
  public var isDismissing: Bool {
    self == .dismissing;
  };
  
  public var isDismissed: Bool {
    self == .dismissed;
  };
  
  public var isIdle: Bool {
    switch self {
      case .presenting, .dismissing:
        return false;
        
      default:
        return true;
    };
  };
  
  public var modalSheetState: ModalSheetState {
    switch self {
      case .presenting:
        return .presenting;
        
      case .presented:
        return .presented;
        
      case .dismissing:
        return .dismissing;
        
      case .dismissed:
        return .dismissed;
    };
  };
};
