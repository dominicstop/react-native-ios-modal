//
//  TestRoutes.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/22/23.
//

import UIKit

enum TestRoutes {
  static let rootRouteKey: Self = .RNILayoutTest;

  case RNILayoutTest;
  case RNIDraggableTest;
  case BlurEffectTest;
  case RoundedViewTest;
  case AdaptiveModalPresentationTest;
  
  var viewController: UIViewController {
    switch self {
      case .RNILayoutTest:
        return RNILayoutTestViewController();
        
      case .RNIDraggableTest:
        return RNIDraggableTestViewController();
        
      case .BlurEffectTest:
        return BlurEffectTestViewController();
        
      case .RoundedViewTest:
        return RoundedViewTestViewController();
        
      case .AdaptiveModalPresentationTest:
        return AdaptiveModalPresentationTestViewController();
    };
  };
};
