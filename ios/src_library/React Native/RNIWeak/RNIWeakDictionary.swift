//
//  RNIWeakDictionary.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/15/23.
//

import Foundation


public class RNIWeakDictionary<K: Hashable, T> {
  
  public var rawDict: [K: RNIWeakRef<T>] = [:];
  
  public var purgedDict: [K: RNIWeakRef<T>] {
    get {
      self.rawDict.compactMapValues {
        $0.rawRef != nil ? $0 : nil;
      }
    }
  };
  
  public var dict: [K: RNIWeakRef<T>] {
    get {
      let purgedDict = self.purgedDict;
      self.rawDict = purgedDict;
      
      return purgedDict;
    }
  }
  
  public func set(for key: K, with value: T){
    self.rawDict[key] = RNIWeakRef(with: value as AnyObject);
  };
  
  public func get(for key: K) -> T? {
    guard let ref = self.rawDict[key]?.synthesizedRef else {
      self.rawDict.removeValue(forKey: key);
      return nil;
    };
    
    return ref;
  };
  
  public subscript(key: K) -> T? {
    get {
      self.get(for: key);
    }
    set {
      guard let ref = newValue else { return };
      self.set(for: key, with: ref);
    }
  }
};

