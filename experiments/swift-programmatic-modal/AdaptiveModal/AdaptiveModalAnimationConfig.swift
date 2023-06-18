//
//  AdaptiveModalAnimationConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit


struct AdaptiveModalAnimationConfig {
  var modalRotation: CGFloat?;
  
  var modalScaleX: CGFloat?;
  var modalScaleY: CGFloat?;

  var modalTranslateX: CGFloat?;
  var modalTranslateY: CGFloat?;
  
  var modalBorderWidth: CGFloat?;
  var modalBorderColor: UIColor?;
  
  var modalShadowColor: UIColor?;
  var modalShadowOffset: CGSize?;
  var modalShadowOpacity: CGFloat?;
  var modalShadowRadius: CGFloat?;
  
  var modalCornerRadius: CGFloat?;
  var modalMaskedCorners: CACornerMask?;
  
  var modalOpacity: CGFloat?;
  var modalBackgroundColor: UIColor?;
  var modalBackgroundOpacity: CGFloat?;
  
  var modalBackgroundVisualEffect: UIVisualEffect?;
  var modalBackgroundVisualEffectOpacity: CGFloat?;
  var modalBackgroundVisualEffectIntensity: CGFloat?;
  
  var backgroundColor: UIColor?;
  var backgroundOpacity: CGFloat?;
  
  var backgroundVisualEffect: UIVisualEffect?;
  var backgroundVisualEffectOpacity: CGFloat?;
  var backgroundVisualEffectIntensity: CGFloat?;
  
  init(
     modalRotation: CGFloat? = nil,
     modalScaleX: CGFloat? = nil,
     modalScaleY: CGFloat? = nil,
     modalTranslateX: CGFloat? = nil,
     modalTranslateY: CGFloat? = nil,
     modalBorderWidth: CGFloat? = nil,
     modalBorderColor: UIColor? = nil,
     modalShadowColor: UIColor? = nil,
     modalShadowOffset: CGSize? = nil,
     modalShadowOpacity: CGFloat? = nil,
     modalShadowRadius: CGFloat? = nil,
     modalCornerRadius: CGFloat? = nil,
     modalMaskedCorners: CACornerMask? = nil,
     modalOpacity: CGFloat? = nil,
     modalBackgroundColor: UIColor? = nil,
     modalBackgroundOpacity: CGFloat? = nil,
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
    
    self.modalBorderWidth = modalBorderWidth;
    self.modalBorderColor = modalBorderColor;
    
    self.modalShadowColor = modalShadowColor;
    self.modalShadowOffset = modalShadowOffset;
    self.modalShadowOpacity = modalShadowOpacity;
    self.modalShadowRadius = modalShadowRadius;
    
    self.modalCornerRadius = modalCornerRadius;
    self.modalMaskedCorners = modalMaskedCorners;
    
    self.modalOpacity = modalOpacity;
    self.modalBackgroundColor = modalBackgroundColor;
    self.modalBackgroundOpacity = modalBackgroundOpacity;
    
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
