//
//  RNIInternalCleanupMode.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 10/29/22.
//

import UIKit


internal protocol RNIInternalCleanupMode {
  /// shadow variable for react prop
  var synthesizedInternalCleanupMode: RNICleanupMode { get };
  
  /// exported react prop
  var internalCleanupMode: String? { get };
  
  /// computed property - override behavior for `.automatic`
  var cleanupMode: RNICleanupMode { get };
};

// provide default implementation
internal extension RNIInternalCleanupMode {
  var shouldEnableAttachToParentVC: Bool {
    self.cleanupMode == .viewController
  };
  
  var shouldEnableCleanup: Bool {
    self.cleanupMode != .disabled
  };
  
  var cleanupMode: RNICleanupMode {
    get {
      switch self.synthesizedInternalCleanupMode {
        case .automatic: return .reactComponentWillUnmount;
        default: return self.synthesizedInternalCleanupMode;
      };
    }
  };
};
