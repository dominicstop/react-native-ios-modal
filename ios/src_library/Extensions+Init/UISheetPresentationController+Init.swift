//
//  UISheetPresentationController+Init.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/21/23.
//

import Foundation


@available(iOS 15.0, *)
extension UISheetPresentationController.Detent {
  static func fromString(_ string: String) -> UISheetPresentationController.Detent? {
    switch string {
      case "medium": return .medium();
      case "large" : return .large();
        
      default: return nil;
    };
  };
};
