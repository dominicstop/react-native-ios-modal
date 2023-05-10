//
//  RNIGenericErrorDefaultable+Default.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 5/10/23.
//

import Foundation

public extension RNIGenericErrorDefaultable {
  static var runtimeError: Self {
    Self.runtimeError
  };

  static var libraryError: Self {
    Self.libraryError
  };

  static var reactError: Self {
    Self.reactError
  };

  static var unknownError: Self {
    Self.unknownError
  };

  static var invalidArgument: Self {
    Self.invalidArgument
  };

  static var outOfBounds: Self {
    Self.outOfBounds
  };

  static var invalidReactTag: Self {
    Self.invalidReactTag
  };

  static var nilValue: Self {
    Self.nilValue
  };
};
