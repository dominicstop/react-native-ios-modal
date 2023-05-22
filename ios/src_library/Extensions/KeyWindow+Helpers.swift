//
//  KeyWindow+Helpers.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/26/20.
//

import UIKit

extension UIWindow {
  
  /// TODO:2023-03-24-01-14-26 - Remove/Replace `UIWindow.key`
  static var key: UIWindow? {
    if #available(iOS 13, *) {
      return UIApplication.shared.windows.first { $0.isKeyWindow };
      
    } else {
      return UIApplication.shared.keyWindow;
    };
  };
};
