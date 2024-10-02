//
//  UIViewController+ModaRegistryHelpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/2/24.
//

import UIKit

public extension UIViewController {

  var associatedModalEventManager: ModalEventsManager? {
    let window = self.view.window ?? UIApplication.shared.activeWindow;
    
    guard let window = window else {
      return nil;
    };
    
    return ModalEventsManagerRegistry.shared.getManager(forWindow: window);
  };
  
  var modalRegistryEntry: ModalRegistryEntry? {
    guard let modalEventManager = self.associatedModalEventManager,
          let entryMatch = modalEventManager.modalRegistry.getEntry(for: self)
    else {
      return nil;
    };
    
    return entryMatch;
  };
  
  var isRegisteredInModalRegistry: Bool {
    self.modalRegistryEntry != nil;
  };
  
  var modalFocusStatePrev: ModalFocusState? {
    self.modalRegistryEntry?.modalFocusStatePrev;
  };
  
  var modalFocusState: ModalFocusState? {
    self.modalRegistryEntry?.modalFocusState;
  };
};

