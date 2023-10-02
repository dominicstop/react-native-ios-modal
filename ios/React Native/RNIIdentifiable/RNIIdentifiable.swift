//
//  RNIIdentifiable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/31/23.
//

import UIKit

public protocol RNIIdentifiable:
  AnyObject, RNIObjectMetadata where T == RNIObjectIdentifier {
  
  static var synthesizedIdPrefix: String { get };
  
  var synthesizedID: Int { get };
  
  var synthesizedUUID: UUID { get };
  
};

