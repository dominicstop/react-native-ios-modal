//
//  AdaptiveModalClampingConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/28/23.
//

import Foundation

public struct AdaptiveModalClampingConfig {
  public static let `default`: Self = .init();

  public let shouldClampModalInitHeight: Bool;
  public let shouldClampModalLastHeight: Bool;
  
  public let shouldClampModalInitWidth: Bool;
  public let shouldClampModalLastWidth: Bool;
  
  public let shouldClampModalInitX: Bool;
  public let shouldClampModalLastX: Bool;
  
  public let shouldClampModalInitY: Bool;
  public let shouldClampModalLastY: Bool;
  
  public let shouldClampModalInitRotation: Bool;
  public let shouldClampModalLastRotation: Bool;
  
  public let shouldClampModalInitScaleX: Bool;
  public let shouldClampModalLastScaleX: Bool;
  
  public let shouldClampModalInitScaleY: Bool;
  public let shouldClampModalLastScaleY: Bool;
  
  public let shouldClampModalInitTranslateX: Bool;
  public let shouldClampModalLastTranslateX: Bool;
  
  public let shouldClampModalInitTranslateY: Bool;
  public let shouldClampModalLastTranslateY: Bool;
  
  public init(
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
