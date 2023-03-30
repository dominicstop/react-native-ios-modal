//
//  RNIIdentifiable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/31/23.
//

import Foundation

fileprivate final class RNIObjectIdentifier {
  static var counterID = -1;
  
  let id: Int = {
    RNIObjectIdentifier.counterID += 1;
    return RNIObjectIdentifier.counterID;
  }();
  
  let uuid = UUID();
};

fileprivate final class RNIObjectIdentifierMap {
  static let map = NSMapTable<AnyObject, RNIObjectIdentifier>(
    keyOptions: .weakMemory,
    valueOptions: .strongMemory
  );
};


public protocol RNIIdentifiable: AnyObject {
  
  static var synthesizedIdPrefix: String { set get };
  
  var synthesizedID: Int { get };
  
  var synthesizedUUID: UUID { get };
  
};

extension RNIIdentifiable {
  fileprivate var identifier: RNIObjectIdentifier {
    if let identifier = RNIObjectIdentifierMap.map.object(forKey: self) {
      return identifier;
    };
    
    let identifier = RNIObjectIdentifier();
    RNIObjectIdentifierMap.map.setObject(identifier, forKey: self);
    
    return identifier;
  };
  
  static var synthesizedIdPrefix: String { "" };
  
  public var synthesizedID: Int {
    self.identifier.id;
  };
  
  public var synthesizedStringID: String {
    Self.synthesizedIdPrefix + "\(self.synthesizedID)";
  };
  
  public var synthesizedUUID: UUID {
    self.identifier.uuid;
  };
};
