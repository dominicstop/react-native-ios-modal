//
//  RNIUtilities+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/27/23.
//

import UIKit

/// TODO:2023-03-20-21-29-36 - Move to `RNIUtilities`
extension RNIUtilities {
  
  static func swizzleExchangeMethods(
    defaultSelector: Selector,
    newSelector: Selector,
    forClass class: AnyClass
  ) {
    let defaultInstace =
      class_getInstanceMethod(`class`.self, defaultSelector);
    
    let newInstance =
      class_getInstanceMethod(`class`.self, newSelector);
    
    guard let defaultInstance = defaultInstace,
          let newInstance = newInstance
    else { return };
          
    method_exchangeImplementations(defaultInstance, newInstance);
  };
  
  static func getFirstMatchingView(
    forNativeID targetNativeID: String,
    startingView rootView: UIView
  ) -> UIView? {
  
    for view in rootView.subviews {
      if let viewNativeID = view.nativeID,
         viewNativeID == targetNativeID {
         
         return view;
      };
      
      let matchingView = Self.getFirstMatchingView(
        forNativeID: targetNativeID,
        startingView: view
      );
      
      guard let matchingView = matchingView else { continue };
      return matchingView;
    };
    
    return nil;
  };

  public static func getWindows() -> [UIWindow] {
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
  
  public static func getRootViewController(
    for window: UIWindow? = nil
  ) -> UIViewController? {
    
    if let window = window {
      return window.rootViewController;
    };
    
    return Self.getWindows().first?.rootViewController;
  };
  
  public static func getPresentedViewControllers(
    for window: UIWindow? = nil
  ) -> [UIViewController] {
    guard let rootVC = Self.getRootViewController(for: window) else {
      #if DEBUG
      print(
          "Error - RNIModalManager.getTopMostPresentedVC"
        + " - arg window isNil: '\(window == nil)'"
        + " - Could not get root view controller"
      );
      #endif
      return [];
    };
    
    var presentedVCList: [UIViewController] = [rootVC];
    
    // climb the vc hierarchy to find the topmost presented vc
    while true {
      guard let topVC = presentedVCList.last,
            let presentedVC = topVC.presentedViewController
      else { break };
      
      presentedVCList.append(presentedVC);
    };
    
    return presentedVCList;
  };
  
  public static func getTopmostPresentedViewController(
    for window: UIWindow? = nil
  ) -> UIViewController? {
    return Self.getPresentedViewControllers(for: window).last;
  };
};
