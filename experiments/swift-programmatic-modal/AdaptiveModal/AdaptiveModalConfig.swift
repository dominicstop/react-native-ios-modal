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
  
  // MARK: - Properties
  // ------------------
  
  let snapPoints: [AdaptiveModalSnapPointConfig];
  let snapDirection: Direction;
  
  // let snapPointInitial: 
  
  let snapAnimationConfig: AdaptiveModalSnapAnimationConfig;
  let interpolationClampingConfig: AdaptiveModalClampingConfig;
  
  let overshootSnapPoint: AdaptiveModalSnapPointPreset;
  
  // let entranceConfig: AdaptiveModalEntranceConfig;
  // let snapSwipeVelocityThreshold: CGFloat = 0;
  
  var snapPointLastIndex: Int {
    self.snapPoints.count - 1;
  };
  
  // MARK: - Init
  // ------------
  
  init(
    snapPoints: [AdaptiveModalSnapPointConfig],
    snapDirection: Direction,
    snapAnimationConfig: AdaptiveModalSnapAnimationConfig = .default,
    interpolationClampingConfig: AdaptiveModalClampingConfig = .default,
    overshootSnapPoint: AdaptiveModalSnapPointPreset? = nil
  ) {
    self.snapPoints = snapPoints;
    self.snapDirection = snapDirection;
    
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
        return array.reversed();
        
      case .topToBottom, .leftToRight:
        return array;
    };
  };
};
