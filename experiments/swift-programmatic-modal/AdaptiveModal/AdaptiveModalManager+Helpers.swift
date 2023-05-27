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
    
    if shouldClampMin, inputValue <= rangeInput.first! {
      return rangeOutput.first!;
    };
    
    if shouldClampMax, inputValue >= rangeInput.last! {
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
};
