//
//  RNIModalManager.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/9/23.
//

import Foundation

public let RNIModalManagerShared = RNIModalManager.sharedInstance;

public class RNIModalManager {
  
  // MARK: - Static Properties
  // -------------------------
  
  public static let sharedInstance = RNIModalManager();
  
  // MARK: - Static Functions
  // ------------------------
  
  /// TODO:2023-03-20-21-29-36 - Move to `RNIUtilities`
  static func getWindows() -> [UIWindow] {
    var windows: [UIWindow] = [];
    
    #if swift(>=5.5)
    // Version: Swift 5.5 and newer - iOS 15 and newer
    guard #available(iOS 13.0, *) else { return [] };
    
    for scene in UIApplication.shared.connectedScenes {
      guard let windowScene = scene as? UIWindowScene else { continue };
      windows += windowScene.windows;
    };
    
    #elseif swift(>=5)
    // Version: Swift 5.4 and below - iOS 14.5 and below
    // Note: 'windows' was deprecated in iOS 15.0+
    
    // first element is the "key window"
    if let keyWindow =
        UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
      
      windows.append(keyWindow);
    };
    
    UIApplication.shared.windows.forEach {
      // skip if already added
      guard !windows.contains($0) else { return };
      windows.append($0);
    };

    #elseif swift(>=4)
    // Version: Swift 4 and below - iOS 12.4 and below
    // Note: `keyWindow` was deprecated in iOS 13.0+
    
    // first element is the "key window"
    if let keyWindow = UIApplication.shared.keyWindow {
      windows.append(keyWindow);
    };
    
    UIApplication.shared.windows.forEach {
      // skip if already added
      guard !windows.contains($0) else { return };
      windows.append($0);
    };
    
    #else
    // Version: Swift 3.1 and below - iOS 10.3 and below
    // Note: 'sharedApplication' has been renamed to 'shared'
    guard let appDelegate =
            UIApplication.sharedApplication().delegate as? AppDelegate,
          
          let window = appDelegate.window
    else { return [] };
    
    return windows.append(window);
    #endif
    
    return windows;
  };
  
  /// TODO:2023-03-20-21-29-36 - Move to `RNIUtilities`
  static func getRootViewController(
    for window: UIWindow? = nil
  ) -> UIViewController? {
    
    if let window = window {
      return window.rootViewController;
    };
    
    return Self.getWindows().first?.rootViewController;
  };
  
  /// TODO:2023-03-20-21-29-36 - Move to `RNIUtilities`
  public static func getPresentedViewControllers(
    for window: UIWindow? = nil
  ) -> [UIViewController] {
    guard let rootVC = Self.getRootViewController(for: window) else {
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
  
  /// TODO:2023-03-20-21-29-36 - Move to `RNIUtilities`
  public static func getTopmostPresentedViewController(
    for window: UIWindow? = nil
  ) -> UIViewController? {
    return Self.getPresentedViewControllers(for: window).last;
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

/// The modal instances will notify the manager when they're about to show/hide
/// a modal.
///
extension RNIModalManager: RNIModalFocusNotifiable {
  
  public func onModalWillFocusNotification(
    sender modal: RNIModal
  ) {
    self.currentModalIndex += 1;
    
    modal.modalIndex = self.currentModalIndex;
    modal.onModalWillFocusNotification(sender: modal);
    
    self.modalInstances.forEach {
      guard $0 !== modal,
            $0.isModalPresented,
            $0.isModalInFocus,
            $0.modalIndex == self.currentModalIndex - 1
      else { return };
      
      $0.onModalWillBlurNotification(sender: modal);
    };
  };
  
  public func onModalDidFocusNotification(sender modal: RNIModal) {
    modal.isModalInFocus = true;
    modal.isModalPresented = true;
    
    modal.onModalDidFocusNotification(sender: modal);
    
    self.modalInstances.forEach {
      guard $0 !== modal,
            $0.isModalPresented,
            $0.isModalInFocus,
            $0.modalIndex == self.currentModalIndex - 1
      else { return };
      
      $0.isModalInFocus = false;
      $0.onModalDidBlurNotification(sender: modal);
    };
  };
  
  public func onModalWillBlurNotification(sender modal: RNIModal) {
    self.currentModalIndex -= 1;
    modal.modalIndex = -1;
    
    modal.onModalWillBlurNotification(sender: modal);
    
    self.modalInstances.forEach {
      guard $0 !== modal,
            $0.isModalPresented,
            !$0.isModalInFocus,
            $0.modalIndex >= self.currentModalIndex
      else { return };
      
      $0.onModalWillFocusNotification(sender: modal);
    };
  };
  
  public func onModalDidBlurNotification(sender modal: RNIModal) {
    modal.isModalInFocus = false;
    modal.isModalPresented = false;
    
    self.modalInstances.forEach {
      guard $0 !== modal,
            $0.isModalPresented,
            !$0.isModalInFocus,
            $0.modalIndex >= self.currentModalIndex
      else { return };
      
      $0.isModalInFocus = true;
      $0.onModalDidFocusNotification(sender: modal);
    };
  };
};
