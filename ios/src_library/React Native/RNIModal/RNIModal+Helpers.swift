//
//  RNIModal+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/18/23.
//

import Foundation


extension RNIModalState where Self: RNIModalPresentation {
  
  /// Programmatically check if this instance is presented
  var synthesizedIsModalPresented: Bool {
    let listPresentedVC =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    return listPresentedVC.contains {
      $0 === self;
    };
  };
  
  /// Programmatically check if this instance is in focus
  var synthesizedIsModalInFocus: Bool? {
    let listPresentedVC =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    
    guard let topmostVC = listPresentedVC.last else { return nil };
    return topmostVC === self.modalViewController;
  };
};
