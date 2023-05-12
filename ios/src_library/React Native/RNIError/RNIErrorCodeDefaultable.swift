//
//  RNIGenericErrorDefaultable.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/28/22.
//

import Foundation

public protocol RNIErrorCodeDefaultable {

  static var runtimeError   : Self { get };
  static var libraryError   : Self { get };
  static var reactError     : Self { get };
  static var unknownError   : Self { get };
  static var invalidArgument: Self { get };
  static var outOfBounds    : Self { get };
  static var invalidReactTag: Self { get };
  static var nilValue       : Self { get };
};

// MARK: - Default
// ---------------

public extension RNIErrorCodeDefaultable {

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

// MARK: - Helpers
// ---------------

extension RNIErrorCodeDefaultable where Self: RawRepresentable<String> {

  public var description: String {
    self.rawValue;
  };
};


