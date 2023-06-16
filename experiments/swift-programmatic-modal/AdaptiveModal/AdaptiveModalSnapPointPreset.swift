//
//  AdaptiveModalSnapPointPreset.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/31/23.
//

import Foundation

struct AdaptiveModalSnapPointPreset {

  let layoutPreset: RNILayoutPreset;
  let animationKeyframe: AdaptiveModalAnimationConfig?;
  
  init(
    layoutPreset: RNILayoutPreset,
    animationKeyframe: AdaptiveModalAnimationConfig? = nil
  ) {
    self.layoutPreset = layoutPreset;
    self.animationKeyframe = animationKeyframe;
  };
};

extension AdaptiveModalSnapPointPreset {
  static func getDefaultOvershootSnapPoint(
    forDirection direction: AdaptiveModalConfig.Direction
  ) -> Self {
  
    let layoutPreset: RNILayoutPreset = {
      switch direction {
        case .bottomToTop: return .edgeTop;
        case .topToBottom: return .edgeBottom;
        case .leftToRight: return .edgeLeft;
        case .rightToLeft: return .edgeRight;
      };
    }();
  
    return self.init(layoutPreset: layoutPreset);
  };
  
  static func getDefaultInitialSnapPoint(
    forDirection direction: AdaptiveModalConfig.Direction
  ) -> Self {
  
    let layoutPreset: RNILayoutPreset = {
      switch direction {
        case .bottomToTop: return .offscreenBottom;
        case .topToBottom: return .offscreenTop;
        case .leftToRight: return .offscreenLeft;
        case .rightToLeft: return .offscreenRight;
      };
    }();
  
    return self.init(layoutPreset: layoutPreset);
  };
};
