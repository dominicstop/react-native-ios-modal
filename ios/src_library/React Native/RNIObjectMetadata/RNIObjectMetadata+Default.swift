//
//  RNIObjectMetadata+Default.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/27/23.
//

import UIKit

fileprivate let RNIObjectMetadataMap = NSMapTable<AnyObject, AnyObject>(
  keyOptions: .weakMemory,
  valueOptions: .strongMemory
);

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
