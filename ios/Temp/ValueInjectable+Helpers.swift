//
//  ValueInjectable+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import Foundation
import DGSwiftUtilities


public extension ValueInjectable {
  
  /// Lazily provides a optional fallback value, and set if needed
  func getInjectedValue<T, U: RawRepresentable<String>>(
    forKey key: U,
    fallbackValueProvider: (() -> T?)? = nil
  ) -> T? {
  
    if let value = self.injectedValues[key.rawValue] as? T {
      return value;
    };
    
    let fallbackValue = fallbackValueProvider?()
    guard let fallbackValue = fallbackValue else {
      return nil;
    };
    
    self.injectedValues[key.rawValue] = fallbackValue;
    return fallbackValue;
  };
  
  /// Lazily provides a fallback value, and set if needed
  func getInjectedValue<T, U: RawRepresentable<String>>(
    forKey key: U,
    fallbackValueProvider: () -> T
  ) -> T {
  
    if let value = self.injectedValues[key.rawValue] as? T {
      return value;
    };
    
    let fallbackValue = fallbackValueProvider()
    self.injectedValues[key.rawValue] = fallbackValue;
    
    return fallbackValue;
  };
};
