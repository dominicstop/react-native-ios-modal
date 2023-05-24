//
//  AdaptiveModalInitialSnapPoint.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit

enum AdaptiveModalSnapPointPreset {
  case offscreenBottom, offscreenTop;
  case offscreenLeft, offscreenRight;
  case center;
  
  case layoutConfig(_ config: RNILayout);
};
