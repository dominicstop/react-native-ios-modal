//
//  AdaptiveModalConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit

struct AdaptiveModalConfig {
  enum Direction {
    case horizontal;
    case vertical;
    case floating;
  };
  
  let snapPoints: [AdaptiveModalSnapPointConfig];
  let snapDirection: Direction;
  
  let entranceConfig: AdaptiveModalEntranceConfig;
};
