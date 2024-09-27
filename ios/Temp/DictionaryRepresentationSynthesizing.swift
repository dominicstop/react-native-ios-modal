//
//  DictionaryRepresentationSynthesizing.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import Foundation
import DGSwiftUtilities


/// Any type that conforms to this protocol will be able to create a dictionary
/// (via reflection) representing the keys and values inside that type
///
public protocol DictionaryRepresentationSynthesizing {

  associatedtype KeyPathRoot = Self;
  
  typealias StringToPartialKeyPathMap =
    Dictionary<String, PartialKeyPath<KeyPathRoot>>;
  
  /// The extra properties to add to `synthesizedDictionary`
  ///
  static var synthesizedDictionaryExtraItemsKeyPathMap: StringToPartialKeyPathMap? { get };
  
  /// The names/identifiers of the property to be ignored when
  /// `synthesizedDictionary` is created.
  ///
  static var synthesizedDictionaryIgnore: [String] { get };
  
  /// The key path to the property that will be inlined/"squashed together"
  /// into `synthesizedDictionary`.
  ///
  static var synthesizedDictionaryInlinedProperties: [PartialKeyPath<KeyPathRoot>] { get };
  
  var synthesizedDictionary: [String: Any] { get };
};

// MARK: - DictionaryRepresentationSynthesizing+StaticDefault
// ---------------------------------------------------------

extension DictionaryRepresentationSynthesizing {

  // MARK: - Static Properties
  // -------------------------
  
  static var synthesizedDictionaryExtraItemsKeyPathMap: StringToPartialKeyPathMap? {
    return nil;
  };
  
  public static var synthesizedDictionaryIgnore: [String] {
    return [];
  };
  
  public static var synthesizedDictionaryInlinedProperties: [PartialKeyPath<Self>] {
    return [];
  };
};

extension DictionaryRepresentationSynthesizing where Self: StringKeyPathMapping {
  
  static var synthesizedDictionaryExtraItemsKeyPathMap: StringToPartialKeyPathMap? {
    return self.partialKeyPathMap;
  };
  
  public static var synthesizedDictionaryIgnore: [String] {
    return [];
  };
  
  public static var synthesizedDictionaryInlinedProperties: [PartialKeyPath<Self>] {
    return [];
  };
};

// MARK: - DictionaryRepresentationSynthesizing+Default
// ----------------------------------------------------

extension DictionaryRepresentationSynthesizing {
  
  // MARK: - Static Functions
  // ------------------------
  
  private static func recursivelyParseValue(
    _ value: Any,
    isJSDict: Bool
  ) -> Any? {
  
    if let synthesizableDict = value as? (any DictionaryRepresentationSynthesizing) {
      return synthesizableDict.synthesizedDictionary(isJSDict: isJSDict);
    };
    
    if isJSDict,
       let rawValue = value as? any EnumCaseStringRepresentable
    {
      return rawValue.caseString;
    };
      
    if isJSDict,
       let rawValue = value as? any RawRepresentable
    {
      return rawValue.rawValue;
    };
    
    if isJSDict,
       let array = value as? Array<Any>
    {
      return array.map {
        Self.recursivelyParseValue($0, isJSDict: isJSDict);
      };
    };
    
    if isJSDict,
       let dict = value as? Dictionary<String, Any>
    {
      return dict.mapValues {
        Self.recursivelyParseValue($0, isJSDict: isJSDict);
      };
    };
    
    if let dictRepresentable = value as? DictionaryRepresentable {
      let dict = dictRepresentable.asDictionary;
      
      guard isJSDict else {
        return dict;
      };
      
      return Self.recursivelyParseValue(dict, isJSDict: isJSDict);
    };
    
    if let encodable = value as? Encodable,
       let dict = encodable.asDictionary
    {
       return dict;
    };
    
    if isJSDict {
      switch value {
        case let stringValue as String:
          return stringValue;
          
        case let floatValue as any FloatingPoint:
          return floatValue;
          
        case let intValue as any FixedWidthInteger:
          return intValue;
          
        case let boolValue as Bool:
          return boolValue;
          
        case let objcNumber as NSNumber:
          return objcNumber;
          
        default:
          return nil;
      };
    };
    
    return value;
  };
  
  private func synthesizedDictionary(
    isJSDict: Bool
  ) -> Dictionary<String, Any> {
  
    return self.synthesizedDictionaryUsingDictIgnore(isJSDict: isJSDict);
  };
  
  private func mergeInlinedProperties(
    withDict baseDict: Dictionary<String, Any>,
    isJSDict: Bool
  ) -> Dictionary<String, Any> {
  
    var baseDict = baseDict;
  
    Self.synthesizedDictionaryInlinedProperties.forEach {
      guard let _self = self as? KeyPathRoot,
            let value = _self[keyPath: $0] as? (any DictionaryRepresentationSynthesizing)
      else {
        return;
      };
      
      let inlinedDict = value.synthesizedDictionary(isJSDict: isJSDict);
      baseDict = baseDict.merging(inlinedDict){ old, _ in old };
    };
    
    return baseDict;
  };
  
  private func synthesizedDictionaryUsingDictIgnore(
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
    
    let propertyValueMap = properties.lazy.map {
      (propertyKey: String?, value: Any) -> (String, Any)? in
      
      guard let propertyKey = propertyKey else {
        return nil;
      };
      
      let shouldSkipProperty =
        Self.synthesizedDictionaryIgnore.contains(propertyKey);
        
      guard !shouldSkipProperty else {
        return nil;
      };
      
      let parsedValue = Self.recursivelyParseValue(value, isJSDict: isJSDict);
      guard let parsedValue = parsedValue else {
        return nil;
      };
      
      return (propertyKey, parsedValue);
    };
    
    let extraPropertiesValueMap = Self.synthesizedDictionaryExtraItemsKeyPathMap?.compactMap {(
      propertyKey: String,
      keyPath: PartialKeyPath<KeyPathRoot>
    ) -> (String, Any)? in
      
      let shouldSkipProperty =
        Self.synthesizedDictionaryIgnore.contains(propertyKey);
        
      guard !shouldSkipProperty else {
        return nil;
      };
      
      guard let _self = self as? KeyPathRoot else {
        return nil;
      };
      
      let valueForKeyPath = _self[keyPath: keyPath];
    
      let parsedValue = Self.recursivelyParseValue(
        valueForKeyPath,
        isJSDict: isJSDict
      );
      
      guard let parsedValue = parsedValue else {
        return nil;
      };
      
      return (propertyKey, parsedValue);
    };
    
    var baseDict = Dictionary(
      uniqueKeysWithValues: propertyValueMap.compactMap { $0 }
    );
    
    if let extraPropertiesValueMap = extraPropertiesValueMap {
      baseDict.merge(extraPropertiesValueMap) { (_, new) in new };
    };
    
    return self.mergeInlinedProperties(
      withDict: baseDict,
      isJSDict: isJSDict
    );
  };
  
  // MARK: - Public Functions
  // ------------------------
  
  public var synthesizedDictionary: Dictionary<String, Any> {
    self.synthesizedDictionary(isJSDict: false);
  };
  
  /// `JSON` friendly representation, i.e. only primitive values
  ///
  public var synthesizedDictionaryJSON: Dictionary<String, Any> {
    self.synthesizedDictionary(isJSDict: true);
  };
};
