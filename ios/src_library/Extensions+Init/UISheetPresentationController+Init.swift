//
//  UISheetPresentationController+Init.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/21/23.
//

import Foundation


@available(iOS 15.0, *)
extension UISheetPresentationController.Detent {
  
  static func fromString(
    _ string: String
  ) -> UISheetPresentationController.Detent? {
    
    switch string {
      case "medium": return .medium();
      case "large" : return .large();
        
      default: return nil;
    };
  };
};

@available(iOS 15.0, *)
extension UISheetPresentationController.Detent.Identifier {
  init?(fromSystemIdentifierString string: String) {
    switch string {
      case "medium": self = .medium;
      case "large" : self = .large;
        
      default: return nil;
    };
  };
  
  init(fromString string: String) {
    if let systemIdentifier = Self.init(fromSystemIdentifierString: string) {
      self = systemIdentifier;
      
    } else {
      self.init(string);
    };
  };
};
