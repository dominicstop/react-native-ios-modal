//
//  AdaptiveModalManager+Helpers.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/27/23.
//

import UIKit

extension AdaptiveModalManager {

  static func interpolate(
    inputValue    : CGFloat,
    rangeInput    : [CGFloat],
    rangeOutput   : [CGFloat],
    shouldClampMin: Bool = false,
    shouldClampMax: Bool = false
  ) -> CGFloat? {
  
    guard rangeInput.count == rangeOutput.count,
          rangeInput.count >= 2
    else { return nil };
    
    if shouldClampMin, inputValue < rangeInput.first! {
      return rangeOutput.first!;
    };
    
    if shouldClampMax, inputValue > rangeInput.last! {
      return rangeOutput.last!;
    };
    
    // A - Extrapolate Left
    if inputValue < rangeInput.first! {
       
      let rangeInputStart  = rangeInput.first!;
      let rangeOutputStart = rangeOutput.first!;
       
      let delta1 = rangeInputStart - inputValue;
      let percent = delta1 / rangeInputStart;
      
      // extrapolated "range output end"
      let rangeOutputEnd = rangeOutputStart - (rangeOutput[1] - rangeOutputStart);
      
      let interpolatedValue = RNIAnimator.EasingFunctions.lerp(
        valueStart: rangeOutputEnd,
        valueEnd  : rangeOutputStart,
        percent   : percent
      );
      
      let delta2 = interpolatedValue - rangeOutputEnd;
      return rangeOutputStart - delta2;
    };
    
    let (rangeStartIndex, rangeEndIndex): (Int, Int) = {
      let rangeInputEnumerated = rangeInput.enumerated();
      
      let match = rangeInputEnumerated.first {
        guard let nextValue = rangeInput[safeIndex: $0.offset + 1]
        else { return false };
        
        return inputValue >= $0.element && inputValue < nextValue;
      };
      
      // B - Interpolate Between
      if let match = match {
        let rangeStartIndex = match.offset;
        return (rangeStartIndex, rangeStartIndex + 1);
      };
        
      let lastIndex         = rangeInput.count - 1;
      let secondToLastIndex = rangeInput.count - 2;
      
      // C - Extrapolate Right
      return (secondToLastIndex, lastIndex);
    }();
    
    guard let rangeInputStart  = rangeInput [safeIndex: rangeStartIndex],
          let rangeInputEnd    = rangeInput [safeIndex: rangeEndIndex  ],
          let rangeOutputStart = rangeOutput[safeIndex: rangeStartIndex],
          let rangeOutputEnd   = rangeOutput[safeIndex: rangeEndIndex  ]
    else { return nil };
    
    let inputValueAdj    = inputValue    - rangeInputStart;
    let rangeInputEndAdj = rangeInputEnd - rangeInputStart;

    let progress = inputValueAdj / rangeInputEndAdj;
          
    return RNIAnimator.EasingFunctions.lerp(
      valueStart: rangeOutputStart,
      valueEnd  : rangeOutputEnd,
      percent   : progress
    );
  };
  
  static func interpolateColor(
    inputValue    : CGFloat,
    rangeInput    : [CGFloat],
    rangeOutput   : [UIColor],
    shouldClampMin: Bool = false,
    shouldClampMax: Bool = false
  ) -> UIColor? {
    var rangeR: [CGFloat] = [];
    var rangeG: [CGFloat] = [];
    var rangeB: [CGFloat] = [];
    var rangeA: [CGFloat] = [];
    
    for color in rangeOutput {
      let rgba = color.rgba;
      
      rangeR.append(rgba.r);
      rangeG.append(rgba.g);
      rangeB.append(rgba.b);
      rangeA.append(rgba.a);
    };
    
  
    let nextR = Self.interpolate(
      inputValue: inputValue,
      rangeInput: rangeInput,
      rangeOutput: rangeR,
      shouldClampMin: shouldClampMin,
      shouldClampMax: shouldClampMax
    );
    
    let nextG = Self.interpolate(
      inputValue: inputValue,
      rangeInput: rangeInput,
      rangeOutput: rangeG,
      shouldClampMin: shouldClampMin,
      shouldClampMax: shouldClampMax
    );
    
    let nextB = Self.interpolate(
      inputValue: inputValue,
      rangeInput: rangeInput,
      rangeOutput: rangeB,
      shouldClampMin: shouldClampMin,
      shouldClampMax: shouldClampMax
    );
    
    let nextA = Self.interpolate(
      inputValue: inputValue,
      rangeInput: rangeInput,
      rangeOutput: rangeA,
      shouldClampMin: shouldClampMin,
      shouldClampMax: shouldClampMax
    );
    
    guard let nextR = nextR,
          let nextG = nextG,
          let nextB = nextB,
          let nextA = nextA
    else { return nil };
    
    return UIColor(
      red  : nextR,
      green: nextG,
      blue : nextB,
      alpha: nextA
    );
  };
  
  static func computeFinalPosition(
    position: CGFloat,
    initialVelocity: CGFloat,
    decelerationRate: CGFloat = UIScrollView.DecelerationRate.normal.rawValue
  ) -> CGFloat {
    let pointPerSecond = abs(initialVelocity) / 1000.0;
    let accelerationRate = 1 - decelerationRate;
    
    let displacement = (pointPerSecond * decelerationRate) / accelerationRate;
    
    return initialVelocity > 0
      ? position + displacement
      : position - displacement;
  };
  
  static func invertPercent(_ percent: CGFloat) -> CGFloat {
    let offset = percent > 1 ? abs(percent - 1) : 0;
    return 1 - percent + offset;
  };
  
  static func setProperty<O: AnyObject, T>(
    forObject object: O?,
    forPropertyKey propertyKey: WritableKeyPath<O, T>,
    withValue value: T?
  ) {
    guard var object = object,
          let value = value
    else { return };
    
    object[keyPath: propertyKey] = value;
  };
  
  static func setProperty<O, T>(
    for valueType: inout O?,
    forPropertyKey propertyKey: WritableKeyPath<O, T>,
    withValue newValue: T?
  ) {
    guard var valueType = valueType,
          let newValue = newValue
    else { return };
    
    valueType[keyPath: propertyKey] = newValue;
  };
};
