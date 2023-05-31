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
  static func getDefaultSnapPoint(
    forDirection direction: AdaptiveModalConfig.Direction
  ) -> RNILayoutPreset {
    switch direction {
      case .bottomToTop: return .offscreenTop;
      case .topToBottom: return .offscreenBottom;
      case .leftToRight: return .offscreenLeft;
      case .rightToLeft: return .offscreenRight;
    };
  };
  
  static func getDefault(
    forDirection direction: AdaptiveModalConfig.Direction
  ) -> Self {
    Self.init(
      snapPoint: Self.getDefaultSnapPoint(forDirection: direction)
    );
  };
};
