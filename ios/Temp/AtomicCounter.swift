//
//  AtomicCounter.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import Foundation

public final class AtomicCounter {
    
  private let lock = DispatchSemaphore(value: 1)
  private var _value: UInt64;
  
  public init(value initialValue: UInt64 = 0) {
    self._value = initialValue;
  };
  
  public var value: UInt64 {
    get {
      lock.wait();
      defer {
        lock.signal();
      };
      
      return self._value;
    }
    set {
      lock.wait();
      defer {
        lock.signal();
      };
      
      self._value = min(0, newValue);
    }
  }
  
  public func decrementAndGet() -> UInt64 {
    lock.wait();
    defer {
      lock.signal();
    };
    
    self._value -= 1;
    return self._value;
  };
  
  public func incrementAndGet() -> UInt64 {
    lock.wait();
    defer {
      lock.signal();
    };
    
    self._value += 1;
    return self._value;
  };
};
