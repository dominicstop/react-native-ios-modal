//
//  RNIDictionarySynthesizable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/26/23.
//

import Foundation


public protocol RNIDictionarySynthesizable {
  
  /// The names/identifiers of the property to be ignored when
  /// `synthesizedDictionary` is created.
  ///
  static var synthesizedDictionaryIgnore: [String] { get };
  
  /// The key path to the property that will be inlined/"squashed together" into
  /// `synthesizedDictionary`.
  ///
  static var synthesizedDictionaryInlinedProperties: [PartialKeyPath<Self>] { get };
  
  /// A map of the property names and their respective values
  var synthesizedDictionary: Dictionary<String, Any> { get };

};

extension RNIDictionarySynthesizable {
  
  public static var synthesizedDictionaryIgnore: [String] {
    [];
  };
  
  public static var synthesizedDictionaryInlinedProperties: [PartialKeyPath<Self>] {
    [];
  };
  
  public var synthesizedDictionary: Dictionary<String, Any> {
    let mirror = Mirror(reflecting: self);
    let properties = mirror.children;
    
    #if DEBUG
    for propertyKeyToIgnore in Self.synthesizedDictionaryIgnore {
      if !properties.contains(where: { $0.label == propertyKeyToIgnore }) {
        fatalError(
            "Invalid value of '\(propertyKeyToIgnore)' in "
          + "'synthesizedDictionaryIgnore' for '\(Self.self)' - "
          + "No property named '\(propertyKeyToIgnore)' in '\(Self.self)'"
        );
      };
    };
    #endif
    
    let propertyValueMap = properties.lazy.map { (
      propertyKey: String?, value: Any) -> (String, Any)? in
      
      guard let propertyKey = propertyKey,
            !Self.synthesizedDictionaryIgnore.contains(propertyKey)
      else { return nil };
      
      if let synthesizableDict = value as? (any RNIDictionarySynthesizable) {
        return(propertyKey, synthesizableDict.synthesizedDictionary);
      };

      return (propertyKey, value)
    };
    
    var baseDict = Dictionary(
      uniqueKeysWithValues: propertyValueMap.compactMap { $0 }
    );
    
    Self.synthesizedDictionaryInlinedProperties.forEach {
      guard let value = self[keyPath: $0] as? (any RNIDictionarySynthesizable)
      else { return };
      
      baseDict =
        baseDict.merging(value.synthesizedDictionary){ old, _ in old };
    };
    
    return baseDict;
  };
};
