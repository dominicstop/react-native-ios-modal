//
//  AdaptiveModalAnimationConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit


struct AdaptiveModalInterpolationPoint {

  static func compute(
    modalConfig: AdaptiveModalConfig,
    withTargetRect targetRect: CGRect,
    currentSize: CGSize
  ) -> [Self] {
    var items: [Self] = [];
    
    for snapConfig in modalConfig.snapPoints {
      let keyframe = snapConfig.animationKeyframe;
      let prevKeyframe = items.last;
      
      items.append(
        Self.init(
          withTargetRect : targetRect,
          currentSize    : currentSize,
          snapPointConfig: snapConfig,
          
          modalRadiusTopLeft: keyframe?.modalRadiusTopLeft
            ?? prevKeyframe?.modalRadiusTopLeft ?? 0,
            
          modalRadiusTopRight: keyframe?.modalRadiusTopRight
            ?? prevKeyframe?.modalRadiusTopRight ?? 0,
            
          modalRadiusBottomLeft: keyframe?.modalRadiusBottomLeft
            ?? prevKeyframe?.modalRadiusBottomLeft ?? 0,
            
          modalRadiusBottomRight: keyframe?.modalRadiusBottomRight
            ?? prevKeyframe?.modalRadiusBottomRight ?? 0
        )
      );
    };
    
    return items;
  };

  /// The computed frames of the modal based on the snap points
  let computedRect: CGRect;
  
  let modalRadiusTopLeft: CGFloat;
  let modalRadiusTopRight: CGFloat;
  let modalRadiusBottomLeft: CGFloat;
  let modalRadiusBottomRight: CGFloat;
  
  init(
    withTargetRect targetRect: CGRect,
    currentSize: CGSize,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    modalRadiusTopLeft: CGFloat,
    modalRadiusTopRight: CGFloat,
    modalRadiusBottomLeft: CGFloat,
    modalRadiusBottomRight: CGFloat
  ) {
    self.computedRect = snapPointConfig.snapPoint.computeRect(
      withTargetRect: targetRect,
      currentSize: currentSize
    );
    
    self.modalRadiusTopLeft = modalRadiusTopLeft;
    self.modalRadiusTopRight = modalRadiusTopRight;
    self.modalRadiusBottomLeft = modalRadiusBottomLeft;
    self.modalRadiusBottomRight = modalRadiusBottomRight;
  };
};

struct AdaptiveModalAnimationConfig {
  let modalRotation: CGFloat?;
  
  let modalScaleX: CGFloat?;
  let modalScaleY: CGFloat?;

  let modalTranslateX: CGFloat?;
  let modalTranslateY: CGFloat?;
  
  let modalBackgroundColor: UIColor?;
  let modalBackgroundOpacity: CGFloat?;
  
  let modalRadiusTopLeft: CGFloat?;
  let modalRadiusTopRight: CGFloat?;
  let modalRadiusBottomLeft: CGFloat?;
  let modalRadiusBottomRight: CGFloat?;
  
  let modalBlurEffectStyle: UIBlurEffect.Style?;
  let modalBlurEffectIntensity: CGFloat?;
  
  let backgroundColor: UIColor?;
  let backgroundOpacity: CGFloat?;
  
  let backgroundBlurEffectStyle: UIBlurEffect.Style?;
  let backgroundBlurEffectIntensity: CGFloat?;
  
  init(
     modalRotation: CGFloat? = nil,
     modalScaleX: CGFloat? = nil,
     modalScaleY: CGFloat? = nil,
     modalTranslateX: CGFloat? = nil,
     modalTranslateY: CGFloat? = nil,
     modalBackgroundColor: UIColor? = nil,
     modalBackgroundOpacity: CGFloat? = nil,
     modalRadiusTopLeft: CGFloat? = nil,
     modalRadiusTopRight: CGFloat? = nil,
     modalRadiusBottomLeft: CGFloat? = nil,
     modalRadiusBottomRight: CGFloat? = nil,
     modalBlurEffectStyle: UIBlurEffect.Style? = nil,
     modalBlurEffectIntensity: CGFloat? = nil,
     backgroundColor: UIColor? = nil,
     backgroundOpacity: CGFloat? = nil,
     backgroundBlurEffectStyle: UIBlurEffect.Style? = nil,
     backgroundBlurEffectIntensity: CGFloat? = nil
  ) {
    self.modalRotation = modalRotation;
    
    self.modalScaleX = modalScaleX;
    self.modalScaleY = modalScaleY;
    
    self.modalTranslateX = modalTranslateX;
    self.modalTranslateY = modalTranslateY;
    
    self.modalBackgroundColor = modalBackgroundColor;
    self.modalBackgroundOpacity = modalBackgroundOpacity;
    
    self.modalRadiusTopLeft = modalRadiusTopLeft;
    self.modalRadiusTopRight = modalRadiusTopRight;
    self.modalRadiusBottomLeft = modalRadiusBottomLeft;
    self.modalRadiusBottomRight = modalRadiusBottomRight;
    
    self.modalBlurEffectStyle = modalBlurEffectStyle;
    self.modalBlurEffectIntensity = modalBlurEffectIntensity;
    
    self.backgroundColor = backgroundColor;
    self.backgroundOpacity = backgroundOpacity;
    
    self.backgroundBlurEffectStyle = backgroundBlurEffectStyle;
    self.backgroundBlurEffectIntensity = backgroundBlurEffectIntensity;
  };
};
