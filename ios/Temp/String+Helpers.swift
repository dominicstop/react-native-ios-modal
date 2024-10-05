//
//  String+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/6/24.
//

import Foundation


public extension String {

  var capitalizedFirstLetter: Self {
    var copy = self;
    copy.capitalizeFirstLetter();
    return copy;
  };
    
  mutating func capitalizeFirstLetter() {
    guard let firstLetter = self.first else {
      return;
    };
    
    self.replaceSubrange(
      ...self.startIndex,
      with: firstLetter.uppercased()
    );
  };
};
