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
  
  let shouldClampModalInitRotation: Bool;
  let shouldClampModalLastRotation: Bool;
  
  let shouldClampModalInitScaleX: Bool;
  let shouldClampModalLastScaleX: Bool;
  
  let shouldClampModalInitScaleY: Bool;
  let shouldClampModalLastScaleY: Bool;
  
  let shouldClampModalInitTranslateX: Bool;
  let shouldClampModalLastTranslateX: Bool;
  
  let shouldClampModalInitTranslateY: Bool;
  let shouldClampModalLastTranslateY: Bool;
  
  init(
    shouldClampModalInitHeight: Bool = false,
    shouldClampModalLastHeight: Bool = false,
    shouldClampModalInitWidth: Bool = false,
    shouldClampModalLastWidth: Bool = false,
    shouldClampModalInitX: Bool = false,
    shouldClampModalLastX: Bool = false,
    shouldClampModalInitY: Bool = false,
    shouldClampModalLastY: Bool = false,
    shouldClampModalInitRotation: Bool = true,
    shouldClampModalLastRotation: Bool = true,
    shouldClampModalInitScaleX: Bool = true,
    shouldClampModalLastScaleX: Bool = true,
    shouldClampModalInitScaleY: Bool = true,
    shouldClampModalLastScaleY: Bool = true,
    shouldClampModalInitTranslateX: Bool = true,
    shouldClampModalLastTranslateX: Bool = true,
    shouldClampModalInitTranslateY: Bool = true,
    shouldClampModalLastTranslateY: Bool = true
  ) {
    self.shouldClampModalInitHeight = shouldClampModalInitHeight;
    self.shouldClampModalLastHeight = shouldClampModalLastHeight;
    
    self.shouldClampModalInitWidth = shouldClampModalInitWidth;
    self.shouldClampModalLastWidth = shouldClampModalLastWidth;
    
    self.shouldClampModalInitX = shouldClampModalInitX;
    self.shouldClampModalLastX = shouldClampModalLastX;
    
    self.shouldClampModalInitY = shouldClampModalInitY;
    self.shouldClampModalLastY = shouldClampModalLastY;
    
    self.shouldClampModalInitRotation = shouldClampModalInitRotation;
    self.shouldClampModalLastRotation = shouldClampModalLastRotation;
    
    self.shouldClampModalInitScaleX = shouldClampModalInitScaleX;
    self.shouldClampModalLastScaleX = shouldClampModalLastScaleX;
    
    self.shouldClampModalInitScaleY = shouldClampModalInitScaleY;
    self.shouldClampModalLastScaleY = shouldClampModalLastScaleY;
    
    self.shouldClampModalInitTranslateX = shouldClampModalInitTranslateX;
    self.shouldClampModalLastTranslateX = shouldClampModalLastTranslateX;
    
    self.shouldClampModalInitTranslateY = shouldClampModalInitTranslateY;
    self.shouldClampModalLastTranslateY = shouldClampModalLastTranslateY;
  }
};