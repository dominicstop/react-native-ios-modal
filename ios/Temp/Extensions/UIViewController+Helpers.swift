//
//  UIViewController+Helpers.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/26/22.
//

import UIKit

internal extension UIViewController {
  func attachChildVC(_ child: UIViewController) {
    self.addChild(child);
    self.view.addSubview(child.view);
    child.didMove(toParent: self);
  };

  func detachFromParentVC() {
    guard self.parent != nil else { return };

    self.willMove(toParent: nil);
    self.view.removeFromSuperview();
    self.removeFromParent();
  };
};
