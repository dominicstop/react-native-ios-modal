//
//  RNIModalData.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/26/23.
//

import Foundation

public struct RNIModalData: RNIDictionarySynthesizable {
  public let modalNativeID: String;
  
  public let modalIndex: Int;
  public let currentModalIndex: Int;
  
  public let isModalPresented: Bool;
  public let isModalInFocus: Bool;

  public let synthesizedIsModalInFocus: Bool;
  public let synthesizedIsModalPresented: Bool;
  
  public let synthesizedModalIndex: Int;
  public let synthesizedViewControllerIndex: Int;
  
  public let synthesizedWindowID: String?;
};
