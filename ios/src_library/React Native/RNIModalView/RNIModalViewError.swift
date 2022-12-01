//
//  RNIModalViewError.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/26/20.
//

import Foundation

public enum RNIModalViewError: String, CaseIterable {
  case modalAlreadyPresented;
  case modalAlreadyDismissed;
  case modalDismissFailedNotInFocus;
  
  var errorMessage: String {
    RNIModalViewError.getErrorMessage(for: self);
  };
  
  static func withLabel(_ label: String) -> RNIModalViewError? {
    return self.allCases.first{ $0.rawValue == label };
  };
  
  static func getErrorMessage(for errorCase: RNIModalViewError) -> String {
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
