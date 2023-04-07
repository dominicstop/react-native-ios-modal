//
//  RNIIdentifiable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/31/23.
//

import Foundation


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

public protocol RNIIdentifiable:
  AnyObject, RNIObjectMetadata where T == RNIObjectIdentifier {
  
  static var synthesizedIdPrefix: String { set get };
  
  var synthesizedID: Int { get };
  
  var synthesizedUUID: UUID { get };
  
};

extension RNIIdentifiable {
  public static var synthesizedIdPrefix: String {
    String(describing: Self.self) + "-";
  };
   
  public var synthesizedIdentifier: RNIObjectIdentifier {
    if let identifier = self.metadata {
      return identifier;
    };
    
    let identifier = RNIObjectIdentifier(type: Self.self);
    self.metadata = identifier;
    
    return identifier;
  };
  
  public var synthesizedID: Int {
    self.synthesizedIdentifier.id;
  };
  
  public var synthesizedStringID: String {
    Self.synthesizedIdPrefix + "\(self.synthesizedID)";
  };
  
  public var synthesizedUUID: UUID {
    self.synthesizedIdentifier.uuid;
  };
};
