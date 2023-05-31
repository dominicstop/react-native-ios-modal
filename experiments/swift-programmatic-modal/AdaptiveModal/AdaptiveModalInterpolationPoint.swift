//
//  AdaptiveModalInterpolationPoint.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/29/23.
//

import UIKit

struct AdaptiveModalInterpolationPoint: Equatable {

  let modalConfigIndex: Int;

  /// The computed frames of the modal based on the snap points
  let computedRect: CGRect;
  
  let modalCornerRadius: CGFloat;
  let modalMaskedCorners: CACornerMask;
  
  let backgroundVisualEffect: UIVisualEffect?;

  init(
    modalConfigIndex: Int,
    withTargetRect targetRect: CGRect,
    currentSize: CGSize,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    prevSnapPointConfig: AdaptiveModalSnapPointConfig? = nil
  ) {
    self.modalConfigIndex = modalConfigIndex;
    
    self.computedRect = snapPointConfig.snapPoint.computeRect(
      withTargetRect: targetRect,
      currentSize: currentSize
    );
    
    let keyframeCurrent = snapPointConfig.animationKeyframe;
    let keyframePrev    = prevSnapPointConfig?.animationKeyframe;
    
    self.modalCornerRadius = keyframeCurrent?.modalCornerRadius
      ?? keyframePrev?.modalCornerRadius
      ?? Self.DefaultCornerRadius;
      
    self.modalMaskedCorners = keyframePrev?.modalMaskedCorners
      ?? keyframePrev?.modalMaskedCorners
      ?? Self.DefaultMaskedCorners;
      
    self.backgroundVisualEffect = keyframePrev?.backgroundVisualEffect
      ?? keyframePrev?.backgroundVisualEffect;
  };
  
  func apply(toModalView modalView: UIView){
    modalView.frame = self.computedRect;
    modalView.layer.cornerRadius = self.modalCornerRadius;
    modalView.layer.maskedCorners = self.modalMaskedCorners;
  };
  
  func apply(toBackgroundEffectView effectView: UIVisualEffectView){
    effectView.effect = self.backgroundVisualEffect;
  };
};

extension AdaptiveModalInterpolationPoint {

  private static let DefaultCornerRadius: CGFloat = 0;
  
  private static let DefaultMaskedCorners: CACornerMask = [
    .layerMaxXMinYCorner,
    .layerMinXMinYCorner,
    .layerMaxXMaxYCorner,
    .layerMinXMaxYCorner,
  ];
  
  static func compute(
    usingModalConfig modalConfig: AdaptiveModalConfig,
    withTargetRect targetRect: CGRect,
    currentSize: CGSize
  ) -> [Self] {

  var items: [AdaptiveModalInterpolationPoint] = [];

    for (index, snapConfig) in modalConfig.snapPoints.enumerated() {
      let prevSnapConfig = modalConfig.snapPoints[safeIndex: index];
      
      items.append(
        AdaptiveModalInterpolationPoint(
          modalConfigIndex: index,
          withTargetRect: targetRect,
          currentSize: currentSize,
          snapPointConfig: snapConfig,
          prevSnapPointConfig: prevSnapConfig
        )
      );
    };
    
    items.append({
      let prevSnapPointConfig = modalConfig.snapPoints.last!;
      
      let snapPointConfig = AdaptiveModalSnapPointConfig(
        fromSnapPointPreset: modalConfig.overshootSnapPoint,
        fromBaseLayoutConfig: prevSnapPointConfig.snapPoint,
        withTargetRect: targetRect,
        currentSize: currentSize
      );
      
      return AdaptiveModalInterpolationPoint(
        modalConfigIndex: modalConfig.snapPointLastIndex + 1,
        withTargetRect: targetRect,
        currentSize: currentSize,
        snapPointConfig: snapPointConfig,
        prevSnapPointConfig: prevSnapPointConfig
      );
    }());
    
    return items;
  };
};

