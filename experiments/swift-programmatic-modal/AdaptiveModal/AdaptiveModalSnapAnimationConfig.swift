//
//  AdaptiveModalSnapAnimationConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/27/23.
//

import UIKit

struct AdaptiveModalSnapAnimationConfig {
  static let `default`: Self = .init(
    springDampingRatio: 0.9,
    springAnimationSettlingTime: 0.4,
    maxGestureVelocity: 15
  );

  let springDampingRatio: CGFloat;
  let springAnimationSettlingTime: CGFloat;
  let maxGestureVelocity: CGFloat;
};
