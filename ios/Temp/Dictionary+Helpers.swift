//
//  Dictionary+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/29/24.
//

import Foundation


public extension Dictionary {
  
  mutating func merge(
    withOther otherDict: Self,
    shouldOverwriteValues: Bool = true
  ){
    self.merge(otherDict) {
      shouldOverwriteValues ? $1 : $0;
    };
  };
  
  mutating func unwrapAndMerge(
    withOther otherDict: Dictionary<Key, Value?>,
    shouldOverwriteValues: Bool = true
  ) {
  
    let filtered = otherDict.compactMapValues { $0 };
    
    self.merge(filtered) {
      shouldOverwriteValues ? $1 : $0;
    };
  };
  
  func merging(
    withOther otherDict: Self,
    shouldOverwriteValues: Bool = true
  ) -> Self {
    self.merging(otherDict) {
      shouldOverwriteValues ? $1 : $0;
    };
  };
  
  func unwrapBeforeMerging(
    withOther otherDict: Dictionary<Key, Value?>,
    shouldOverwriteValues: Bool = true
  ) -> Self {
    let filtered = otherDict.compactMapValues { $0 };
    
    return self.merging(filtered) {
      shouldOverwriteValues ? $1 : $0;
    };
  };
};
