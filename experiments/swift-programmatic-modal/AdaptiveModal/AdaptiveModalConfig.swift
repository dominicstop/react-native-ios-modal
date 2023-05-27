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
  
  private let _snapAnimationConfig: AdaptiveModalSnapAnimationConfig?;
  
  // let entranceConfig: AdaptiveModalEntranceConfig;
  // let snapSwipeVelocityThreshold: CGFloat = 0;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var snapAnimationConfig: AdaptiveModalSnapAnimationConfig {
    self._snapAnimationConfig ?? .default;
  };
  
  // MARK: - Init
  // ------------
  
  init(
    snapPoints: [AdaptiveModalSnapPointConfig],
    snapDirection: Direction,
    snapAnimationConfig: AdaptiveModalSnapAnimationConfig? = nil
  ) {
    self.snapPoints = snapPoints;
    self.snapDirection = snapDirection;
    self._snapAnimationConfig = snapAnimationConfig;
  };
};
