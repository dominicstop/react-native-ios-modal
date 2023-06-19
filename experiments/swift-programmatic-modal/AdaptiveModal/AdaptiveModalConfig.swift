//
//  AdaptiveModalConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit

struct AdaptiveModalConfig {
  enum Direction {
    case bottomToTop;
    case topToBottom;
    case leftToRight;
    case rightToLeft;
  };
  
  enum SnapPercentStrategy {
    case index;
    case position;
  };
  
  // MARK: - Properties
  // ------------------
  
  let baseSnapPoints: [AdaptiveModalSnapPointConfig];
  let snapDirection: Direction;
  
  let snapPercentStrategy: SnapPercentStrategy;
  
  let snapAnimationConfig: AdaptiveModalSnapAnimationConfig;
  let interpolationClampingConfig: AdaptiveModalClampingConfig;
  
  let undershootSnapPoint: AdaptiveModalSnapPointPreset;
  let overshootSnapPoint: AdaptiveModalSnapPointPreset;
  
  // the first snap point to snap to when the modal is first shown
  let initialSnapPointIndex: Int;
  
  // let entranceConfig: AdaptiveModalEntranceConfig;
  // let snapSwipeVelocityThreshold: CGFloat = 0;
  
  var snapPoints: [AdaptiveModalSnapPointConfig] {
    .Element.deriveSnapPoints(
      undershootSnapPoint: self.undershootSnapPoint,
      inBetweenSnapPoints: self.baseSnapPoints,
      overshootSnapPoint: self.overshootSnapPoint
    );
  };
  
  var overshootSnapPointIndex: Int {
    self.snapPoints.count - 1;
  };
  
  /// Defines which axis of the gesture point to use to drive the interpolation
  /// of the modal snap points
  ///
  var inputValueKeyForPoint: KeyPath<CGPoint, CGFloat> {
    switch self.snapDirection {
      case .topToBottom, .bottomToTop: return \.y;
      case .leftToRight, .rightToLeft: return \.x;
    };
  };
  
  var inputValueKeyForRect: KeyPath<CGRect, CGFloat> {
    switch self.snapDirection {
      case .bottomToTop: return \.minY;
      case .topToBottom: return \.maxY;
      case .leftToRight: return \.maxX;
      case .rightToLeft: return \.minX;
    };
  };
  
  var maxInputRangeKeyForRect: KeyPath<CGRect, CGFloat> {
    switch self.snapDirection {
      case .bottomToTop, .topToBottom: return \.height;
      case .leftToRight, .rightToLeft: return \.width;
    };
  };
  
  var shouldInvertPercent: Bool {
    switch self.snapDirection {
      case .bottomToTop, .rightToLeft: return true;
      default: return false;
    };
  };
  
  // MARK: - Init
  // ------------
  
  init(
    snapPoints: [AdaptiveModalSnapPointConfig],
    snapDirection: Direction,
    snapPercentStrategy: SnapPercentStrategy = .position,
    snapAnimationConfig: AdaptiveModalSnapAnimationConfig = .default,
    interpolationClampingConfig: AdaptiveModalClampingConfig = .default,
    initialSnapPointIndex: Int = 1,
    undershootSnapPoint: AdaptiveModalSnapPointPreset? = nil,
    overshootSnapPoint: AdaptiveModalSnapPointPreset? = nil
  ) {
    self.baseSnapPoints = snapPoints;
    
    self.snapDirection = snapDirection;
    self.snapPercentStrategy = snapPercentStrategy;
    
    self.snapAnimationConfig = snapAnimationConfig;
    self.interpolationClampingConfig = interpolationClampingConfig;
    
    self.initialSnapPointIndex = initialSnapPointIndex;
    
    self.undershootSnapPoint = undershootSnapPoint
      ?? .getDefaultUnderShootSnapPoint(forDirection: snapDirection);
    
    self.overshootSnapPoint = overshootSnapPoint
      ?? .getDefaultOvershootSnapPoint(forDirection: snapDirection);
  };
  
  // MARK: - Functions
  // -----------------
  
  func sortInterpolationSteps<T>(_ array: [T]) -> [T] {
    switch self.snapDirection {
      case .bottomToTop, .leftToRight:
        return array;
        
      case .topToBottom, .rightToLeft:
        return array.reversed();
    };
  };
};
