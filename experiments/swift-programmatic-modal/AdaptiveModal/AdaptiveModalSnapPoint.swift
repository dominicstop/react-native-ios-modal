//
//  AdaptiveModalSnapPoint.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit

struct AdaptiveModalSnapPointConfig {
  let snapPoint: RNILayout;
  let animationKeyframe: AdaptiveModalAnimationConfig?;
  
  init(
    snapPoint: RNILayout,
    animationKeyframe: AdaptiveModalAnimationConfig? = nil
  ) {
    self.snapPoint = snapPoint
    self.animationKeyframe = animationKeyframe
  };
  
  init(
    fromSnapPointPreset snapPointPreset: AdaptiveModalSnapPointPreset,
    fromBaseLayoutConfig baseLayoutConfig: RNILayout
  ) {
    let snapPointLayoutPreset = snapPointPreset.snapPointPreset;
    
    let snapPointLayout = snapPointLayoutPreset.getLayoutConfig(
      fromBaseLayoutConfig: baseLayoutConfig
    );
    
    self.snapPoint = snapPointLayout;
    self.animationKeyframe = snapPointPreset.animationKeyframe;
  };
};

//extension AdaptiveModalSnapPointConfig {
//
//  static func deriveSnapPoints(
//    initialSnapPoint: AdaptiveModalSnapPointPreset,
//    inBetweenSnapPoints: [AdaptiveModalSnapPointConfig],
//    overshootSnapPoint: AdaptiveModalSnapPointPreset
//  ) -> [AdaptiveModalSnapPointConfig] {
//
//    var snapPoints: [AdaptiveModalSnapPointConfig] = [];
//
//    return snapPoints;
//  };
//};
