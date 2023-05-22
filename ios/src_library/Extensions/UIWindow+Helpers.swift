//
//  UIWindow+WindowMetadata.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/30/23.
//

import UIKit

extension UIWindow: RNIObjectMetadata, RNIIdentifiable {
  public static var synthesizedIdPrefix = "window-id-";
};
