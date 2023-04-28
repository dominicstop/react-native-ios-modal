//
//  CGSize+Init.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/28/23.
//

import Foundation

public extension CGSize {
  init?(fromDict dict: NSDictionary){
    guard let width = dict["width"] as? NSNumber,
          let height = dict["height"] as? NSNumber
    else { return nil };
    
    self.init(
      width: width.doubleValue,
      height: height.doubleValue
    );
  };
};
