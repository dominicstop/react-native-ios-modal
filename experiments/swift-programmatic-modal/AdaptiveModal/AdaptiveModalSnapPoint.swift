//
//  AdaptiveModalSnapPoint.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit

struct AdaptiveModalSnapPointConfig {

  // MARK: Types
  // -----------

  enum SnapPointKey: Equatable {
    case undershootPoint, overshootPoint, unspecified;
    case string(_ stringKey: String);
    case index(_ indexKey: Int);
  };
  
  // MARK: Properties
  // ----------------

  let key: SnapPointKey;
  
  let snapPoint: RNILayout;
  let animationKeyframe: AdaptiveModalAnimationConfig?;
  
  // MARK: Init
  // ----------
  
  init(
    key: SnapPointKey = .unspecified,
    snapPoint: RNILayout,
    animationKeyframe: AdaptiveModalAnimationConfig? = nil
  ) {
    self.key = key;
    self.snapPoint = snapPoint;
    self.animationKeyframe = animationKeyframe;
  };
  
  init(
    key: SnapPointKey = .unspecified,
    fromSnapPointPreset snapPointPreset: AdaptiveModalSnapPointPreset,
    fromBaseLayoutConfig baseLayoutConfig: RNILayout
  ) {
    let snapPointLayoutPreset = snapPointPreset.layoutPreset;
    
    let snapPointLayout = snapPointLayoutPreset.getLayoutConfig(
      fromBaseLayoutConfig: baseLayoutConfig
    );
    
    self.key = key;
    self.snapPoint = snapPointLayout;
    self.animationKeyframe = snapPointPreset.animationKeyframe;
  };
  
  init(
    fromBase base: Self,
    newKey: SnapPointKey,
    newSnapPoint: RNILayout? = nil,
    newAnimationKeyframe: AdaptiveModalAnimationConfig? = nil
  ){
    self.snapPoint = newSnapPoint ?? base.snapPoint;
    self.animationKeyframe = newAnimationKeyframe ?? base.animationKeyframe;
    
    self.key = base.key == .unspecified
      ? newKey
      : base.key;
  };
};

// MARK: Helpers
// -------------

extension AdaptiveModalSnapPointConfig {

  static func deriveSnapPoints(
    undershootSnapPoint: AdaptiveModalSnapPointPreset,
    inBetweenSnapPoints: [AdaptiveModalSnapPointConfig],
    overshootSnapPoint: AdaptiveModalSnapPointPreset
  ) -> [AdaptiveModalSnapPointConfig] {

    var items: [AdaptiveModalSnapPointConfig] = [];
    
    if let snapPointFirst = inBetweenSnapPoints.first {
      let initialSnapPointConfig = AdaptiveModalSnapPointConfig(
        key: .undershootPoint,
        fromSnapPointPreset: undershootSnapPoint,
        fromBaseLayoutConfig: snapPointFirst.snapPoint
      );
      
      items.append(initialSnapPointConfig);
    };
    
    items += inBetweenSnapPoints.map {
      .init(fromBase: $0, newKey: .index(items.count));
    };
    
    if let snapPointLast = inBetweenSnapPoints.last {
      let overshootSnapPointConfig = AdaptiveModalSnapPointConfig(
        key: .overshootPoint,
        fromSnapPointPreset: overshootSnapPoint,
        fromBaseLayoutConfig: snapPointLast.snapPoint
      );
      
      items.append(overshootSnapPointConfig);
    };
    
    return items;
  };
};
