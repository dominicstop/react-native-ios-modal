//
//  RNIModalViewControllerRegistry.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/27/23.
//

import Foundation

class RNIModalViewControllerRegistry {
  static let instanceMap = NSMapTable<
    UIViewController,
    RNIModalViewControllerWrapper
  >(
    keyOptions: .weakMemory,
    valueOptions: .weakMemory
  );
  
  static func get(
    forViewController viewController: UIViewController
  ) -> RNIModalViewControllerWrapper? {
    
    Self.instanceMap.object(forKey: viewController);
  };
  
  static func set(
    forViewController viewController: UIViewController,
    _ modalWrapper: RNIModalViewControllerWrapper
  ){
    
    Self.instanceMap.setObject(modalWrapper, forKey: viewController);
  };
  
  static func isRegistered(
    forViewController viewController: UIViewController
  ) -> Bool {
    Self.get(forViewController: viewController) != nil;
  };
};
