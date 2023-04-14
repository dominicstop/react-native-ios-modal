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
  
  internal var synthesizedWindowMapData: RNIWindowMapData? {
    guard let window = self.window else { return nil };
    return RNIModalWindowMapShared.get(forWindow: window);
  };
  
  /// Programmatically check if this instance is presented
  public var computedIsModalPresented: Bool {
    let listPresentedVC =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    return listPresentedVC.contains {
      $0 === self.modalViewController;
    };
  };
  
  /// Programmatically check if this instance is in focus
  public var computedIsModalInFocus: Bool {
    let listPresentedVC =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    guard let topmostVC = listPresentedVC.last
    else { return self.synthesizedIsModalInFocus };
    
    return topmostVC === self.modalViewController;
  };
  
  /// Note:2023-03-31-15-41-04
  ///
  /// * This is based on the view controller hierarchy
  /// * So parent/child view controller that aren't modals are also counted
  ///
  public var computedViewControllerIndex: Int {
    let listPresentedVC =
      RNIModalManager.getPresentedViewControllers(for: self.window);
    
    for (index, vc) in listPresentedVC.enumerated() {
      guard vc === self.modalViewController else { continue };
      return index;
    };
    
    return -1;
  };
  
  /// Programmatically get the "modal index"
  public var computedModalIndex: Int {
    guard let window = self.window,
          let modalVC = self.modalViewController
    else { return -1 };
    
    return RNIModalManager.computeModalIndex(
      forWindow: window,
      forViewController: modalVC
    );
  };
  
  public var currentModalIndex: Int {
    self.synthesizedWindowMapData?.modalIndexCurrent ?? -1;
  };
  
  public var computedCurrentModalIndex: Int {
    RNIModalManager.computeModalIndex(forWindow: self.window);
  };
  
  public var synthesizedIsModalInFocus: Bool {
    self.modalPresentationState.isPresented &&
      self.modalFocusState.state.isFocused;
  };
};

extension RNIModalState where Self: RNIModal {
  
  public var synthesizedModalData: RNIModalData {
    return RNIModalData(
      modalNativeID: self.modalNativeID,
      modalIndex: self.modalIndex,
      currentModalIndex: self.currentModalIndex,
      
      modalFocusState: self.modalFocusState.state,
      modalFocusStatePref: self.modalFocusState.statePrev,
      
      wasBlurCancelled: self.modalFocusState.wasBlurCancelled,
      wasFocusCancelled: self.modalFocusState.wasFocusCancelled,
      
      modalPresentationState: self.modalPresentationState.state,
      modalPresentationStatePrev: self.modalPresentationState.statePrev,
      
      isInitialPresent: self.modalPresentationState.isInitialPresent,
      wasCancelledDismissViaGesture:
        self.modalPresentationState.wasCancelledDismissViaGesture,
      
      isModalPresented: self.modalPresentationState.isPresented,
      isModalInFocus: self.synthesizedIsModalInFocus,
      
      computedIsModalInFocus: self.computedIsModalInFocus,
      computedIsModalPresented: self.computedIsModalPresented,
      
      computedModalIndex: self.computedModalIndex,
      computedViewControllerIndex: self.computedViewControllerIndex,
      computedCurrentModalIndex: self.computedCurrentModalIndex,
      
      synthesizedWindowID: self.window?.synthesizedStringID
    );
  };
};
