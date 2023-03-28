//
//  RNICleanable.swift
//  react-native-ios-popover
//
//  Created by Dominic Go on 3/13/22.
//

import Foundation

///
/// When a class implements this protocol, it means that the class has "clean-up" related code.
/// This is usually for  `UIView` subclasses, and a
public protocol RNICleanable: AnyObject {
  
  func cleanup();
  
};
