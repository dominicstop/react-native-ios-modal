//
//  TestRoutes.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/22/23.
//

import UIKit

enum TestRoutes {
  static let rootRouteKey: Self = .RNIDraggableTest;

  case RNILayoutTest;
  case RNIDraggableTest;
  case BlurEffectTest;
  
  var viewController: UIViewController {
    switch self {
      case .RNILayoutTest:
        return RNILayoutTestViewController();
        
      case .RNIDraggableTest:
        return RNIDraggableTestViewController();
        
      case .BlurEffectTest:
        return BlurEffectTestViewController();
    };
  };
};
