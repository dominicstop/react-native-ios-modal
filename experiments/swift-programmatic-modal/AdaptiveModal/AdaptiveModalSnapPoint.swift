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
    fromBaseLayoutConfig baseLayoutConfig: RNILayout,
    withTargetRect targetRect: CGRect,
    currentSize: CGSize
  ){
    let snapPointLayoutPreset = snapPointPreset.snapPointPreset;
    
    let snapPointLayout = snapPointLayoutPreset.getLayoutConfig(
      fromBaseLayoutConfig: baseLayoutConfig,
      withTargetRect: targetRect,
      currentSize: currentSize
    );
    
    self.snapPoint = snapPointLayout;
    self.animationKeyframe = snapPointPreset.animationKeyframe;
  };
};
