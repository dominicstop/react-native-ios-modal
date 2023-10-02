//
//  RNIComputableValue.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/19/23.
//

import UIKit

public struct RNIComputableValue {
  
  // MARK: - Properties
  // ------------------
  
  public let mode: RNIComputableValueMode;
  
  public let offset: RNIComputableOffset?;
  
  public let minValue: CGFloat?;
  public let maxValue: CGFloat?;
  
  
  // MARK: - Internal Functions
  // --------------------------
  
  func valueWithOffsets(forValue value: CGFloat) -> CGFloat {
    return self.offset?.compute(withValue: value) ?? value;
  };
  
  func valueWithClamp(forValue value: CGFloat) -> CGFloat {
    return value.clamped(
      min: self.minValue,
      max: self.maxValue
    );
  };

  // MARK: - Functions
  // -----------------
    
  public func computeRaw(
    withTargetValue targetValue: CGFloat,
    currentValue: CGFloat
  ) -> CGFloat {
    switch self.mode {
      case .current:
        return currentValue;
        
      case .stretch:
        return targetValue;
        
      case let .constant(constantValue):
        return constantValue;
        
      case let .percent(percentValue):
        return percentValue * targetValue;
    };
  };
    
  public func compute(
    withTargetValue targetValue: CGFloat,
    currentValue: CGFloat
  ) -> CGFloat {
    let rawValue = self.computeRaw(
      withTargetValue: targetValue,
      currentValue: currentValue
    );
    
    let clampedValue = self.valueWithClamp(forValue: rawValue);
    return self.valueWithOffsets(forValue: clampedValue);
  };
  
  public init(
    mode: RNIComputableValueMode,
    offset: RNIComputableOffset? = nil,
    minValue: CGFloat? = nil,
    maxValue: CGFloat? = nil
  ) {
    self.mode = mode;
    self.offset = offset;
    self.minValue = minValue;
    self.maxValue = maxValue;
  };
};

extension RNIComputableValue {
  public init?(fromDict dict: NSDictionary){
    guard let mode = RNIComputableValueMode(fromDict: dict)
    else { return nil };
    
    self.mode = mode;
    
    self.offset = {
      guard let offsetRaw = dict["offset"] as? NSDictionary,
            let offset = RNIComputableOffset(fromDict: offsetRaw)
      else { return nil };
      
      return offset;
    }();
    
    self.minValue =
      Self.getDoubleValue(forDict: dict, withKey: "minValue");
      
    self.maxValue =
      Self.getDoubleValue(forDict: dict, withKey: "maxValue");
  };
  
  
  
  static private func getDoubleValue(
    forDict dict: NSDictionary,
    withKey key: String
  ) -> CGFloat? {
    guard let number = dict[key] as? NSNumber else { return nil };
    return number.doubleValue;
  };
};
