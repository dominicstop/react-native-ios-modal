//
//  RNIModalManager.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/9/23.
//

import Foundation


public class RNIModalManager {

  public static let sharedInstance = RNIModalManager();
  
  // MARK: - Properties
  // ------------------
  
  private var counterModalID: UInt = 0;
  
  private(set) public var currentModalIndex = -1;
  
  private(set) public var modalInstanceDict = RNIWeakDictionary<String, RNIModal>();
  
  // MARK: - Properties - Computed
  // -----------------------------
  
  public var isAnyModalPresented: Bool {
    self.currentModalIndex >= 0;
  };
  
  public var modalInstances: [RNIModal] {
    self.modalInstanceDict.dict.compactMap {
      $0.value.synthesizedRef;
    };
  };
  
  public var presentedModals: [RNIModal] {
    self.modalInstances.compactMap {
      $0.isModalPresented ? $0 : nil;
    };
  };
  
  // MARK: - Methods
  // ---------------
  
  private func createModalID() -> String {
    let modalID = self.counterModalID;
    self.counterModalID += 1;
    
    return "modal-id:\(modalID)";
  };
  
  public func register(modal: RNIModal) {
    let key = self.createModalID();
    
    modal.modalID = key;
    modal.modalIndex = -1;
    
    modal.isModalPresented = false;
    modal.isModalInFocus = false;
    
    modal.modalFocusDelegate = self;
    
    self.modalInstanceDict[key] = modal;
  };
};

// MARK: RNIModalFocusNotifiable
// -----------------------------

/// The modal instances wjll notify the manager when they're about to show/hide
/// a modal.
///
extension RNIModalManager: RNIModalFocusNotifiable {
  
  public func onModalWillFocusNotification(sender modal: RNIModal) {
    self.currentModalIndex += 1;
    modal.modalIndex = self.currentModalIndex;
    
    for modalItem in self.modalInstances {
      // skip the modal that sent the notification
      guard modalItem.modalID != modal.modalID
      else { continue };
      
      modalItem.onModalWillFocusNotification(sender: modal);
    };
  };
  
  public func onModalDidFocusNotification(sender modal: RNIModal) {
    modal.isModalInFocus = true;
    modal.isModalPresented = true;
    
    for modalItem in self.modalInstances {
      // skip the modal that sent the notification
      guard modalItem.modalID != modal.modalID
      else { continue };
      
      modalItem.onModalDidFocusNotification(sender: modal);
    };
  };
  
  public func onModalWillBlurNotification(sender modal: RNIModal) {
    self.currentModalIndex -= 1;
    modal.modalIndex = -1;
    
    for modalItem in self.modalInstances {
      // skip the modal that sent the notification
      guard modalItem.modalID != modal.modalID
      else { continue };
      
      modalItem.onModalWillBlurNotification(sender: modal);
    };
  };
  
  public func onModalDidBlurNotification(sender modal: RNIModal) {
    modal.isModalInFocus = false;
    modal.isModalPresented = false;
    
    for modalItem in self.modalInstances {
      // skip the modal that sent the notification
      guard modalItem.modalID != modal.modalID
      else { continue };
      
      modalItem.onModalDidBlurNotification(sender: modal);
    };
  };
};
