//
//  CGPoint+RNIDictionaryRepresentable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 5/3/23.
//

import Foundation

extension CGPoint: RNIDictionaryRepresentable {
  public var asDictionary: [String: Any] {
    var dict: [String: Any] = [:];
    dict["x"] = self.x;
    dict["y"] = self.y;
    
    return dict;
  };
};
