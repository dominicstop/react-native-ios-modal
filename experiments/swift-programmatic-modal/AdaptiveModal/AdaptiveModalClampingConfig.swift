//
//  AdaptiveModalClampingConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/28/23.
//

import Foundation

struct AdaptiveModalClampingConfig {
  static let `default`: Self = .init();

  let shouldClampModalInitHeight: Bool;
  let shouldClampModalLastHeight: Bool;
  
  let shouldClampModalInitWidth: Bool;
  let shouldClampModalLastWidth: Bool;
  
  let shouldClampModalInitX: Bool;
  let shouldClampModalLastX: Bool;
  
  let shouldClampModalInitY: Bool;
  let shouldClampModalLastY: Bool;
  
  init(
    shouldClampModalInitHeight: Bool = false,
    shouldClampModalLastHeight: Bool = false,
    shouldClampModalInitWidth: Bool = false,
    shouldClampModalLastWidth: Bool = false,
    shouldClampModalInitX: Bool = false,
    shouldClampModalLastX: Bool = false,
    shouldClampModalInitY: Bool = false,
    shouldClampModalLastY: Bool = false
  ) {
    self.shouldClampModalInitHeight = shouldClampModalInitHeight;
    self.shouldClampModalLastHeight = shouldClampModalLastHeight;
    self.shouldClampModalInitWidth = shouldClampModalInitWidth;
    self.shouldClampModalLastWidth = shouldClampModalLastWidth;
    self.shouldClampModalInitX = shouldClampModalInitX;
    self.shouldClampModalLastX = shouldClampModalLastX;
    self.shouldClampModalInitY = shouldClampModalInitY;
    self.shouldClampModalLastY = shouldClampModalLastY;
  }
};
