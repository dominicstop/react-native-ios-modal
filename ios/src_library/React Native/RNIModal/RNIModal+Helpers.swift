//
//  RNIModal+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/18/23.
//

import Foundation

extension RNIModalState where Self: RNIIdentifiable {
  public var modalNativeID: String {
    self.synthesizedStringID
  };
};

extension RNIModalState where Self: RNIModalPresentation {
  
  /// Programmatically check if this instance is presented
  public var synthesizedIsModalPresented: Bool {
    let listPresentedVC =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    return listPresentedVC.contains {
      $0 === self.modalViewController;
    };
  };
  
  /// Programmatically check if this instance is in focus
  public var synthesizedIsModalInFocus: Bool {
    let listPresentedVC =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    guard let topmostVC = listPresentedVC.last
    else { return self.isModalInFocus };
    
    return topmostVC === self.modalViewController;
  };
  
  /// Note:2023-03-31-15-41-04
  ///
  /// * This is based on the view controller hierarchy
  /// * So parent/child view controller that aren't modals are also counted
  ///
  public var synthesizedViewControllerIndex: Int {
    let listPresentedVC =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    for (index, vc) in listPresentedVC.enumerated() {
      guard vc === self.modalViewController else { continue };
      return index;
    };
    
    return -1;
  };
  
  /// Programmatically get the "modal index"
  public var synthesizedModalIndex: Int {
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
  
  public var synthesizedCurrentModalIndex: Int {
    guard let window = self.window else { return -1 };
    return RNIModalManagerShared.getCurrentModalIndex(for: window);
  };
};

extension RNIModalState where Self: RNIModal {
  
  public var synthesizedModalData: RNIModalData {
    return RNIModalData(
      modalNativeID: self.modalNativeID,
      modalIndex: self.modalIndex,
      currentModalIndex: self.synthesizedCurrentModalIndex,
      isModalPresented: self.modalState.isPresented,
      isModalInFocus: self.isModalInFocus,
      synthesizedIsModalInFocus: self.synthesizedIsModalInFocus,
      synthesizedIsModalPresented: self.synthesizedIsModalPresented,
      synthesizedModalIndex: self.synthesizedModalIndex,
      synthesizedViewControllerIndex: self.synthesizedViewControllerIndex,
      synthesizedWindowID: self.window?.synthesizedStringID
    );
  };
  
  public var synthesizedModalDataDict: Dictionary<String, Any> {
    self.synthesizedModalData.synthesizedDictionary;
  };
};
