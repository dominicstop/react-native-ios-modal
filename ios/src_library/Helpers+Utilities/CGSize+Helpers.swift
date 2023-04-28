//
//  CGSize+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/29/23.
//

import Foundation

public extension CGSize {
  var isZero: Bool {
    self == .zero || (self.width == 0 && self.height == 0);
  };
};
