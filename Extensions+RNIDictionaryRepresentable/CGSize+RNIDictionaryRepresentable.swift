//
//  CGSize+RNIDictionaryRepresentable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 5/3/23.
//

import Foundation

extension CGSize: RNIDictionaryRepresentable {
  public var asDictionary: [String: Any] {
    var dict: [String: Any] = [:];
    dict["width"] = self.width;
    dict["height"] = self.height;
    
    return dict;
  };
};
