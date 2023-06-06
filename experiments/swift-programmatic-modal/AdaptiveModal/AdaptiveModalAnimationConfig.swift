//
//  AdaptiveModalAnimationConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit


struct AdaptiveModalAnimationConfig {

  struct CornerRadius: Equatable {
    static let `default`: Self = .init(uniformRadius: 0);
  
    let topLeftRadius    : CGFloat;
    let topRightRadius   : CGFloat;
    let bottomLeftRadius : CGFloat;
    let bottomRightRadius: CGFloat;
    
    init(
      topLeftRadius    : CGFloat,
      topRightRadius   : CGFloat,
      bottomLeftRadius : CGFloat,
      bottomRightRadius: CGFloat
    ) {
      self.topLeftRadius     = topLeftRadius;
      self.topRightRadius    = topRightRadius;
      self.bottomLeftRadius  = bottomLeftRadius;
      self.bottomRightRadius = bottomRightRadius;
    };
    
    init(uniformRadius: CGFloat) {
      self.topLeftRadius     = uniformRadius;
      self.topRightRadius    = uniformRadius;
      self.bottomLeftRadius  = uniformRadius;
      self.bottomRightRadius = uniformRadius;
    };
  };
  
  let modalRotation: CGFloat?;
  
  let modalScaleX: CGFloat?;
  let modalScaleY: CGFloat?;

  let modalTranslateX: CGFloat?;
  let modalTranslateY: CGFloat?;
  
  let modalOpacity: CGFloat?;
  let modalBackgroundColor: UIColor?;
  let modalBackgroundOpacity: CGFloat?;
  
  let modalCornerRadius: CornerRadius?;
  
  let modalBackgroundVisualEffect: UIVisualEffect?;
  let modalBackgroundVisualEffectOpacity: CGFloat?;
  let modalBackgroundVisualEffectIntensity: CGFloat?;
  
  let backgroundColor: UIColor?;
  let backgroundOpacity: CGFloat?;
  
  let backgroundVisualEffect: UIVisualEffect?;
  let backgroundVisualEffectOpacity: CGFloat?;
  let backgroundVisualEffectIntensity: CGFloat?;
  
  init(
     modalRotation: CGFloat? = nil,
     modalScaleX: CGFloat? = nil,
     modalScaleY: CGFloat? = nil,
     modalTranslateX: CGFloat? = nil,
     modalTranslateY: CGFloat? = nil,
     modalOpacity: CGFloat? = nil,
     modalBackgroundColor: UIColor? = nil,
     modalBackgroundOpacity: CGFloat? = nil,
     modalCornerRadius: CornerRadius? = nil,
     modalBackgroundVisualEffect: UIVisualEffect? = nil,
     modalBackgroundVisualEffectOpacity: CGFloat? = nil,
     modalBackgroundVisualEffectIntensity: CGFloat? = nil,
     backgroundColor: UIColor? = nil,
     backgroundOpacity: CGFloat? = nil,
     backgroundVisualEffect: UIVisualEffect? = nil,
     backgroundVisualEffectOpacity: CGFloat? = nil,
     backgroundVisualEffectIntensity: CGFloat? = nil
  ) {
    self.modalRotation = modalRotation;
    
    self.modalScaleX = modalScaleX;
    self.modalScaleY = modalScaleY;
    
    self.modalTranslateX = modalTranslateX;
    self.modalTranslateY = modalTranslateY;
    
    self.modalOpacity = modalOpacity;
    self.modalBackgroundColor = modalBackgroundColor;
    self.modalBackgroundOpacity = modalBackgroundOpacity;
    
    self.modalCornerRadius = modalCornerRadius;
    
    self.modalBackgroundVisualEffect = modalBackgroundVisualEffect;
    self.modalBackgroundVisualEffectOpacity = modalBackgroundVisualEffectOpacity;
    self.modalBackgroundVisualEffectIntensity = modalBackgroundVisualEffectIntensity;
    
    self.backgroundColor = backgroundColor;
    self.backgroundOpacity = backgroundOpacity;
    
    self.backgroundVisualEffect = backgroundVisualEffect;
    self.backgroundVisualEffectOpacity = backgroundVisualEffectOpacity;
    self.backgroundVisualEffectIntensity = backgroundVisualEffectIntensity;
  };
};
