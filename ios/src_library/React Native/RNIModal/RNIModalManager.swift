//
//  RNIModalManager.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/9/23.
//

import Foundation


public class RNIModalManager {
  
  // MARK: - Static Properties
  // -------------------------
  
  public static let sharedInstance = RNIModalManager();
  
  // MARK: - Static Functions
  // ------------------------
  
  public static func getPresentedViewControllers() -> [UIViewController] {
    guard let rootVC = UIWindow.key?.rootViewController else {
      #if DEBUG
      print(
        "RNIModalManager - getTopMostPresentedVC - Error: Could not get root "
        + "view controller"
      );
      #endif
      return [];
    };
    
    var presentedVCList: [UIViewController] = [rootVC];
    
    // climb the vc hierarchy to find the topmost presented vc
    while presentedVCList.last!.presentedViewController != nil {
      if let presentedVC = presentedVCList.last!.presentedViewController {
        presentedVCList.append(presentedVC);
      };
    };
    
    return presentedVCList;
  };
  
  // MARK: - Properties
  // ------------------
  
  private var counterModalNativeID: UInt = 0;
  
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
  
  private func createModalNativeID() -> String {
    let modalNativeID = self.counterModalNativeID;
    self.counterModalNativeID += 1;
    
    return "modal-native-id:\(modalNativeID)";
  };
  
  public func register(modal: RNIModal) {
    let key = self.createModalNativeID();
    
    modal.modalNativeID = key;
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
      guard modalItem.modalNativeID != modal.modalNativeID
      else { continue };
      
      modalItem.onModalWillFocusNotification(sender: modal);
    };
  };
  
  public func onModalDidFocusNotification(sender modal: RNIModal) {
    modal.isModalInFocus = true;
    modal.isModalPresented = true;
    
    for modalItem in self.modalInstances {
      // skip the modal that sent the notification
      guard modalItem.modalNativeID != modal.modalNativeID
      else { continue };
      
      modalItem.onModalDidFocusNotification(sender: modal);
    };
  };
  
  public func onModalWillBlurNotification(sender modal: RNIModal) {
    self.currentModalIndex -= 1;
    modal.modalIndex = -1;
    
    for modalItem in self.modalInstances {
      // skip the modal that sent the notification
      guard modalItem.modalNativeID != modal.modalNativeID
      else { continue };
      
      modalItem.onModalWillBlurNotification(sender: modal);
    };
  };
  
  public func onModalDidBlurNotification(sender modal: RNIModal) {
    modal.isModalInFocus = false;
    modal.isModalPresented = false;
    
    for modalItem in self.modalInstances {
      // skip the modal that sent the notification
      guard modalItem.modalNativeID != modal.modalNativeID
      else { continue };
      
      modalItem.onModalDidBlurNotification(sender: modal);
    };
  };
};
