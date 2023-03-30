//
//  RNIModalData.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/26/23.
//

import Foundation

public struct RNIModalData: RNIDictionarySynthesizable {
  let modalNativeID: String;
  
  let modalIndex: Int;
  let currentModalIndex: Int;
  
  let isModalPresented: Bool;
  let isModalInFocus: Bool;

  let synthesizedIsModalInFocus: Bool;
  let synthesizedIsModalPresented: Bool;
  let synthesizedModalIndex: Int;
  
  let synthesizedWindowID: String?;
};
