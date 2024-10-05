//
//  UIView+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/6/24.
//

import Foundation
import DGSwiftUtilities


public extension UIView {
  
  func recursivelyFindConstraint(
    withIdentifier identifier: String
  ) -> NSLayoutConstraint? {
    
    var indexOfConstraintInView: Int?;
    
    let match = self.recursivelyFindSubview {
      let match = $0.constraints.enumerated().first {
        $0.element.identifier == identifier;
      };
      
      guard let match = match else {
        return false;
      };
      
      indexOfConstraintInView = match.offset;
      return true;
    };
    
    guard let match = match,
          let indexOfConstraintInView = indexOfConstraintInView
    else {
      return nil;
    };
    
    return match.constraints[indexOfConstraintInView];
  };
};
