//
//  RNIModal+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/18/23.
//

import Foundation

extension RNIModalState where Self: RNIIdentifiable {
  var modalNativeID: String {
    self.synthesizedStringID
  };
};

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
  
  /// Programmatically get the "modal index"
  var synthesizedModalIndex: Int {
    let listPresentedVC =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    var index = -1;
    
    for vc in listPresentedVC {
      if vc.presentingViewController != nil {
        index += 1;
      };
      
      guard vc === self.modalViewController else { continue };
      return index;
    };
    
    return -1;
  };
  
  var synthesizedCurrentModalIndex: Int {
    guard let window = self.window else { return -1 };
    return RNIModalManagerShared.getCurrentModalIndex(for: window);
  };
};

extension RNIModalState where Self: RNIModal {
  
  var synthesizedModalData: RNIModalData {
    return RNIModalData(
      modalNativeID: self.modalNativeID,
      modalIndex: self.modalIndex,
      currentModalIndex: self.synthesizedCurrentModalIndex,
      isModalPresented: self.isModalPresented,
      isModalInFocus: self.isModalInFocus,
      synthesizedIsModalInFocus: self.synthesizedIsModalInFocus,
      synthesizedIsModalPresented: self.synthesizedIsModalPresented,
      synthesizedModalIndex: self.synthesizedModalIndex,
      synthesizedWindowID: self.window?.synthesizedStringID
    );
  };
  
  var synthesizedModalDataDict: Dictionary<String, Any> {
    self.synthesizedModalData.synthesizedDictionary;
  };
};
