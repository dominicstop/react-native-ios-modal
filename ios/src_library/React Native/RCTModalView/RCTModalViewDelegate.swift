//
//  RCTModalViewDelegate.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/17/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc protocol RCTModalViewPresentDelegate: AnyObject {
  
  func onPresentModalView(modalView: RCTModalView);
  
  func onDismissModalView(modalView: RCTModalView);
  
};

@objc protocol RCTModalViewFocusDelegate: AnyObject {
  
  /**
   - Parameters:
      - modalLevel: the `RCTModalView` sender's current modalLevel
      - modalUUID  : the `RCTModalView` sender's modalUUID
      - isInFocus  : Whether or not the modal is going in or out of focus
  */
  func onModalChangeFocus(modalLevel: Int, modalUUID: String, isInFocus: Bool);
  
};


