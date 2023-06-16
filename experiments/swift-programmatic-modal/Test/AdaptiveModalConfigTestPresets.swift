//
//  AdaptiveModalConfigTestPresets.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/15/23.
//

import UIKit

enum AdaptiveModalConfigTestPresets: CaseIterable {
  
  static let `default`: Self = .testModalTransform01;
  
  case testModalTransform01;

  case test01;
  case test02;
  case test03;
  
  var config: AdaptiveModalConfig {
    switch self {
      case .testModalTransform01: return AdaptiveModalConfig(
        snapPoints: [
          // snap point - 0
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNILayoutValue(
                mode: .percent(percentValue: 0.8)
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.2)
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalRotation: 0.2,
              modalScaleX: 0.5,
              modalScaleY: 0.5,
              modalTranslateX: -100,
              modalTranslateY: 20
            )
          ),
          
          // snap point - 1
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNILayoutValue(
                mode: .percent(percentValue: 0.8)
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.4)
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalRotation: -0.2,
              modalScaleX: 0.5,
              modalScaleY: 1,
              modalTranslateX: 0,
              modalTranslateY: 0
            )
          ),
          // snap point - 2
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNILayoutValue(
                mode: .percent(percentValue: 0.8)
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.6)
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              //modalRotation: 1,
              modalScaleX: 1,
              modalScaleY: 1
              //modalTranslateX: 0,
              //modalTranslateY: 0
            )
          ),
        ],
        snapDirection: .bottomToTop,
        overshootSnapPoint: AdaptiveModalSnapPointPreset(
          layoutPreset: .fitScreenVertically
        )
      );
    
      case .test01: return AdaptiveModalConfig(
        snapPoints:  [
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
                horizontalAlignment: .center,
                verticalAlignment: .bottom,
                width: RNILayoutValue(
                  mode: .stretch
                ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.1)
              )
            )
          ),
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNILayoutValue(
                mode: .stretch
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.3)
              )
            )
          ),
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNILayoutValue(
                mode: .stretch
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.7)
              )
            )
          ),
        ],
        snapDirection: .bottomToTop
      );
      
      case .test02: return AdaptiveModalConfig(
        snapPoints: [
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNILayoutValue(
                mode: .stretch
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.3)
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalCornerRadius: 15,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
              ],
              backgroundVisualEffect: UIBlurEffect(style: .regular),
              backgroundVisualEffectIntensity: 0
            )
          ),
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .center,
              width: RNILayoutValue(
                mode: .percent(percentValue: 0.7),
                maxValue: .constant(ScreenSize.iPhone8.size.width)
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.7),
                maxValue: .constant(ScreenSize.iPhone8.size.height)
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalCornerRadius: 20,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMinYCorner,
                .layerMaxXMaxYCorner
              ],
              backgroundVisualEffect: UIBlurEffect(style: .regular),
              backgroundVisualEffectIntensity: 0.5
            )
          ),
        ],
        snapDirection: .bottomToTop,
        interpolationClampingConfig: .init(
          shouldClampModalLastHeight: true,
          shouldClampModalLastWidth: true,
          shouldClampModalLastX: true
        )
      );
      
      case .test03: return AdaptiveModalConfig(
        snapPoints: [
          // Snap Point 1
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNILayoutValue(
                mode: .stretch
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.3)
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              //modalOpacity: 1,
              modalBackgroundOpacity: 0.9,
              modalCornerRadius: 15,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
              ],
              modalBackgroundVisualEffect: UIBlurEffect(style: .systemUltraThinMaterial),
              modalBackgroundVisualEffectIntensity: 1,
              
              backgroundOpacity: 0,
              backgroundVisualEffect: UIBlurEffect(style: .systemUltraThinMaterialDark),
              backgroundVisualEffectIntensity: 0
            )
          ),
          
          // Snap Point 2
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNILayoutValue(
                mode: .stretch
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.5)
              ),
              marginLeft: .constant(15),
              marginRight: .constant(15),
              marginBottom: .constant(15)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              //modalOpacity: 0.5,
              //modalBackgroundColor: .red,
              modalBackgroundOpacity: 0.85,
              modalCornerRadius: 15,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
              ],
              modalBackgroundVisualEffectIntensity: 0.6,
              //backgroundColor: .red,
              backgroundOpacity: 0.1,
              backgroundVisualEffectIntensity: 0.075
            )
          ),
          
          // Snap Point 3
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .center,
              width: RNILayoutValue(
                mode: .percent(percentValue: 0.85),
                maxValue: .constant(ScreenSize.iPhone8.size.width)
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.75),
                maxValue: .constant(ScreenSize.iPhone8.size.height)
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalBackgroundOpacity: 0.8,
              modalCornerRadius: 20,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMinYCorner,
                .layerMaxXMaxYCorner
              ],
              modalBackgroundVisualEffectIntensity: 1,
              backgroundOpacity: 0,
              //backgroundVisualEffectOpacity: 0.5,
              backgroundVisualEffectIntensity: 0.5
            )
          ),
          
          // Snap Point 4
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNILayoutValue(
                mode: .stretch
              ),
              height: RNILayoutValue(
                mode: .stretch
              ),
              marginTop: .safeAreaInsets(insetKey: \.top)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalBackgroundOpacity: 0.83,
              modalCornerRadius: 25,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
              ],
              modalBackgroundVisualEffectIntensity: 1,
              backgroundVisualEffectIntensity: 1
            )
          ),
        ],
        snapDirection: .bottomToTop,
        interpolationClampingConfig: .init(
          shouldClampModalLastHeight: true,
          shouldClampModalLastWidth: true,
          shouldClampModalLastX: true
        ),
        overshootSnapPoint: AdaptiveModalSnapPointPreset(
          layoutPreset: .fitScreen
        )
      );
    };
  };
};

