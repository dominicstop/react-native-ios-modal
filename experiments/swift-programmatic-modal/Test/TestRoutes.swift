//
//  TestRoutes.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/22/23.
//

import UIKit

enum TestRoutes {
  case RNILayoutTest;
  case RNIDraggableTest;
  
  var viewController: UIViewController {
    switch self {
      case .RNILayoutTest:
        return RNILayoutTestViewController();
        
      case .RNIDraggableTest:
        return RNIDraggableTestViewController();
    };
  };
};
