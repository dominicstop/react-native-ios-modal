//
//  KeyWindow+Helpers.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/26/20.
//

import Foundation

extension UIWindow {
  static var key: UIWindow? {
    if #available(iOS 13, *) {
      return UIApplication.shared.windows.first { $0.isKeyWindow };
      
    } else {
      return UIApplication.shared.keyWindow;
    };
  };
};
