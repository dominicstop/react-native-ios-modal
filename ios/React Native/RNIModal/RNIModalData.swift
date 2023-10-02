//
//  RNIModalData.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/26/23.
//

import UIKit

public struct RNIModalData: RNIDictionarySynthesizable {
  public let modalNativeID: String;
  
  public let modalIndex: Int;
  public let modalIndexPrev: Int;
  public let currentModalIndex: Int;
  
  public let modalFocusState: RNIModalFocusStateMachine;
  public let modalPresentationState: RNIModalPresentationStateMachine;

  public let computedIsModalInFocus: Bool;
  public let computedIsModalPresented: Bool;
  
  public let computedModalIndex: Int;
  public let computedViewControllerIndex: Int;
  public let computedCurrentModalIndex: Int;
  
  public let synthesizedWindowID: String?;
};
