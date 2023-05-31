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
  
  let modalCornerRadius: CGFloat;
  let modalMaskedCorners: CACornerMask;

  init(
    withTargetRect targetRect: CGRect,
    currentSize: CGSize,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    modalCornerRadius: CGFloat,
    modalMaskedCorners: CACornerMask
  ) {
    self.computedRect = snapPointConfig.snapPoint.computeRect(
      withTargetRect: targetRect,
      currentSize: currentSize
    );
    
    self.modalCornerRadius = modalCornerRadius;
    self.modalMaskedCorners = modalMaskedCorners;
  };
  
  func apply(toModalView modalView: UIView){
    modalView.frame = self.computedRect;
    modalView.layer.cornerRadius = self.modalCornerRadius;
    modalView.layer.maskedCorners = self.modalMaskedCorners;
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
  
  let defaultMaskedCorners: CACornerMask = [
    .layerMaxXMinYCorner,
    .layerMinXMinYCorner,
    .layerMaxXMaxYCorner,
    .layerMinXMaxYCorner,
  ];
    
    for snapConfig in modalConfig.snapPoints {
      let keyframe = snapConfig.animationKeyframe;
      let prevKeyframe = items.last;
      
      items.append(
        AdaptiveModalInterpolationPoint(
          withTargetRect : targetRect,
          currentSize    : currentSize,
          snapPointConfig: snapConfig,
          
          modalCornerRadius: keyframe?.modalCornerRadius
            ?? prevKeyframe?.modalCornerRadius ?? defaultCornerRadius,
            
          modalMaskedCorners: keyframe?.modalMaskedCorners
            ?? prevKeyframe?.modalMaskedCorners ?? defaultMaskedCorners
        )
      );
    };
    
    return items;
  };
  
};
