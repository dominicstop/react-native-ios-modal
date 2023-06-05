//
//  AdaptiveModalInterpolationPoint.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/29/23.
//

import UIKit

struct AdaptiveModalInterpolationPoint: Equatable {

  private static let DefaultMaskedCorners: CACornerMask = [
    .layerMaxXMinYCorner,
    .layerMinXMinYCorner,
    .layerMaxXMaxYCorner,
    .layerMinXMaxYCorner,
  ];

  // MARK: - Properties
  // ------------------

  let percent: CGFloat;
  let snapPointIndex: Int;

  /// The computed frames of the modal based on the snap points
  let computedRect: CGRect;
  
  // MARK: - Properties - Keyframes
  // ------------------------------
  
  let modalRotation: CGFloat;
  
  let modalScaleX: CGFloat;
  let modalScaleY: CGFloat;

  let modalTranslateX: CGFloat;
  let modalTranslateY: CGFloat;
  
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
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var modalTransforms: [CGAffineTransform] {
    var transforms: [CGAffineTransform] = [];
    
    transforms.append(
      .init(rotationAngle: self.modalRotation)
    );
    
    transforms.append(
      .init(scaleX: self.modalScaleX, y: self.modalScaleY)
    );
    
    return transforms;
  };
  
  var modalTransform: CGAffineTransform {
    self.modalTransforms.reduce(.identity){
      $0.concatenating($1);
    };
  };
  
  // MARK: - Init
  // ------------

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
    
    self.modalRotation = keyframeCurrent?.modalRotation
      ?? keyframePrev?.modalRotation
      ?? 0;
    
    self.modalScaleX = keyframeCurrent?.modalScaleX
      ?? keyframePrev?.modalScaleX
      ?? 1;
    
    self.modalScaleY = keyframeCurrent?.modalScaleY
      ?? keyframePrev?.modalScaleY
      ?? 1;
      
    self.modalTranslateX = keyframeCurrent?.modalTranslateX
      ?? keyframePrev?.modalTranslateX
      ?? 0;
      
    self.modalTranslateY = keyframeCurrent?.modalTranslateY
      ?? keyframePrev?.modalTranslateY
      ?? 0;
      
    self.modalBackgroundOpacity = keyframeCurrent?.modalBackgroundOpacity
      ?? keyframePrev?.modalBackgroundOpacity
      ?? 1;
    
    self.modalCornerRadius = keyframeCurrent?.modalCornerRadius
      ?? keyframePrev?.modalCornerRadius
      ?? 0;
      
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
  
  // MARK: - Functions
  // -----------------
  
  func getModalTransform(
    shouldApplyRotation: Bool = true,
    shouldApplyScale: Bool = true,
    shouldApplyTranslate: Bool = true
  ) -> CGAffineTransform {
  
    var transforms: [CGAffineTransform] = [];
    
    if shouldApplyRotation,
       self.modalRotation != 0 {
       
      transforms.append(
        .init(rotationAngle: self.modalRotation)
      );
    };
    
    if shouldApplyScale,
      self.modalScaleX != 1 && self.modalScaleY != 1 {
      
      transforms.append(
        .init(scaleX: self.modalScaleX, y: self.modalScaleY)
      );
    };
    
    if shouldApplyTranslate,
       self.modalTranslateX != 0 && self.modalTranslateY != 0 {
       
      transforms.append(
        .init(translationX: self.modalTranslateX, y: self.modalTranslateY)
      );
    };
    
    if transforms.isEmpty {
      return .identity;
    };
    
    return transforms.reduce(.identity){
      $0.concatenating($1);
    };
  };
  
  func apply(toModalView modalView: UIView){
    modalView.frame = self.computedRect;
    
    modalView.layer.cornerRadius = self.modalCornerRadius;
    modalView.layer.maskedCorners = self.modalMaskedCorners;
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

