//
//  UIWindow+ModalHelpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import UIKit
import DGSwiftUtilities


extension UIWindow {

  public var rootPresentingViewController: UIViewController? {
    self.rootViewController?.presentingViewController?.rootPresentingViewController;
  };
  
  public var allPresentedViewControllers: [UIViewController] {
    guard let rootVC = self.rootViewController,
          let currentPresentedVC = rootVC.presentedViewController
    else {
      return [];
    };
    
    return currentPresentedVC.recursivelyGetAllPresentedViewControllers;
  };
  
  /// The current highest modal level in the window
  ///
  /// return value of `nil` means that there is no modal presented, and a
  /// return value of `0` is the first presented modal, and so on...
  ///
  public var currentModalLevel: Int? {
    let presentedControllersCount = allPresentedViewControllers.count;
    
    guard presentedControllersCount > 0 else {
      return nil;
    };
    
    return presentedControllersCount - 1;
  };
};
