//
//  AdaptiveModalInterpolationPoint.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/29/23.
//

import UIKit

struct AdaptiveModalInterpolationPoint: Equatable {

  static let DefaultMaskedCorners: CACornerMask = [
    .layerMaxXMinYCorner,
    .layerMinXMinYCorner,
    .layerMaxXMaxYCorner,
    .layerMinXMaxYCorner,
  ];
  
  // MARK: - Properties
  // ------------------

  var percent: CGFloat;
  var snapPointIndex: Int;

  /// The computed frames of the modal based on the snap points
  var computedRect: CGRect;
  
  // MARK: - Properties - Keyframes
  // ------------------------------
  
  var modalRotation: CGFloat;
  
  var modalScaleX: CGFloat;
  var modalScaleY: CGFloat;

  var modalTranslateX: CGFloat;
  var modalTranslateY: CGFloat;
  
  var modalBorderWidth: CGFloat;
  var modalBorderColor: UIColor;
  
  var modalShadowColor: UIColor;
  var modalShadowOffset: CGSize;
  var modalShadowOpacity: CGFloat;
  var modalShadowRadius: CGFloat;
  
  var modalCornerRadius: CGFloat;
  var modalMaskedCorners: CACornerMask;
  
  var modalOpacity: CGFloat;
  var modalBackgroundColor: UIColor;
  var modalBackgroundOpacity: CGFloat;
  
  var modalBackgroundVisualEffect: UIVisualEffect?;
  var modalBackgroundVisualEffectOpacity: CGFloat;
  var modalBackgroundVisualEffectIntensity: CGFloat;
  
  var backgroundColor: UIColor;
  var backgroundOpacity: CGFloat;
  
  var backgroundVisualEffect: UIVisualEffect?;
  var backgroundVisualEffectOpacity: CGFloat;
  var backgroundVisualEffectIntensity: CGFloat;
  
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
    
    transforms.append(
      .init(translationX: self.modalTranslateX, y: modalTranslateY)
    );
    
    return transforms;
  };
  
  var modalTransform: CGAffineTransform {
    self.modalTransforms.reduce(.identity){
      $0.concatenating($1);
    };
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
    modalView.alpha = self.modalOpacity;
    
    modalView.layer.cornerRadius = self.modalCornerRadius;
    modalView.layer.maskedCorners = self.modalMaskedCorners;
  };
  
  func apply(toModalWrapperView modalWrapperView: UIView){
    modalWrapperView.frame = self.computedRect;
  };
  
  func apply(toModalWrapperTransformView view: UIView?){
    view?.transform = self.modalTransform;
  };
  
  func apply(toModalWrapperShadowView view: UIView?){
    guard let view = view else { return };
    
    // border
    view.layer.borderWidth = self.modalBorderWidth;
    view.layer.borderColor = self.modalBorderColor.cgColor;

    // shadow
    view.layer.shadowColor = self.modalShadowColor.cgColor;
    view.layer.shadowOffset = self.modalShadowOffset;
    view.layer.shadowOpacity = Float(self.modalShadowOpacity);
    view.layer.shadowRadius = self.modalShadowRadius;
  };
  
  func apply(toDummyModalView dummyModalView: UIView){
    dummyModalView.frame = self.computedRect;
  };
  
  func apply(toModalBackgroundView modalBgView: UIView?){
    modalBgView?.alpha = self.modalBackgroundOpacity;
    modalBgView?.backgroundColor = self.modalBackgroundColor;
  };
  
  func apply(toModalBackgroundEffectView effectView: UIVisualEffectView?){
    effectView?.alpha = self.modalBackgroundVisualEffectOpacity;
  };
  
  func apply(toBackgroundView bgView: UIView?){
    bgView?.alpha = self.backgroundOpacity;
  };
  
  func apply(toBackgroundVisualEffectView effectView: UIView?){
    effectView?.alpha = self.backgroundVisualEffectOpacity;
  };
};

// MARK: - Init
// ------------

extension AdaptiveModalInterpolationPoint {

  init(
    usingModalConfig modalConfig: AdaptiveModalConfig,
    snapPointIndex: Int,
    percent: CGFloat? = nil,
    layoutValueContext context: RNILayoutValueContext,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    prevInterpolationPoint keyframePrev: Self? = nil
  ) {
    self.snapPointIndex = snapPointIndex;
    
    let computedRect = snapPointConfig.snapPoint.computeRect(
      usingLayoutValueContext: context
    );
    
    self.computedRect = computedRect;
    
    self.percent = percent ?? {
      switch modalConfig.snapPercentStrategy {
        case .position:
          let maxRangeInput =
            context.targetRect[keyPath: modalConfig.maxInputRangeKeyForRect];
          
          let inputValue =
            computedRect[keyPath: modalConfig.inputValueKeyForRect];
            
          let percent = inputValue / maxRangeInput;
          
          return modalConfig.shouldInvertPercent
            ? AdaptiveModalUtilities.invertPercent(percent)
            : percent;
            
        case .index:
          let current = CGFloat(snapPointIndex + 1);
          let max = CGFloat(modalConfig.snapPoints.count);
          
          return current / max;
      };
    }();
    
    let isFirstSnapPoint = snapPointIndex == 0;
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
      
    self.modalBorderWidth = keyframeCurrent?.modalBorderWidth
      ?? keyframePrev?.modalBorderWidth
      ?? 0;
    
    self.modalBorderColor = keyframeCurrent?.modalBorderColor
      ?? keyframePrev?.modalBorderColor
      ?? .black;
    
    self.modalShadowColor = keyframeCurrent?.modalShadowColor
      ?? keyframePrev?.modalShadowColor
      ?? .black;
    
    self.modalShadowOffset = keyframeCurrent?.modalShadowOffset
      ?? keyframePrev?.modalShadowOffset
      ?? .zero;
    
    self.modalShadowOpacity = keyframeCurrent?.modalShadowOpacity
      ?? keyframePrev?.modalShadowOpacity
      ?? 0;
    
    self.modalShadowRadius = keyframeCurrent?.modalShadowRadius
      ?? keyframePrev?.modalShadowRadius
      ?? 0;
    
    self.modalCornerRadius = keyframeCurrent?.modalCornerRadius
      ?? keyframePrev?.modalCornerRadius
      ?? 0;
      
    self.modalMaskedCorners = keyframeCurrent?.modalMaskedCorners
      ?? keyframePrev?.modalMaskedCorners
      ?? Self.DefaultMaskedCorners;
      
    self.modalOpacity = keyframeCurrent?.modalOpacity
      ?? keyframePrev?.modalOpacity
      ?? 1;
      
    self.modalBackgroundColor = keyframeCurrent?.modalBackgroundColor
      ?? keyframePrev?.modalBackgroundColor
      ?? .systemBackground;
      
    self.modalBackgroundOpacity = keyframeCurrent?.modalBackgroundOpacity
      ?? keyframePrev?.modalBackgroundOpacity
      ?? 1;
      
    self.modalBackgroundVisualEffect = keyframeCurrent?.modalBackgroundVisualEffect
      ?? keyframePrev?.modalBackgroundVisualEffect;
      
    self.modalBackgroundVisualEffectOpacity = keyframeCurrent?.modalBackgroundVisualEffectOpacity
      ?? keyframePrev?.modalBackgroundVisualEffectOpacity
      ?? 1;
      
    self.modalBackgroundVisualEffectIntensity = keyframeCurrent?.modalBackgroundVisualEffectIntensity
      ?? keyframePrev?.modalBackgroundVisualEffectIntensity
      ?? (isFirstSnapPoint ? 0 : 1);
      
    self.backgroundColor = keyframeCurrent?.backgroundColor
      ?? keyframePrev?.backgroundColor
      ?? .black;
      
    self.backgroundOpacity = keyframeCurrent?.backgroundOpacity
      ?? keyframePrev?.backgroundOpacity
      ?? 0;
      
    self.backgroundVisualEffect = keyframeCurrent?.backgroundVisualEffect
      ?? keyframePrev?.backgroundVisualEffect;
      
    self.backgroundVisualEffectOpacity = keyframeCurrent?.backgroundVisualEffectOpacity
      ?? keyframePrev?.backgroundVisualEffectOpacity
      ?? 1;
      
    self.backgroundVisualEffectIntensity = keyframeCurrent?.backgroundVisualEffectIntensity
      ?? keyframePrev?.backgroundVisualEffectIntensity
      ?? (isFirstSnapPoint ? 0 : 1);
  };
};

// MARK: - Helpers
// ---------------

extension AdaptiveModalInterpolationPoint {

  static func compute(
    usingModalConfig modalConfig: AdaptiveModalConfig,
    layoutValueContext context: RNILayoutValueContext
  ) -> [Self] {

    var items: [AdaptiveModalInterpolationPoint] = [];
    
    for (index, snapConfig) in modalConfig.snapPoints.enumerated() {
      items.append(
        AdaptiveModalInterpolationPoint(
          usingModalConfig: modalConfig,
          snapPointIndex: index,
          layoutValueContext: context,
          snapPointConfig: snapConfig,
          prevInterpolationPoint: items.last
        )
      );
    };
    
    return items;
  };
};

