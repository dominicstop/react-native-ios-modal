//
//  UIWindow+WindowMetadata.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/30/23.
//

import Foundation


fileprivate final class WindowMetadata {
  static var counterID = -1;
  
  let id: Int = {
    WindowMetadata.counterID += 1;
    return WindowMetadata.counterID;
  }();
  
  let uuid = UUID();
};


public extension UIWindow {
  
  fileprivate static let windowMetadataMap = NSMapTable<UIWindow, WindowMetadata>(
    keyOptions: .weakMemory,
    valueOptions: .strongMemory
  );
  
  fileprivate var windowMetadata: WindowMetadata {
    if let windowMetadata = Self.windowMetadataMap.object(forKey: self) {
      return windowMetadata;
    };
    
    let windowMetadata = WindowMetadata();
    Self.windowMetadataMap.setObject(windowMetadata, forKey: self);
    
    return windowMetadata;
  };
  
  var windowID: Int {
    self.windowMetadata.id;
  };
  
  var windowUUID: UUID {
    self.windowMetadata.uuid;
  };
};
