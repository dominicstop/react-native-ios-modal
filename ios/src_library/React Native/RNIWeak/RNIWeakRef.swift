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
  
  init(with ref: AnyObject) {
    self.rawRef = ref;
  };
};

public class RNIWeakDictionary<K: Hashable, T> {
  
  fileprivate var _dict: [K: RNIWeakRef<T>] = [:];
  
  var purgedDict: [K: RNIWeakRef<T>] {
    get {
      self._dict.compactMapValues {
        $0.rawRef != nil ? $0 : nil;
      }
    }
  };
  
  var dict: [K: RNIWeakRef<T>] {
    get {
      let purgedDict = self.purgedDict;
      self._dict = purgedDict;
      
      return purgedDict;
    }
  }
  
  func set(for key: K, with value: T){
    self._dict[key] = RNIWeakRef(with: value as AnyObject);
  };
  
  func get(for key: K) -> T? {
    guard let ref = self._dict[key]?.synthesizedRef else {
      self._dict.removeValue(forKey: key);
      return nil;
    };
    
    return ref;
  };
  
  subscript(key: K) -> T? {
    get {
      self.get(for: key);
    }
    set {
      guard let ref = newValue else { return };
      self.set(for: key, with: ref);
    }
  }
};
