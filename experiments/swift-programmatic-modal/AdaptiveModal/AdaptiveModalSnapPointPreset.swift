//
//  AdaptiveModalSnapPointPreset.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/31/23.
//

import Foundation

struct AdaptiveModalSnapPointPreset {

  let snapPointPreset: RNILayoutPreset;
  let animationKeyframe: AdaptiveModalAnimationConfig?;
  
  init(
    snapPoint: RNILayoutPreset,
    animationKeyframe: AdaptiveModalAnimationConfig? = nil
  ) {
    self.snapPointPreset = snapPoint;
    self.animationKeyframe = animationKeyframe;
  };
};

extension AdaptiveModalSnapPointPreset {
  static func getDefaultOvershootSnapPoint(
    forDirection direction: AdaptiveModalConfig.Direction
  ) -> Self {
  
    let snapPoint: RNILayoutPreset = {
      switch direction {
        case .bottomToTop: return .edgeTop;
        case .topToBottom: return .edgeBottom;
        case .leftToRight: return .edgeLeft;
        case .rightToLeft: return .edgeRight;
      };
    }();
  
    return self.init(snapPoint: snapPoint);
  };
  
  static func getDefaultInitialSnapPoint(
    forDirection direction: AdaptiveModalConfig.Direction
  ) -> Self {
  
    let snapPoint: RNILayoutPreset = {
      switch direction {
        case .bottomToTop: return .offscreenBottom;
        case .topToBottom: return .offscreenTop;
        case .leftToRight: return .offscreenLeft;
        case .rightToLeft: return .offscreenRight;
      };
    }();
  
    return self.init(snapPoint: snapPoint);
  };
};
