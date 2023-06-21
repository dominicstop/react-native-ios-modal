//
//  AdaptiveModalConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit

public struct AdaptiveModalConfig {

  // MARK: - Types
  // -------------

  public enum Direction {
    case bottomToTop;
    case topToBottom;
    case leftToRight;
    case rightToLeft;
  };
  
  public enum SnapPercentStrategy {
    case index;
    case position;
  };
  
  // MARK: - Properties
  // ------------------
  
  public let baseSnapPoints: [AdaptiveModalSnapPointConfig];
  public let snapDirection: Direction;
  
  public let snapPercentStrategy: SnapPercentStrategy;
  
  public let snapAnimationConfig: AdaptiveModalSnapAnimationConfig;
  public let interpolationClampingConfig: AdaptiveModalClampingConfig;
  
  public let undershootSnapPoint: AdaptiveModalSnapPointPreset;
  public let overshootSnapPoint: AdaptiveModalSnapPointPreset;
  
  // the first snap point to snap to when the modal is first shown
  public let initialSnapPointIndex: Int;
  
  // let entranceConfig: AdaptiveModalEntranceConfig;
  // let snapSwipeVelocityThreshold: CGFloat = 0;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var snapPoints: [AdaptiveModalSnapPointConfig] {
    .Element.deriveSnapPoints(
      undershootSnapPoint: self.undershootSnapPoint,
      inBetweenSnapPoints: self.baseSnapPoints,
      overshootSnapPoint: self.overshootSnapPoint
    );
  };
  
  public var overshootSnapPointIndex: Int {
    self.snapPoints.count - 1;
  };
  
  /// Defines which axis of the gesture point to use to drive the interpolation
  /// of the modal snap points
  ///
  public var inputValueKeyForPoint: KeyPath<CGPoint, CGFloat> {
    switch self.snapDirection {
      case .topToBottom, .bottomToTop: return \.y;
      case .leftToRight, .rightToLeft: return \.x;
    };
  };
  
  public var inputValueKeyForRect: KeyPath<CGRect, CGFloat> {
    switch self.snapDirection {
      case .bottomToTop: return \.minY;
      case .topToBottom: return \.maxY;
      case .leftToRight: return \.maxX;
      case .rightToLeft: return \.minX;
    };
  };
  
  public var maxInputRangeKeyForRect: KeyPath<CGRect, CGFloat> {
    switch self.snapDirection {
      case .bottomToTop, .topToBottom: return \.height;
      case .leftToRight, .rightToLeft: return \.width;
    };
  };
  
  public var shouldInvertPercent: Bool {
    switch self.snapDirection {
      case .bottomToTop, .rightToLeft: return true;
      default: return false;
    };
  };
  
  // MARK: - Init
  // ------------
  
  public init(
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
  
  public func sortInterpolationSteps<T>(_ array: [T]) -> [T] {
    switch self.snapDirection {
      case .bottomToTop, .leftToRight:
        return array;
        
      case .topToBottom, .rightToLeft:
        return array.reversed();
    };
  };
};
