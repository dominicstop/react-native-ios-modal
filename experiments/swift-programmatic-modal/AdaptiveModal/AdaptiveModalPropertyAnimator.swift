//
//  AdaptiveModalPropertyAnimator.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/31/23.
//

import UIKit

struct AdaptiveModalPropertyAnimator {
  
  var interpolationRangeStart: AdaptiveModalInterpolationPoint;
  var interpolationRangeEnd: AdaptiveModalInterpolationPoint;
  
  let interpolationOutputKey:
    KeyPath<AdaptiveModalInterpolationPoint, CGFloat>;
  
  var animator: UIViewPropertyAnimator;
  
  private weak var component: AnyObject?;
  
  private var range: [AdaptiveModalInterpolationPoint] {[
    self.interpolationRangeStart,
    self.interpolationRangeEnd
  ]};
  
  init<T: AnyObject>(
    interpolationRangeStart: AdaptiveModalInterpolationPoint,
    interpolationRangeEnd: AdaptiveModalInterpolationPoint,
    forComponent component: T,
    interpolationOutputKey: KeyPath<AdaptiveModalInterpolationPoint, CGFloat>,
    animation: @escaping (
      _ component: T,
      _ interpolationPoint: AdaptiveModalInterpolationPoint
    ) -> Void
  ) {
    self.interpolationRangeStart = interpolationRangeStart;
    self.interpolationRangeEnd = interpolationRangeEnd;
    
    self.interpolationOutputKey = interpolationOutputKey;
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
  
  mutating func update(
    interpolationRangeStart: AdaptiveModalInterpolationPoint,
    interpolationRangeEnd: AdaptiveModalInterpolationPoint
  ){
    let didChange =
      interpolationRangeStart != self.interpolationRangeStart ||
      interpolationRangeEnd   != self.interpolationRangeEnd;
  
    guard didChange else { return };
    
    self.interpolationRangeStart = interpolationRangeStart;
    self.interpolationRangeEnd = interpolationRangeEnd;
  };
  
  func setFractionComplete(forPercent percent: CGFloat) {
    self.animator.fractionComplete = percent;
  };
  
  func setFractionComplete(
    forInputPercentValue inputPercentValue: CGFloat
  ) {
    let percent = AdaptiveModalManager.interpolate(
      inputValue: inputPercentValue,
      rangeInput: range.map {
        $0.percent
      },
      rangeOutput: range.map {
        $0[keyPath: self.interpolationOutputKey]
      }
    );
    
    guard let percent = percent else { return };
    self.setFractionComplete(forPercent: percent);
  };
  
  func clear(){
    self.animator.stopAnimation(true);
  };
};
