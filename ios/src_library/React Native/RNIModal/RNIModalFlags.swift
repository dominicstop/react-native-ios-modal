//
//  RNIModalFlags.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/27/23.
//

import UIKit

public var RNIModalFlagsShared = RNIModalFlags.sharedInstance;

public class RNIModalFlags {
  static let sharedInstance = RNIModalFlags();
  
  var isModalViewPresentationNotificationEnabled = true;
  
  var shouldSwizzleViewControllers = true;
  var shouldSwizzledViewControllerNotifyAll = false;
  var shouldWrapAllViewControllers = false;
  
};
