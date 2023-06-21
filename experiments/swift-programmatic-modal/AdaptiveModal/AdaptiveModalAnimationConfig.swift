//
//  AdaptiveModalAnimationConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit

public struct AdaptiveModalAnimationConfig {
  public var modalRotation: CGFloat?;
  
  public var modalScaleX: CGFloat?;
  public var modalScaleY: CGFloat?;

  public var modalTranslateX: CGFloat?;
  public var modalTranslateY: CGFloat?;
  
  public var modalBorderWidth: CGFloat?;
  public var modalBorderColor: UIColor?;
  
  public var modalShadowColor: UIColor?;
  public var modalShadowOffset: CGSize?;
  public var modalShadowOpacity: CGFloat?;
  public var modalShadowRadius: CGFloat?;
  
  public var modalCornerRadius: CGFloat?;
  public var modalMaskedCorners: CACornerMask?;
  
  public var modalOpacity: CGFloat?;
  public var modalBackgroundColor: UIColor?;
  public var modalBackgroundOpacity: CGFloat?;
  
  public var modalBackgroundVisualEffect: UIVisualEffect?;
  public var modalBackgroundVisualEffectOpacity: CGFloat?;
  public var modalBackgroundVisualEffectIntensity: CGFloat?;
  
  public var backgroundColor: UIColor?;
  public var backgroundOpacity: CGFloat?;
  
  public var backgroundVisualEffect: UIVisualEffect?;
  public var backgroundVisualEffectOpacity: CGFloat?;
  public var backgroundVisualEffectIntensity: CGFloat?;
  
  public init(
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
