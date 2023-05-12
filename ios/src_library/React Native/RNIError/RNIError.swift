//
//  RNIError.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 5/12/23.
//

import Foundation

public typealias RNIError =
  RNIBaseError & RNIDictionarySynthesizable;

public typealias RNIErrorCode =
    CustomStringConvertible
  & CaseIterable
  & Equatable
  & RNIErrorCodeDefaultable
  & RNIErrorCodeSynthesizable;
