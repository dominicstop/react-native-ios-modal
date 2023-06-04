//
//  AdaptiveModalInterpolationPoint.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/29/23.
//

import UIKit

struct AdaptiveModalInterpolationPoint: Equatable {

  let percent: CGFloat;
  let snapPointIndex: Int;

  /// The computed frames of the modal based on the snap points
  let computedRect: CGRect;
  
  //let modalRotation: CGFloat;
  
  //let modalScaleX: CGFloat;
  //let modalScaleY: CGFloat;

  //let modalTranslateX: CGFloat;
  //let modalTranslateY: CGFloat;
  
  //let modalBackgroundColor: UIColor;
  let modalBackgroundOpacity: CGFloat;
  
  let modalCornerRadius: CGFloat;
  let modalMaskedCorners: CACornerMask;
  
  let modalBackgroundVisualEffect: UIVisualEffect?;
  let modalBackgroundVisualEffectIntensity: CGFloat;
  
  //let backgroundColor: UIColor;
  let backgroundOpacity: CGFloat;
  
  let backgroundVisualEffect: UIVisualEffect?;
  let backgroundVisualEffectIntensity: CGFloat;

  init(
    usingModalConfig modalConfig: AdaptiveModalConfig,
    snapPointIndex: Int,
    percent: CGFloat? = nil,
    withTargetRect targetRect: CGRect,
    currentSize: CGSize,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    prevInterpolationPoint keyframePrev: Self? = nil
  ) {
    self.snapPointIndex = snapPointIndex;
    
    let computedRect = snapPointConfig.snapPoint.computeRect(
      withTargetRect: targetRect,
      currentSize: currentSize
    );
    
    self.computedRect = computedRect;
    
    self.percent = percent ?? {
      switch modalConfig.snapPercentStrategy {
        case .position:
          let maxRangeInput =
            targetRect[keyPath: modalConfig.maxInputRangeKeyForRect];
          
          let inputValue =
            computedRect.origin[keyPath: modalConfig.inputValueKeyForPoint];
            
          let percent = inputValue / maxRangeInput;
          
          return modalConfig.shouldInvertPercent
            ? AdaptiveModalManager.invertPercent(percent)
            : percent;
            
        case .index:
          let current = CGFloat(snapPointIndex + 1);
          let max = CGFloat(modalConfig.snapPoints.count);
          
          return current / max;
      };
    }();
    
    let keyframeCurrent = snapPointConfig.animationKeyframe;
    
    self.modalBackgroundOpacity = keyframeCurrent?.modalBackgroundOpacity
      ?? keyframePrev?.modalBackgroundOpacity
      ?? 1;
    
    self.modalCornerRadius = keyframeCurrent?.modalCornerRadius
      ?? keyframePrev?.modalCornerRadius
      ?? Self.DefaultCornerRadius;
      
    self.modalMaskedCorners = keyframeCurrent?.modalMaskedCorners
      ?? keyframePrev?.modalMaskedCorners
      ?? Self.DefaultMaskedCorners;
      
    self.modalBackgroundVisualEffect = keyframeCurrent?.modalBackgroundVisualEffect
      ?? keyframePrev?.modalBackgroundVisualEffect;
      
    self.modalBackgroundVisualEffectIntensity = keyframeCurrent?.modalBackgroundVisualEffectIntensity
      ?? keyframePrev?.modalBackgroundVisualEffectIntensity
      ?? 1;
      
    self.backgroundOpacity = keyframeCurrent?.backgroundOpacity
      ?? keyframePrev?.backgroundOpacity
      ?? 0;
      
    self.backgroundVisualEffect = keyframeCurrent?.backgroundVisualEffect
      ?? keyframePrev?.backgroundVisualEffect;
      
    self.backgroundVisualEffectIntensity = keyframeCurrent?.backgroundVisualEffectIntensity
      ?? keyframePrev?.backgroundVisualEffectIntensity
      ?? 1;
  };
  
  func apply(toModalView modalView: UIView){
    modalView.frame = self.computedRect;
    // modalView.layer.cornerRadius = self.modalCornerRadius;
    // modalView.layer.maskedCorners = self.modalMaskedCorners;
  };
  
  func apply(toDummyModalView dummyModalView: UIView){
    dummyModalView.frame = self.computedRect;
  };
  
  func apply(toModalBackgroundView modalBgView: UIView?){
    modalBgView?.alpha = self.modalBackgroundOpacity;
  };
  
  func apply(toBackgroundEffectView effectView: UIVisualEffectView?){
    effectView?.effect = self.backgroundVisualEffect;
  };
  
  func apply(toBackgroundView bgView: UIView?){
    bgView?.alpha = self.backgroundOpacity;
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
      items.append(
        AdaptiveModalInterpolationPoint(
          usingModalConfig: modalConfig,
          snapPointIndex: index,
          withTargetRect: targetRect,
          currentSize: currentSize,
          snapPointConfig: snapConfig,
          prevInterpolationPoint: items.last
        )
      );
    };
    
    items.append({
      let prevSnapPointConfig = modalConfig.snapPoints.last!;
      
      let overshootSnapPointConfig = AdaptiveModalSnapPointConfig(
        fromSnapPointPreset: modalConfig.overshootSnapPoint,
        fromBaseLayoutConfig: prevSnapPointConfig.snapPoint,
        withTargetRect: targetRect,
        currentSize: currentSize
      );
      
      return AdaptiveModalInterpolationPoint(
        usingModalConfig: modalConfig,
        snapPointIndex: modalConfig.snapPointLastIndex + 1,
        percent: 1,
        withTargetRect: targetRect,
        currentSize: currentSize,
        snapPointConfig: overshootSnapPointConfig,
        prevInterpolationPoint: items.last
      );
    }());
    
    return items;
  };
};

