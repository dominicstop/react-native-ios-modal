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
    PartialKeyPath<RNIModalBaseEventData>
  ] {
    [\.modalData];
  };
  
  let reactTag: Int;
  let modalID: String?;
  
  let modalData: RNIModalData;
};
