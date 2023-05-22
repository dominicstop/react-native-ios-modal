//
//  RNIIdentifiable+Default.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/27/23.
//

import UIKit

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
