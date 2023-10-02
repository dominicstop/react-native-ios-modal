//
//  RNIObjectMetadata.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/31/23.
//

import UIKit

public protocol RNIObjectMetadata: AnyObject {
  associatedtype T: AnyObject;
  
  var metadata: T? { get set };
};
