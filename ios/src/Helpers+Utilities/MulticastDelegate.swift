//
//  MulticastDelegate.swift
//  RNSwiftReviewer
//
//  Created by Dominic Go on 8/15/20.
//

import Foundation


class MulticastDelegate<T: AnyObject> {
  private let delegates: NSHashTable<T> = NSHashTable.weakObjects();
  
  func add(_ delegate: T) {
    delegates.add(delegate);
  };
  
  func remove(_ delegate: T) {
    self.delegates.remove(delegate);
  };
  
  func invoke (_ invocation: @escaping (T) -> Void) {
    for delegate in delegates.allObjects {
      invocation(delegate)
    };
  };
};
