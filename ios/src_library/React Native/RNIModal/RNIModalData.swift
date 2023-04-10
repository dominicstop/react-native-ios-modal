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

  public let computedIsModalInFocus: Bool;
  public let computedIsModalPresented: Bool;
  
  public let computedModalIndex: Int;
  public let computedViewControllerIndex: Int;
  
  public let synthesizedWindowID: String?;
};
