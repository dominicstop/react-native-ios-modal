//
//  RNIDictionarySynthesizable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/26/23.
//

import Foundation

/// Any type that conforms to this protocol will be able to create a dictionary
/// representing the keys and values inside that type
///
public protocol RNIDictionarySynthesizable {
  
  /// The names/identifiers of the property to be ignored when
  /// `synthesizedDictionary` is created.
  ///
  static var synthesizedDictionaryIgnore: [String] { get };
  
  /// The key path to the property that will be inlined/"squashed together"
  /// into `synthesizedDictionary`.
  ///
  static var synthesizedDictionaryInlinedProperties:
    [PartialKeyPath<Self>] { get };
  
  /// A map of the property names and their respective values
  func synthesizedDictionary(isJSDict: Bool) -> Dictionary<String, Any>;
};

