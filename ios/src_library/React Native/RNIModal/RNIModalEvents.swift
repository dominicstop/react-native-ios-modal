//
//  RNIModalEvents.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/26/23.
//

import Foundation

public struct RNIModalBaseEventData: RNIDictionarySynthesizable {
  
  public static var synthesizedDictionaryIgnore: [String] {
    ["modalData"]
  };
  
  public static var synthesizedDictionaryInlinedProperties: [
    PartialKeyPath<Self>
  ] {
    [\.modalData];
  };
  
  let reactTag: Int;
  let modalID: String?;
  
  let modalData: RNIModalData;
};

public struct RNIOnModalFocusEventData: RNIDictionarySynthesizable {
  
  public static var synthesizedDictionaryIgnore: [String] {
    ["modalData"]
  };
  
  public static var synthesizedDictionaryInlinedProperties: [
    PartialKeyPath<Self>
  ] {
    [\.modalData];
  };
  
  let modalData: RNIModalBaseEventData;
  let senderInfo: RNIModalData;
  
  let isInitial: Bool;
};
