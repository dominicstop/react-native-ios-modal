//
//  AdaptiveModalPropertyAnimator.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/31/23.
//

import UIKit


struct AdaptiveModalRangePropertyAnimator {
  
  var interpolationRangeStart: AdaptiveModalInterpolationPoint;
  var interpolationRangeEnd: AdaptiveModalInterpolationPoint;
  
  let interpolationOutputKey:
    KeyPath<AdaptiveModalInterpolationPoint, CGFloat>?;
  
  var animator: UIViewPropertyAnimator;
  
  private weak var component: AnyObject?;
  
  private var range: [AdaptiveModalInterpolationPoint] {[
    self.interpolationRangeStart,
    self.interpolationRangeEnd
  ]};
  
  init<T: UIView>(
    interpolationRangeStart: AdaptiveModalInterpolationPoint,
    interpolationRangeEnd: AdaptiveModalInterpolationPoint,
    forComponent component: T,
    interpolationOutputKey:
      KeyPath<AdaptiveModalInterpolationPoint, CGFloat>? = nil,
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
  
  func didRangeChange(
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
    let rangeOutput: [CGFloat] = {
      if let interpolationOutputKey = self.interpolationOutputKey {
        return range.map {
          $0[keyPath: interpolationOutputKey]
        }
      };
      
      return [0, 1];
    }();
  
    let percent = AdaptiveModalManager.interpolate(
      inputValue: inputPercentValue,
      rangeInput: range.map {
        $0.percent
      },
      rangeOutput: rangeOutput
    );
    
    guard let percent = percent else { return };
    self.setFractionComplete(forPercent: percent);
  };
  
  func clear(){
    self.animator.stopAnimation(true);
  };
};
