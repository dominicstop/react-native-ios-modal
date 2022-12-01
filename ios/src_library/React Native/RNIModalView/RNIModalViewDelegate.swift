//
//  RNIModalViewDelegate.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/17/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc protocol RNIModalViewPresentDelegate: AnyObject {
  
  func onPresentModalView(modalView: RNIModalView);
  
  func onDismissModalView(modalView: RNIModalView);
  
};

@objc protocol RNIModalViewFocusDelegate: AnyObject {
  
  /**
   - Parameters:
      - modalLevel: the `RNIModalView` sender's current modalLevel
      - modalUUID  : the `RNIModalView` sender's modalUUID
      - isInFocus  : Whether or not the modal is going in or out of focus
  */
  func onModalChangeFocus(modalLevel: Int, modalUUID: String, isInFocus: Bool);
  
};


