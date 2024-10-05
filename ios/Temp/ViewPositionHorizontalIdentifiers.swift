//
//  ViewPositionHorizontalIdentifiers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/6/24.
//

import Foundation
import DGSwiftUtilities

public enum ViewPositionHorizontalIdentifier: String {
  case leading;
  case trailing;
  case width;
  case centerX;
  case leadingMin;
  case trailingMin;
  
  public var identifier: String {
    let prefix = "generatedHorizontalPosition";
    let suffix = "Constraint";
    
    let center = self.rawValue.capitalizedFirstLetter;
    return prefix + center + suffix;
  };
};
