//
//  AdaptiveModalInterpolationPoint.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/29/23.
//

import UIKit

struct AdaptiveModalInterpolationPoint {

  /// The computed frames of the modal based on the snap points
  let computedRect: CGRect;
  
  let modalRadiusTopLeft: CGFloat;
  let modalRadiusTopRight: CGFloat;
  let modalRadiusBottomLeft: CGFloat;
  let modalRadiusBottomRight: CGFloat;
  
  var modalRadiusMask: CAShapeLayer {
    let bounds = CGRect(
      origin: .zero,
      size: self.computedRect.size
    );
    
    let radiusPath = UIBezierPath(
      shouldRoundRect: bounds,
      topLeftRadius: self.modalRadiusTopLeft,
      topRightRadius: self.modalRadiusTopRight,
      bottomLeftRadius: self.modalRadiusBottomLeft,
      bottomRightRadius: self.modalRadiusBottomRight
    );
    
    let shape = CAShapeLayer();
    shape.path = radiusPath.cgPath;
    
    return shape;
  };
  
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

extension AdaptiveModalInterpolationPoint {
  
  static func compute(
    usingModalConfig modalConfig: AdaptiveModalConfig,
    withTargetRect targetRect: CGRect,
    currentSize: CGSize
  ) -> [AdaptiveModalInterpolationPoint] {

  var items: [AdaptiveModalInterpolationPoint] = [];

  let defaultCornerRadius: CGFloat = 0;
    
    for snapConfig in modalConfig.snapPoints {
      let keyframe = snapConfig.animationKeyframe;
      let prevKeyframe = items.last;
      
      items.append(
        AdaptiveModalInterpolationPoint(
          withTargetRect : targetRect,
          currentSize    : currentSize,
          snapPointConfig: snapConfig,
          
          modalRadiusTopLeft: keyframe?.modalRadiusTopLeft
            ?? prevKeyframe?.modalRadiusTopLeft ?? defaultCornerRadius,
            
          modalRadiusTopRight: keyframe?.modalRadiusTopRight
            ?? prevKeyframe?.modalRadiusTopRight ?? defaultCornerRadius,
            
          modalRadiusBottomLeft: keyframe?.modalRadiusBottomLeft
            ?? prevKeyframe?.modalRadiusBottomLeft ?? defaultCornerRadius,
            
          modalRadiusBottomRight: keyframe?.modalRadiusBottomRight
            ?? prevKeyframe?.modalRadiusBottomRight ?? defaultCornerRadius
        )
      );
    };
    
    return items;
  };
  
};
