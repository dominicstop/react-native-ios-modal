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
  
  let snapPoints: [AdaptiveModalSnapPointConfig];
  let snapDirection: Direction;
  
  let snapPercentStrategy: SnapPercentStrategy;
  
  // let snapPointInitial: 
  
  let snapAnimationConfig: AdaptiveModalSnapAnimationConfig;
  let interpolationClampingConfig: AdaptiveModalClampingConfig;
  
  let overshootSnapPoint: AdaptiveModalSnapPointPreset;
  
  // let entranceConfig: AdaptiveModalEntranceConfig;
  // let snapSwipeVelocityThreshold: CGFloat = 0;
  
  var snapPointLastIndex: Int {
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
  
  var maxInputRangeKeyForRect: KeyPath<CGRect, CGFloat> {
    switch self.snapDirection {
      case .bottomToTop, .topToBottom: return \.height;
      case .leftToRight, .rightToLeft: return \.width;
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
    overshootSnapPoint: AdaptiveModalSnapPointPreset? = nil
  ) {
    self.snapPoints = snapPoints;
    self.snapDirection = snapDirection;
    self.snapPercentStrategy = snapPercentStrategy;
    
    self.snapAnimationConfig = snapAnimationConfig;
    self.interpolationClampingConfig = interpolationClampingConfig;
    
    self.overshootSnapPoint = overshootSnapPoint
      ?? .getDefault(forDirection: snapDirection);
  };
  
  // MARK: - Functions
  // -----------------
  
  func sortInterpolationSteps<T>(_ array: [T]) -> [T] {
    switch self.snapDirection {
      case .bottomToTop, .rightToLeft:
        return array;
        
      case .topToBottom, .leftToRight:
        return array.reversed();
    };
  };
};
