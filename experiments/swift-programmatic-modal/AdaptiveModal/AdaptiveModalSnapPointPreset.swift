//
//  AdaptiveModalInitialSnapPoint.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit

enum AdaptiveModalSnapPointPreset {
  case offscreenBottom, offscreenTop, offscreenLeft, offscreenRight;
  case edgeBottom, edgeTop, edgeLeft, edgeRight;
  case center;
  
  case layoutConfig(_ config: RNILayout);
  
  func computeSnapPoint(
    fromSnapPointConfig prevSnapPoint: RNILayout,
    withTargetRect targetRect: CGRect,
    currentSize: CGSize
  ) -> RNILayout {
  
    let prevRect = prevSnapPoint.computeRect(
      withTargetRect: targetRect,
      currentSize: currentSize
    );
  
    switch self {
      case .offscreenBottom:
        return .init(
          derivedFrom: prevSnapPoint
        );
      
      case .offscreenTop:
        return .init(
          derivedFrom: prevSnapPoint,
          verticalAlignment: .top,
          marginTop: -prevRect.height
        );
      
      case .offscreenLeft:
        return .init(
          derivedFrom: prevSnapPoint,
          horizontalAlignment: .left,
          marginLeft: -prevRect.width
        );
      
      case .offscreenRight:
        return .init(
          derivedFrom: prevSnapPoint,
          horizontalAlignment: .right,
          marginRight: prevRect.width
        );
      
      case .edgeBottom:
        return .init(
          derivedFrom: prevSnapPoint,
          verticalAlignment: .bottom
        );
      
      case .edgeTop:
        return .init(
          derivedFrom: prevSnapPoint,
          verticalAlignment: .top
        );
      
      case .edgeLeft:
        return .init(
          derivedFrom: prevSnapPoint,
          horizontalAlignment: .left
        );
      
      case .edgeRight:
        return .init(
          derivedFrom: prevSnapPoint,
          horizontalAlignment: .right
        );
      
      case .center:
        return .init(
          derivedFrom: prevSnapPoint,
          verticalAlignment: .center
        );
      
      case let .layoutConfig(config):
        return config;
    };
  };
};
