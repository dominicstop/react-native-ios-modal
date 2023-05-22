//
//  FloatingPoint+Helpers.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/19/23.
//

import UIKit

extension FloatingPoint {
  public func clamped(min lowerBound: Self?, max upperBound: Self?) -> Self {
    var clampedValue = self;
    
    if let upperBound = upperBound {
      clampedValue = min(clampedValue, upperBound);
    };
    
    if let lowerBound = lowerBound {
      clampedValue = max(clampedValue, lowerBound);
    };
    
    return clampedValue;
  };
};
