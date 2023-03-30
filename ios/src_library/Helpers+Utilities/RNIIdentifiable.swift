//
//  RNIIdentifiable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/31/23.
//

import Foundation

public final class RNIObjectIdentifier {
  static var counterID = -1;
  
  let id: Int = {
    RNIObjectIdentifier.counterID += 1;
    return RNIObjectIdentifier.counterID;
  }();
  
  let uuid = UUID();
};

public protocol RNIIdentifiable:
  AnyObject, RNIObjectMetadata where T == RNIObjectIdentifier {
  
  static var synthesizedIdPrefix: String { set get };
  
  var synthesizedID: Int { get };
  
  var synthesizedUUID: UUID { get };
  
};

extension RNIIdentifiable {
   
  public var synthesizedIdentifier: RNIObjectIdentifier {
    if let identifier = self.metadata {
      return identifier;
    };
    
    let identifier = RNIObjectIdentifier();
    self.metadata = identifier;
    
    return identifier;
  };
  
  static var synthesizedIdPrefix: String { "" };
  
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
