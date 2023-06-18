//
//  RNILayoutValue.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/8/23.
//

import UIKit

public struct RNILayoutValue {

  // MARK: - Types
  // -------------

  public enum Axis {
    case horizontal, vertical;
  };
  
  // MARK: - Properties
  // ------------------
  
  public let mode: RNILayoutValueMode;
  
  public let offsetValue: RNILayoutValueMode?;
  public let offsetOperation: RNIComputableOffset.OffsetOperation?;

  public let minValue: RNILayoutValueMode?;
  public let maxValue: RNILayoutValueMode?;
  
  // MARK: - Init
  // ------------
  
  init(
    mode: RNILayoutValueMode,
    offsetValue: RNILayoutValueMode? = nil,
    offsetOperation: RNIComputableOffset.OffsetOperation? = nil,
    minValue: RNILayoutValueMode? = nil,
    maxValue: RNILayoutValueMode? = nil
  ) {
    self.mode = mode;
    
    self.offsetValue = offsetValue;
    self.offsetOperation = offsetOperation;
    self.minValue = minValue;
    self.maxValue = maxValue;
  };
  
  // MARK: - Intermediate Functions
  // ------------------------------
  
  public func applyOffsets(
    usingLayoutValueContext context: RNILayoutValueContext,
    toValue value: CGFloat
  ) -> CGFloat? {
    guard let offsetValue = self.offsetValue else { return value };
    
    let computedOffsetValue = offsetValue.compute(
      usingLayoutValueContext: context,
      preferredSizeKey: nil
    );
    
    guard let computedOffsetValue = computedOffsetValue else { return value };
    
    let computableOffset = RNIComputableOffset(
      offset: computedOffsetValue,
      offsetOperation: self.offsetOperation ?? .add
    );
    
    return computableOffset.compute(withValue: value, isValueOnRHS: true);
  };
  
  public func clampValue(
    usingLayoutValueContext context: RNILayoutValueContext,
    forValue value: CGFloat
  ) -> CGFloat? {
    let computedMinValue = self.minValue?.compute(
      usingLayoutValueContext: context,
      preferredSizeKey: nil
    );
      
    let computedMaxValue = self.minValue?.compute(
      usingLayoutValueContext: context,
      preferredSizeKey: nil
    );
 
    let clamped = value.clamped(min: computedMinValue, max: computedMaxValue);
    
    return clamped;
  };
  
  public func computeRawValue(
    usingLayoutValueContext context: RNILayoutValueContext,
    preferredSizeKey: KeyPath<CGSize, CGFloat>?
  ) -> CGFloat? {
    return self.mode.compute(
      usingLayoutValueContext: context,
      preferredSizeKey: preferredSizeKey
    );
  };
  
  // MARK: - User-Invoked Functions
  // ------------------------------
  
  public func computeValue(
    usingLayoutValueContext context: RNILayoutValueContext,
    preferredSizeKey: KeyPath<CGSize, CGFloat>?
  ) -> CGFloat? {
  
    let computedValueRaw = self.computeRawValue(
      usingLayoutValueContext: context,
      preferredSizeKey: preferredSizeKey
    );
    
    let computedValueWithOffsets = self.applyOffsets(
      usingLayoutValueContext: context,
      toValue: computedValueRaw ?? 0
    );
    
    return self.clampValue(
      usingLayoutValueContext: context,
      forValue: computedValueWithOffsets ?? 0
    );
  };
};
