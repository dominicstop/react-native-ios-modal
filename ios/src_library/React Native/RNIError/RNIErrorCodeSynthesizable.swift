//
//  RNIErrorCodeSynthesizable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 5/12/23.
//

import Foundation

public protocol RNIErrorCodeSynthesizable {
  var errorCode: Int? { get };
}

extension RNIErrorCodeSynthesizable where Self: CaseIterable & Equatable {
  
  public var errorCode: Int? {
    let match = Self.allCases.enumerated().first { _, value in
      value == self
    }
    
    guard let offset = match?.offset else { return nil };
    return offset * -1;
  };
};
