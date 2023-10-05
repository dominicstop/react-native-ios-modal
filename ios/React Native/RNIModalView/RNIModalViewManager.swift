//
//  RNIModalViewManager.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import React


@objc (RNIModalViewManager)
class RNIModalViewManager: RCTViewManager {
  static var sharedInstance: RNIModalViewManager!;
  
  override static func requiresMainQueueSetup() -> Bool {
    return true;
  };
 
  override func view() -> UIView! {
    let view = RNIModalView(bridge: self.bridge);
    return view;
  };
  
  override init() {
    super.init();
    RNIModalViewManager.sharedInstance = self;
    
    if !UIViewController.isSwizzled {
      UIViewController.swizzleMethods();
    };
  };
  
  @objc override func constantsToExport() -> [AnyHashable : Any]! {
    return [
      "availableBlurEffectStyles": UIBlurEffect.Style
        .availableStyles.map { $0.description },
      
      "availablePresentationStyles": UIModalPresentationStyle
        .availableStyles.map { $0.description },
    ];
  };
};
