//
//  RNIDictionarySynthesizable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/26/23.
//

import Foundation

public protocol RNIDictionarySynthesizable {
  var synthesizedDictionary: Dictionary<String, Any> { get };
};

extension RNIDictionarySynthesizable {
  public var synthesizedDictionary: Dictionary<String, Any> {
    let mirror = Mirror(reflecting: self);
    let properties = mirror.children;
    
    let propertyValueMap = properties.lazy.map { (
      property: String?, value: Any) -> (String, Any)? in
      
      guard let property = property else { return nil }
      return (property, value)
    };
    
    return Dictionary(
      uniqueKeysWithValues: propertyValueMap.compactMap { $0 }
    );
  };
};
