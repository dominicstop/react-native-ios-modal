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
      $0 === self.modalViewController;
    };
  };
  
  /// Programmatically check if this instance is in focus
  var synthesizedIsModalInFocus: Bool {
    let listPresentedVC =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    guard let topmostVC = listPresentedVC.last
    else { return self.isModalInFocus };
    
    return topmostVC === self.modalViewController;
  };
};

extension RNIModalIdentity where Self: RNIModalPresentation {
  
  /// Programmatically get the "modal index"
  var synthesizedModalIndex: Int {
    let listPresentedVC =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    for (index, vc) in listPresentedVC.enumerated() {
      guard vc != self.modalViewController else { continue };
      return index;
    };
    
    return -1;
  };
};

extension RNIModalIdentity where Self: RNIModal {
  
  var synthesizedModalData: RNIModalData {
    RNIModalData(
      modalNativeID: self.modalNativeID,
      modalIndex: self.modalIndex,
      currentModalIndex: RNIModalManagerShared.currentModalIndex,
      isModalPresented: self.isModalPresented,
      isModalInFocus: self.isModalInFocus,
      synthesizedIsModalInFocus: self.synthesizedIsModalInFocus,
      synthesizedIsModalPresented: self.synthesizedIsModalPresented,
      synthesizedModalIndex: self.synthesizedModalIndex
    );
  };
  
  var synthesizedModalDataDict: Dictionary<String, Any> {
    self.synthesizedModalData.synthesizedDictionary;
  };
};
