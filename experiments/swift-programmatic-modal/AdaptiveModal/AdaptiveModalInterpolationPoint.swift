//
//  AdaptiveModalInterpolationPoint.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/29/23.
//

import UIKit

public struct AdaptiveModalInterpolationPoint: Equatable {
  
  // MARK: - Properties
  // ------------------

  public var percent: CGFloat;
  public var snapPointIndex: Int;

  /// The computed frames of the modal based on the snap points
  public var computedRect: CGRect;
  
  // MARK: - Properties - Keyframes
  // ------------------------------
  
  public var modalRotation: CGFloat;
  
  public var modalScaleX: CGFloat;
  public var modalScaleY: CGFloat;

  public var modalTranslateX: CGFloat;
  public var modalTranslateY: CGFloat;
  
  public var modalBorderWidth: CGFloat;
  public var modalBorderColor: UIColor;
  
  public var modalShadowColor: UIColor;
  public var modalShadowOffset: CGSize;
  public var modalShadowOpacity: CGFloat;
  public var modalShadowRadius: CGFloat;
  
  public var modalCornerRadius: CGFloat;
  public var modalMaskedCorners: CACornerMask;
  
  public var modalOpacity: CGFloat;
  public var modalBackgroundColor: UIColor;
  public var modalBackgroundOpacity: CGFloat;
  
  public var modalBackgroundVisualEffect: UIVisualEffect?;
  public var modalBackgroundVisualEffectOpacity: CGFloat;
  public var modalBackgroundVisualEffectIntensity: CGFloat;
  
  public var backgroundColor: UIColor;
  public var backgroundOpacity: CGFloat;
  
  public var backgroundVisualEffect: UIVisualEffect?;
  public var backgroundVisualEffectOpacity: CGFloat;
  public var backgroundVisualEffectIntensity: CGFloat;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var modalTransforms: [CGAffineTransform] {
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
  
  public var modalTransform: CGAffineTransform {
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
  
  func apply(
    toModalView modalView: UIView,
    toModalWrapperView modalWrapperView: UIView,
    toModalWrapperTransformView modalWrapperTransformView: UIView?,
    toModalWrapperShadowView modalWrapperShadowView: UIView?,
    toDummyModalView dummyModalView: UIView,
    toModalBackgroundView modalBgView: UIView?,
    toBackgroundView bgView: UIView?,
    toModalBackgroundEffectView modalBgEffectView: UIVisualEffectView?,
    toBackgroundVisualEffectView bgVisualEffectView: UIVisualEffectView?
  ){
    modalView.alpha = self.modalOpacity;
    
    modalView.layer.cornerRadius = self.modalCornerRadius;
    modalView.layer.maskedCorners = self.modalMaskedCorners;
    
    modalWrapperView.frame = self.computedRect;
    
    if let view = modalWrapperTransformView {
      view.transform = self.modalTransform;
    };
    
    if let view = modalWrapperShadowView {
      // border
      view.layer.borderWidth = self.modalBorderWidth;
      view.layer.borderColor = self.modalBorderColor.cgColor;

      // shadow
      view.layer.shadowColor = self.modalShadowColor.cgColor;
      view.layer.shadowOffset = self.modalShadowOffset;
      view.layer.shadowOpacity = Float(self.modalShadowOpacity);
      view.layer.shadowRadius = self.modalShadowRadius;
    };
    
    dummyModalView.frame = self.computedRect;
    
    if let view = modalBgView {
      view.alpha = self.modalBackgroundOpacity;
      view.backgroundColor = self.modalBackgroundColor;
    };
    
    if let bgView = bgView {
      bgView.alpha = self.backgroundOpacity;
      bgView.backgroundColor = self.backgroundColor;
    };
    
    if let effectView = modalBgEffectView {
      effectView.alpha = self.modalBackgroundVisualEffectOpacity;
    };
    
    if let effectView = bgVisualEffectView {
      effectView.alpha = self.backgroundVisualEffectOpacity;
    };
  };
};

// MARK: - Init
// ------------

public extension AdaptiveModalInterpolationPoint {

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
      ?? .allCorners;
      
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

public extension AdaptiveModalInterpolationPoint {

  static func compute(
    usingModalConfig modalConfig: AdaptiveModalConfig,
    snapPoints: [AdaptiveModalSnapPointConfig]? = nil,
    layoutValueContext context: RNILayoutValueContext
  ) -> [Self] {
  
    let snapPoints = snapPoints ?? modalConfig.snapPoints;
    var items: [AdaptiveModalInterpolationPoint] = [];
    
    for (index, snapConfig) in snapPoints.enumerated() {
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

