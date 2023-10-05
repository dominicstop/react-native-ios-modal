//
//  RNIUtilitiesModule.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 9/27/22.
//

import UIKit
import React


@objc(RNIUtilitiesModule)
internal class RNIUtilitiesModule: NSObject {
  
  @objc internal var bridge: RCTBridge! {
    willSet {
      RNIUtilities.sharedBridge = newValue;
    }
  };
  
  @objc internal static func requiresMainQueueSetup() -> Bool {
    // run init in bg thread
    return false;
  };
  
  @objc internal func initialize(_ params: NSDictionary){
    // no-op
  };
};
