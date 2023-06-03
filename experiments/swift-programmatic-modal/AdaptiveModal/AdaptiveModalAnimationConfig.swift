//
//  AdaptiveModalAnimationConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit


struct AdaptiveModalAnimationConfig {
  let modalRotation: CGFloat?;
  
  let modalScaleX: CGFloat?;
  let modalScaleY: CGFloat?;

  let modalTranslateX: CGFloat?;
  let modalTranslateY: CGFloat?;
  
  let modalBackgroundColor: UIColor?;
  let modalBackgroundOpacity: CGFloat?;
  
  let modalCornerRadius: CGFloat?;
  let modalMaskedCorners: CACornerMask?;
  
  let modalBackgroundVisualEffect: UIVisualEffect?;
  let modalBackgroundVisualEffectIntensity: CGFloat?;
  
  let backgroundColor: UIColor?;
  let backgroundOpacity: CGFloat?;
  
  let backgroundVisualEffect: UIVisualEffect?;
  let backgroundVisualEffectIntensity: CGFloat?;
  
  init(
     modalRotation: CGFloat? = nil,
     modalScaleX: CGFloat? = nil,
     modalScaleY: CGFloat? = nil,
     modalTranslateX: CGFloat? = nil,
     modalTranslateY: CGFloat? = nil,
     modalBackgroundColor: UIColor? = nil,
     modalBackgroundOpacity: CGFloat? = nil,
     modalCornerRadius: CGFloat? = nil,
     modalMaskedCorners: CACornerMask? = nil,
     modalBackgroundVisualEffect: UIVisualEffect? = nil,
     modalBackgroundVisualEffectIntensity: CGFloat? = nil,
     backgroundColor: UIColor? = nil,
     backgroundOpacity: CGFloat? = nil,
     backgroundVisualEffect: UIVisualEffect? = nil,
     backgroundVisualEffectIntensity: CGFloat? = nil
  ) {
    self.modalRotation = modalRotation;
    
    self.modalScaleX = modalScaleX;
    self.modalScaleY = modalScaleY;
    
    self.modalTranslateX = modalTranslateX;
    self.modalTranslateY = modalTranslateY;
    
    self.modalBackgroundColor = modalBackgroundColor;
    self.modalBackgroundOpacity = modalBackgroundOpacity;
    
    self.modalCornerRadius = modalCornerRadius;
    self.modalMaskedCorners = modalMaskedCorners;
    
    self.modalBackgroundVisualEffect = modalBackgroundVisualEffect;
    self.modalBackgroundVisualEffectIntensity = modalBackgroundVisualEffectIntensity;
    
    self.backgroundColor = backgroundColor;
    self.backgroundOpacity = backgroundOpacity;
    
    self.backgroundVisualEffect = backgroundVisualEffect;
    self.backgroundVisualEffectIntensity = backgroundVisualEffectIntensity;
  };
};
