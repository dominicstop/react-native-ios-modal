//
//  RNIObjectMetadata.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/31/23.
//

import Foundation

fileprivate let RNIObjectMetadataMap = NSMapTable<AnyObject, AnyObject>(
  keyOptions: .weakMemory,
  valueOptions: .strongMemory
);

public protocol RNIObjectMetadata: AnyObject {
  associatedtype T: AnyObject;
  
  var metadata: T? { get set };
};

public extension RNIObjectMetadata {
  var metadata: T? {
    set {
      if let newValue = newValue {
        RNIObjectMetadataMap.setObject(newValue, forKey: self);
        
      } else {
        RNIObjectMetadataMap.removeObject(forKey: self);
      };
    }
    get {
      RNIObjectMetadataMap.object(forKey: self) as? T
    }
  };
};
