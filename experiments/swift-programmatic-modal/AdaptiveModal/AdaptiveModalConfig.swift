//
//  AdaptiveModalConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit

struct AdaptiveModalConfig {
  enum Direction {
    case horizontal;
    case vertical;
  };
  
  // MARK: - Properties
  // ------------------
  
  let snapPoints: [AdaptiveModalSnapPointConfig];
  let snapDirection: Direction;
  
  // let snapPointInitial: 
  
  let snapAnimationConfig: AdaptiveModalSnapAnimationConfig;
  let interpolationClampingConfig: AdaptiveModalClampingConfig;
  
  // let entranceConfig: AdaptiveModalEntranceConfig;
  // let snapSwipeVelocityThreshold: CGFloat = 0;
  
  // MARK: - Init
  // ------------
  
  init(
    snapPoints: [AdaptiveModalSnapPointConfig],
    snapDirection: Direction,
    snapAnimationConfig: AdaptiveModalSnapAnimationConfig = .default,
    interpolationClampingConfig: AdaptiveModalClampingConfig = .default
  ) {
    self.snapPoints = snapPoints;
    self.snapDirection = snapDirection;
    
    self.snapAnimationConfig = snapAnimationConfig;
    self.interpolationClampingConfig = interpolationClampingConfig;
  };
};
