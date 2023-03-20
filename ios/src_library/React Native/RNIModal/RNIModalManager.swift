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
  
  /// TODO:2023-03-20-21-29-36 - Move to `RNIUtilities`
  static func getRootViewController(
    for window: UIWindow? = nil
  ) -> UIViewController? {
    
    if let window = window {
      return window.rootViewController;
    };
    
    #if swift(>=5.5)
    // Version: Swift 5.5 and newer - iOS 15 and newer
    guard #available(iOS 13.0, *) else { return nil  };
    
    let scenes = UIApplication.shared.connectedScenes;
    
    guard let windowScene = scenes.first as? UIWindowScene,
          let window = windowScene.windows.first
    else { return nil };
    
    return window.rootViewController;
    
    #elseif swift(>=5)
    // Version: Swift 5.4 and below - iOS 14.5 and below
    // Note: 'windows' was deprecated in iOS 15.0+
    guard let window = UIApplication.shared.windows.first else { return nil };
    return window.rootViewController;

    #elseif swift(>=4)
    // Version: Swift 4 and below - iOS 12.4 and below
    // Note: `keyWindow` was deprecated in iOS 13.0+
    guard let window = UIApplication.shared.keyWindow else { return nil };
    return window.rootViewController;
    
    #else
    // Version: Swift 3.1 and below - iOS 10.3 and below
    // Note: 'sharedApplication' has been renamed to 'shared'
    guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate,
          let window = appDelegate.window
    else { return nil };
    
    return window.rootViewController;
    #endif
  };
  
  public static func getPresentedViewControllers() -> [UIViewController] {
    guard let rootVC = Self.getRootViewController() else {
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
  
  public static func getTopmostPresentedViewController() -> UIViewController? {
    return Self.getPresentedViewControllers().last;
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
