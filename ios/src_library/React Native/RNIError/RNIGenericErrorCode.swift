//
//  RNIGenericErrorCode.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/21/22.
//

import Foundation


internal enum RNIGenericErrorCode:
  String, Codable, CaseIterable, RNIGenericErrorDefaultable {
  
  case runtimeError, libraryError, reactError, unknownError,
       invalidArgument, outOfBounds, invalidReactTag, nilValue;
};
