//
//  RNICleanupMode.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 9/20/22.
//

import Foundation


/// If a class conforms to `RNICleanable`, this enum determines how the cleanup routine is triggered.
internal enum RNICleanupMode: String {
  
  case automatic;
  
  /// Trigger cleanup via view controller lifecycle
  case viewController;
  
  /// Trigger cleanup via react lifecycle `componentWillUnmount` event sent from js
  /// I.e. via `RNIJSComponentWillUnmountNotifiable`
  case reactComponentWillUnmount;
  
  case disabled;
  
};
