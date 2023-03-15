//
//  RNIWeakRef.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/11/23.
//

import Foundation


public class RNIWeakRef<T> {
  public weak var rawRef: AnyObject?;
  
  public var synthesizedRef: T? {
    self.rawRef as? T;
  };
  
  public init(with ref: AnyObject) {
    self.rawRef = ref;
  };
};
