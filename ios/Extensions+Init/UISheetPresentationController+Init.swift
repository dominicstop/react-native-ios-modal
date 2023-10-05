//
//  UISheetPresentationController+Init.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/21/23.
//

import UIKit


@available(iOS 15.0, *)
extension UISheetPresentationController.Detent {
  
  // <UISheetPresentationControllerDetent: 0x600000e8f510:
  //   _type=medium -> 2,
  //   _identifier=com.apple.UIKit.medium
  // >
  //
  // <UISheetPresentationControllerDetent: 0x600000e8ffc0:
  //   _type=large -> 1,
  //   _identifier=com.apple.UIKit.large
  // >
  
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
extension UISheetPresentationController.Detent.Identifier:
  CustomStringConvertible {
  
  public var description: String {
    switch self {
      case .medium: return "medium";
      case .large : return "large";
      
      default: return self.rawValue;
    };
  };
  
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
