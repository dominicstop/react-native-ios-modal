//
//  RNIModalEvents.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/26/23.
//

import Foundation

public struct RNIModalBaseEventData: RNIDictionarySynthesizable {
  let reactTag: Int;
  
  let modalID: String?;
  let modalNativeID: String;
  
  let modalIndex: Int;
  let currentModalIndex: Int;
  
  let isModalPresented: Bool;
  let isModalInFocus: Bool;

  let synthesizedIsModalInFocus: Bool;
  let synthesizedIsModalPresented: Bool;
  let synthesizedModalIndex: Int;
};

