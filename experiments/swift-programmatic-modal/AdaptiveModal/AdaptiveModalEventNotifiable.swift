//
//  AdaptiveModalEventNotifiable.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/4/23.
//

import Foundation


public protocol AdaptiveModalEventNotifiable: AnyObject {
  
  func notifyOnModalWillSnap(
    prevSnapPointIndex: Int?,
    nextSnapPointIndex: Int,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    interpolationPoint: AdaptiveModalInterpolationPoint
  );
  
  func notifyOnModalDidSnap(
    prevSnapPointIndex: Int?,
    currentSnapPointIndex: Int,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    interpolationPoint: AdaptiveModalInterpolationPoint
  );
};
