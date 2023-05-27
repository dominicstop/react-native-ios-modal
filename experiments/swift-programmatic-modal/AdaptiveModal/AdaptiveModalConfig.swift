//
//  AdaptiveModalConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit

enum AdaptiveModalSnapAnimationConfig {

};

struct AdaptiveModalConfig {
  enum Direction {
    case horizontal;
    case vertical;
  };
  
  let snapPoints: [AdaptiveModalSnapPointConfig];
  let snapDirection: Direction;
  
  // let entranceConfig: AdaptiveModalEntranceConfig;
  let snapSwipeVelocityThreshold: CGFloat = 0;
  // let snappingAnimationConfig enum
  
  init(
    snapPoints: [AdaptiveModalSnapPointConfig],
    snapDirection: Direction
  ) {
    self.snapPoints = snapPoints
    self.snapDirection = snapDirection
  }
};
