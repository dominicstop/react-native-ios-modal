//
//  RNIModalEvents.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/26/23.
//

import UIKit

public struct RNIModalBaseEventData: RNIDictionarySynthesizable {
  
  public static var synthesizedDictionaryIgnore: [String] {
    ["modalData"]
  };
  
  public static var synthesizedDictionaryInlinedProperties: [
    PartialKeyPath<Self>
  ] {
    [\.modalData];
  };
  
  public let reactTag: Int;
  public let modalID: String?;
  
  public let modalData: RNIModalData;
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
  
  public let modalData: RNIModalBaseEventData;
  public let senderInfo: RNIModalData;
  
  public let isInitial: Bool;
};

public struct RNIModalDidChangeSelectedDetentIdentifierEventData: RNIDictionarySynthesizable {
  public let sheetDetentStringPrevious: String?;
  public let sheetDetentStringCurrent: String?;
};

public struct RNIModalDetentDidComputeEventData: RNIDictionarySynthesizable {
  public let maximumDetentValue: CGFloat;
  public let computedDetentValue: CGFloat;
  public let key: String;
};

public struct RNIModalSwipeGestureEventData: RNIDictionarySynthesizable {
  public let position: CGPoint;
};

public struct RNIModalDidSnapEventData: RNIDictionarySynthesizable {
  public let selectedDetentIdentifier: String?;
  public let modalContentSize: CGSize;
};