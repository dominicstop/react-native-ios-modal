//
//  NSObject+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import Foundation


public extension NSObject {
  var classNameTruncated: String {
    let fullClassName = self.className;
    let classNameComponents = fullClassName.components(separatedBy: ".");
    
    guard let className = classNameComponents.last else {
      return fullClassName;
    };
    
    return className;
  }
};
