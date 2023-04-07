//
//  MulticastDelegate.swift
//  RNSwiftReviewer
//
//  Created by Dominic Go on 8/15/20.
//

import Foundation


public class MulticastDelegate<T: AnyObject> {
  private let delegates: NSHashTable<T> = NSHashTable.weakObjects();
  
  public func add(_ delegate: T) {
    delegates.add(delegate);
  };
  
  public func remove(_ delegate: T) {
    self.delegates.remove(delegate);
  };
  
  public func invoke (_ invocation: @escaping (T) -> Void) {
    for delegate in delegates.allObjects {
      invocation(delegate)
    };
  };
};
