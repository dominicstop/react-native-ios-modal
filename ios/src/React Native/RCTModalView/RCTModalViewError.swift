//
//  RCTModalViewError.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/26/20.
//

import Foundation

public enum RCTModalViewError: String, CaseIterable {
  case modalAlreadyPresented;
  case modalAlreadyDismissed;
  case modalDismissFailedNotInFocus;
  
  var errorMessage: String {
    RCTModalViewError.getErrorMessage(for: self);
  };
  
  static func withLabel(_ label: String) -> RCTModalViewError? {
    return self.allCases.first{ $0.rawValue == label };
  };
  
  static func getErrorMessage(for errorCase: RCTModalViewError) -> String {
    switch errorCase {
      case .modalAlreadyDismissed:
        return "Cannot dismiss modal because it's currently not presenetd";
      
      case .modalAlreadyPresented:
        return "Cannot present modal because it's already presented";
      
      case .modalDismissFailedNotInFocus:
        return "Cannot dismiss modal because it's not in focus. Enable allowModalForceDismiss to dismiss.";
    };
  };
};
