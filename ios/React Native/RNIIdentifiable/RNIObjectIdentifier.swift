//
//  RNIObjectIdentifier.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/27/23.
//

import UIKit

fileprivate class Counter {
  static var typeToCounterMap: Dictionary<String, Int> = [:];
  
  static func getTypeString(ofType _type: Any) -> String {
    return String(describing: type(of: _type));
  };
  
  static func set(forType type: Any, counter: Int) {
    let typeString = Self.getTypeString(ofType: type);
    Self.typeToCounterMap[typeString] = counter;
  };
  
  static func set(forType typeString: String, counter: Int) {
    Self.typeToCounterMap[typeString] = counter;
  };
  
  static func get(forType type: Any) -> Int {
    let typeString = Self.getTypeString(ofType: type);
    
    guard let counter = Self.typeToCounterMap[typeString] else {
      Self.set(forType: typeString, counter: -1);
      return -1;
    };
    
    return counter;
  };
  
  static func getAndIncrement(forType type: Any) -> Int {
    let prevCount = Self.get(forType: type);
    let nextCount = prevCount + 1;
    
    Self.set(forType: type, counter: nextCount);
    return nextCount;
  };
};

public final class RNIObjectIdentifier {

  public let id: Int;
  public let uuid = UUID();
  
  public init(type: Any) {
    self.id = Counter.getAndIncrement(forType: type);
  };
};
