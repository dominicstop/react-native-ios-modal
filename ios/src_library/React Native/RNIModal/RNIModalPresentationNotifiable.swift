//
//  RNIModalPresentationNotifiable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/10/23.
//

import Foundation

public protocol RNIModalPresentationNotifiable: AnyObject {
  
  func notifyOnModalWillShow(sender: any RNIModal);
  
  func notifyOnModalDidShow(sender: any RNIModal);
  
  func notifyOnModalWillHide(sender: any RNIModal);
  
  func notifyOnModalDidHide(sender: any RNIModal);
};
