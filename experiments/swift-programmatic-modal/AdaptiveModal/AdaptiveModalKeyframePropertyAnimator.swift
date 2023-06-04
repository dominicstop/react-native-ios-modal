//
//  AdaptiveModalPropertyAnimator.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/5/23.
//

import UIKit


struct AdaptiveModalKeyframePropertyAnimator {

  var animator: UIViewPropertyAnimator;
  
  private weak var component: UIView?;
  
  init<T: UIView>(
    interpolationPoints: [AdaptiveModalInterpolationPoint],
    forComponent component: T,
    animation: @escaping (
      _ component: T,
      _ interpolationPoint: AdaptiveModalInterpolationPoint
    ) -> Void
  ){
    let animator = UIViewPropertyAnimator(duration: 1, curve: .linear);
    
    self.animator = animator;
    self.component = component;
    
    animator.addAnimations {
      UIView.addKeyframe(
        withRelativeStartTime: 0,
        relativeDuration: 1
      ){
        component.transform = .identity;
      };
    
      for interpolationPoint in interpolationPoints {
        UIView.addKeyframe(
          withRelativeStartTime: interpolationPoint.percent,
          relativeDuration: 0
        ){
          animation(component, interpolationPoint);
        };
      };
    };
  };
  
  func setFractionComplete(forPercent percent: CGFloat) {
    self.animator.fractionComplete = 0;
  };
  
  func clear(){
    self.animator.stopAnimation(true);
  };
};
