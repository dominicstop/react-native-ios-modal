//
//  RNILayoutPreset.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit

enum RNILayoutPreset {
  case offscreenBottom, offscreenTop, offscreenLeft, offscreenRight;
  case halfOffscreenBottom, halfOffscreenTop, halfOffscreenLeft, halfOffscreenRight;
  case edgeBottom, edgeTop, edgeLeft, edgeRight;
  case center;
  
  case layoutConfig(_ config: RNILayout);
  
  func getLayoutConfig(
    fromBaseLayoutConfig baseLayoutConfig: RNILayout,
    withTargetRect targetRect: CGRect,
    currentSize: CGSize
  ) -> RNILayout {
  
    let baseRect = baseLayoutConfig.computeRect(
      withTargetRect: targetRect,
      currentSize: currentSize
    );
  
    switch self {
      case .offscreenBottom:
        return .init(
          derivedFrom: baseLayoutConfig
        );
      
      case .offscreenTop:
        return .init(
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .top,
          marginTop: -baseRect.height
        );
      
      case .offscreenLeft:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .left,
          marginLeft: -baseRect.width
        );
      
      case .offscreenRight:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .right,
          marginRight: baseRect.width
        );
      
      case .edgeBottom:
        return .init(
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .bottom
        );
        
      case .halfOffscreenBottom:
        return .init(
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .top,
          marginTop: baseRect.height / 2
        );
      
      case .halfOffscreenTop:
        return .init(
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .top,
          marginTop: -(baseRect.height / 2)
        );
        
      case .halfOffscreenLeft:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .left,
          marginLeft: -(baseRect.width / 2)
        );
        
      case .halfOffscreenRight:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .right,
          marginRight: baseRect.width / 2
        );
      
      case .edgeTop:
        return .init(
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .top
        );
      
      case .edgeLeft:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .left
        );
      
      case .edgeRight:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .right
        );
      
      case .center:
        return .init(
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .center
        );
      
      case let .layoutConfig(config):
        return config;
    };
  };
};


