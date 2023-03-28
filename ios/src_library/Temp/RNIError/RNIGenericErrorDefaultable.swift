//
//  RNIGenericErrorDefaultable.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/28/22.
//

import Foundation


public protocol RNIGenericErrorDefaultable {
  static var runtimeError   : Self { get };
  static var libraryError   : Self { get };
  static var reactError     : Self { get };
  static var unknownError   : Self { get };
  static var invalidArgument: Self { get };
  static var outOfBounds    : Self { get };
  static var invalidReactTag: Self { get };
  static var nilValue       : Self { get };
};
