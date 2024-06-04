//
//  AdaptiveModalSnapAnimationConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/27/23.
//

import UIKit

public struct AdaptiveModalSnapAnimationConfig {
  public static let `default`: Self = .init(
    springDampingRatio: 0.9,
    springAnimationSettlingTime: 0.4,
    maxGestureVelocity: 15
  );

  public let springDampingRatio: CGFloat;
  public let springAnimationSettlingTime: CGFloat;
  public let maxGestureVelocity: CGFloat;
};
