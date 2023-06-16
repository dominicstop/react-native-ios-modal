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
    let snapPointLayoutPreset = snapPointPreset.layoutPreset;
    
    let snapPointLayout = snapPointLayoutPreset.getLayoutConfig(
      fromBaseLayoutConfig: baseLayoutConfig
    );
    
    self.snapPoint = snapPointLayout;
    self.animationKeyframe = snapPointPreset.animationKeyframe;
  };
};

extension AdaptiveModalSnapPointConfig {

  static func deriveSnapPoints(
    undershootSnapPoint: AdaptiveModalSnapPointPreset,
    inBetweenSnapPoints: [AdaptiveModalSnapPointConfig],
    overshootSnapPoint: AdaptiveModalSnapPointPreset
  ) -> [AdaptiveModalSnapPointConfig] {

    var items: [AdaptiveModalSnapPointConfig] = [];
    
    if let snapPointFirst = inBetweenSnapPoints.first {
      let initialSnapPointConfig = AdaptiveModalSnapPointConfig(
        fromSnapPointPreset: undershootSnapPoint,
        fromBaseLayoutConfig: snapPointFirst.snapPoint
      );
      
      items.append(initialSnapPointConfig);
    };
    
    items += inBetweenSnapPoints;
    
    if let snapPointLast = inBetweenSnapPoints.last {
      let overshootSnapPointConfig = AdaptiveModalSnapPointConfig(
        fromSnapPointPreset: overshootSnapPoint,
        fromBaseLayoutConfig: snapPointLast.snapPoint
      );
      
      items.append(overshootSnapPointConfig);
    };
    
    return items;
  };
};
