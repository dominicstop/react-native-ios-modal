//
//  RNIDictionarySynthesizable+Default.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/27/23.
//

import Foundation

extension RNIDictionarySynthesizable {

  // MARK: - Static Properties
  // -------------------------
  
  public static var synthesizedDictionaryIgnore: [String] {
    [];
  };
  
  public static var synthesizedDictionaryInlinedProperties: [PartialKeyPath<Self>] {
    [];
  };
  
  // MARK: - Static Functions
  // ------------------------
  
  fileprivate static func recursivelyParseValue(
    _ value: Any,
    isJSDict: Bool
  ) -> Any {
  
    if let synthesizableDict = value as? (any RNIDictionarySynthesizable) {
      return synthesizableDict.synthesizedDictionary(isJSDict: isJSDict);
      
    } else if isJSDict, let rawValue = value as? any RawRepresentable {
      return rawValue.rawValue;
      
    } else if isJSDict, let array = value as? Array<Any> {
      return array.map {
        return Self.recursivelyParseValue($0, isJSDict: isJSDict);
      };
    };
    
    return value;
  };
  
  // MARK: - Public Functions
  // ------------------------
  
  public func synthesizedDictionary(
    isJSDict: Bool
  ) -> Dictionary<String, Any> {
    
    let mirror = Mirror(reflecting: self);
    let properties = mirror.children;
    
    #if DEBUG
    /// Runtime Check - Verify if `synthesizedDictionaryIgnore` is valid
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
      
      let parsedValue = Self.recursivelyParseValue(value, isJSDict: isJSDict);
      return (propertyKey, parsedValue);
    };
    
    var baseDict = Dictionary(
      uniqueKeysWithValues: propertyValueMap.compactMap { $0 }
    );
    
    Self.synthesizedDictionaryInlinedProperties.forEach {
      guard let value = self[keyPath: $0] as? (any RNIDictionarySynthesizable)
      else { return };
      
      let inlinedDict = value.synthesizedDictionary(isJSDict: isJSDict);
      baseDict = baseDict.merging(inlinedDict){ old, _ in old };
    };
    
    return baseDict;
  };
  
  public var synthesizedJSDictionary: Dictionary<String, Any> {
    self.synthesizedDictionary(isJSDict: true);
  };
};
