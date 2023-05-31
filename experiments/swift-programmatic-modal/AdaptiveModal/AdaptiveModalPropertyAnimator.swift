//
//  AdaptiveModalPropertyAnimator.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/31/23.
//

import UIKit

struct AdaptiveModalPropertyAnimator {

  var inputAxisKey: KeyPath<CGPoint, CGFloat>;
  
  var interpolationRangeStart: AdaptiveModalInterpolationPoint;
  var interpolationRangeEnd: AdaptiveModalInterpolationPoint;
  
  var animator: UIViewPropertyAnimator;
  
  private weak var component: AnyObject?;
  
  private var inputRangeStart: CGFloat {
    self.interpolationRangeStart
      .computedRect.origin[keyPath: self.inputAxisKey];
  };
  
  private var inputRangeEnd: CGFloat {
    self.interpolationRangeEnd
      .computedRect.origin[keyPath: self.inputAxisKey];
  };
  
  init<T: AnyObject>(
    interpolationRangeStart: AdaptiveModalInterpolationPoint,
    interpolationRangeEnd: AdaptiveModalInterpolationPoint,
    forComponent component: T,
    withInputAxisKey inputAxisKey: KeyPath<CGPoint, CGFloat>,
    animation: @escaping (
      _ component: T,
      _ interpolationPoint: AdaptiveModalInterpolationPoint
    ) -> Void
  ) {
    self.interpolationRangeStart = interpolationRangeStart;
    self.interpolationRangeEnd = interpolationRangeEnd;
    
    self.inputAxisKey = inputAxisKey;
    self.component = component;
    
    let animator = UIViewPropertyAnimator(
      duration: 0,
      curve: .linear
    );
    
    animator.addAnimations {
      animation(component, interpolationRangeEnd);
    };
    
    
    self.animator = animator;
  };
  
  mutating func didRangeChange(
    interpolationRangeStart: AdaptiveModalInterpolationPoint,
    interpolationRangeEnd: AdaptiveModalInterpolationPoint
  ) -> Bool {
    let didChange =
      interpolationRangeStart != self.interpolationRangeStart ||
      interpolationRangeEnd   != self.interpolationRangeEnd;
  
    return didChange;
  };
  
  func setFractionComplete(forPercent percent: CGFloat) {
    self.animator.fractionComplete = percent;
  };
  
  func setFractionComplete(forInputValue inputValue: CGFloat) {
    let inputRangeEndAdj = self.inputRangeEnd - self.inputRangeStart;
    let inputValueAdj = inputValue - self.inputRangeStart;
    
    let percent = inputValueAdj / inputRangeEndAdj;
    
    print(
        "component: \(self.component)"
      + "\n - percent: \(percent)"
    );
    self.setFractionComplete(forPercent: percent);
  };
  
  func clear(){
    self.animator.stopAnimation(true);
  };
};
