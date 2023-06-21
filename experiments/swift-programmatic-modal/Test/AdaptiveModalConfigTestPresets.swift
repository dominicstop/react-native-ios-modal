//
//  AdaptiveModalConfigTestPresets.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/15/23.
//

import UIKit

enum AdaptiveModalConfigTestPresets: CaseIterable {
  
  static let `default`: Self = .testTopToBottom;
  
  case testModalTransform01;
  case testModalTransformScale;
  case testModalBorderAndShadow01;
  case testLeftToRight;
  case testTopToBottom;

  case test01;
  case test02;
  
  case demo01;
  case demo02;
  case demo03;
  case demo04;
  case demo05;
  case demo06;
  case demo07;
  case demo08;
  case demo09;
  case demo10;
  
  var config: AdaptiveModalConfig {
    switch self {
    
      // MARK: - Tests
      // -------------
    
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
      
      case .testModalTransformScale: return AdaptiveModalConfig(
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
              modalScaleX: 1,
              modalScaleY: 1
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
              modalScaleX: 0.5,
              modalScaleY: 1
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
              modalScaleX: 1.5,
              modalScaleY: 1.5
            )
          ),
        ],
        snapDirection: .bottomToTop,
        undershootSnapPoint: .init(
          layoutPreset: .offscreenBottom,
          animationKeyframe: .init(
            modalScaleX: 0.25,
            modalScaleY: 0.25
          )
        ),
        overshootSnapPoint: AdaptiveModalSnapPointPreset(
          layoutPreset: .fitScreenVertically
        )
      );
      
      case .testModalBorderAndShadow01: return AdaptiveModalConfig(
        snapPoints: [
          // snap point - 0
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: .percent(percentValue: 0.8),
              height: .percent(percentValue: 0.2)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalBorderWidth: 2,
              modalBorderColor: .blue,
              modalShadowColor: .blue,
              modalShadowOffset: .init(width: 3, height: 3),
              modalShadowOpacity: 0.4,
              modalShadowRadius: 4.0
            )
          ),
          
          // snap point - 1
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: .percent(percentValue: 0.8),
              height: .percent(percentValue: 0.4)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalBorderWidth: 4,
              modalBorderColor: .cyan,
              modalShadowColor: .green,
              modalShadowOffset: .init(width: 6, height: 6),
              modalShadowOpacity: 0.5,
              modalShadowRadius: 5
            )
          ),
          // snap point - 2
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: .percent(percentValue: 0.9),
              height: .percent(percentValue: 0.7)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalBorderWidth: 8,
              modalBorderColor: .green,
              modalShadowColor: .purple,
              modalShadowOffset: .init(width: 9, height: 9),
              modalShadowOpacity: 0.9,
              modalShadowRadius: 7
            )
          ),
        ],
        snapDirection: .bottomToTop,
        overshootSnapPoint: AdaptiveModalSnapPointPreset(
          layoutPreset: .fitScreenVertically
        )
      );
      
      case .testLeftToRight: return AdaptiveModalConfig(
        snapPoints: [
          // snap point - 1
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .left,
              verticalAlignment: .center,
              width: .percent(percentValue: 0.5),
              height: .percent(percentValue: 0.65),
              marginLeft: .constant(15)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
            )
          ),
          // snap point - 2
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .center,
              width: .stretch,
              height: .percent(percentValue: 0.85),
              marginLeft: .constant(20),
              marginRight: .constant(20)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
            )
          ),
        ],
        snapDirection: .leftToRight,
        overshootSnapPoint: AdaptiveModalSnapPointPreset(
          layoutPreset: .edgeRight
        )
      );
      
      case .testTopToBottom: return AdaptiveModalConfig(
        snapPoints: [
          .init(
            snapPoint: .init(
              horizontalAlignment: .center,
              verticalAlignment: .top,
              width: .stretch,
              height: .percent(percentValue: 0.2)
            )
          )
        ],
        snapDirection: .topToBottom,
        overshootSnapPoint: .init(
          layoutPreset: .fitScreenVertically
        )
      );
    
      case .test01: return AdaptiveModalConfig(
        snapPoints:  [
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: .stretch,
              height: .percent(percentValue: 0.1)
            )
          ),
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: .stretch,
              height: .percent(percentValue: 0.3)
            )
          ),
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: .stretch,
              height: .percent(percentValue: 0.7)
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
              width: .stretch,
              height: .percent(percentValue: 0.3)
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
      
      // MARK: - Demos
      // -------------
      
      case .demo01: return AdaptiveModalConfig(
        snapPoints: [
          // Snap Point 1
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: .stretch,
              height: .percent(percentValue: 0.3)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              //modalOpacity: 1,
              modalShadowOffset: .init(width: 0, height: -2),
              modalShadowOpacity: 0.2,
              modalShadowRadius: 7,
              modalCornerRadius: 25,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
              ],
              modalBackgroundOpacity: 0.9,
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
              width: .stretch,
              height: .percent(percentValue: 0.5),
              marginLeft: .constant(15),
              marginRight: .constant(15),
              marginBottom: .init(
                mode: .safeAreaInsets(insetKey: \.bottom),
                minValue: .constant(15)
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .init(width: 2, height: 2),
              modalShadowOpacity: 0.2,
              modalShadowRadius: 15,
              modalCornerRadius: 10,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
              ],
              modalBackgroundOpacity: 0.85,
              modalBackgroundVisualEffectIntensity: 0.6,
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
              modalShadowOffset: .init(width: 2, height: 2),
              modalShadowOpacity: 0.3,
              modalShadowRadius: 10,
              modalCornerRadius: 20,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMinYCorner,
                .layerMaxXMaxYCorner
              ],
              modalBackgroundOpacity: 0.8,
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
              modalShadowOffset: .init(width: 0, height: -1),
              modalShadowOpacity: 0.4,
              modalShadowRadius: 10,
              modalCornerRadius: 25,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
              ],
              modalBackgroundOpacity: 0.83,
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
      
      case .demo02: return AdaptiveModalConfig(
        snapPoints: [
          // snap point - 1
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
              modalShadowOffset: .init(width: 0, height: -2),
              modalShadowOpacity: 0.3,
              modalShadowRadius: 7,
              modalCornerRadius: 10,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
              ],
              backgroundOpacity: 0,
              backgroundVisualEffect: UIBlurEffect(style: .regular),
              backgroundVisualEffectIntensity: 0
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
                mode: .percent(percentValue: 0.4)
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .init(width: 1, height: 1),
              modalShadowOpacity: 0.4,
              modalShadowRadius: 7,
              modalCornerRadius: 15,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
              ],
              backgroundOpacity: 0.1
            )
          ),
          // snap point - 3
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNILayoutValue(
                mode: .percent(percentValue: 0.9)
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.7)
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .init(width: 2, height: 2),
              modalShadowOpacity: 0.3,
              modalShadowRadius: 8,
              backgroundOpacity: 0.3,
              backgroundVisualEffect: UIBlurEffect(style: .regular),
              backgroundVisualEffectIntensity: 0.3
            )
          ),
        ],
        snapDirection: .bottomToTop,
        overshootSnapPoint: AdaptiveModalSnapPointPreset(
          layoutPreset: .fitScreenVertically
        )
      );
      
      case .demo03: return AdaptiveModalConfig(
        snapPoints: [
          // snap point - 1
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .left,
              verticalAlignment: .center,
              width: RNILayoutValue(
                mode: .percent(percentValue: 0.5)
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.65)
              ),
              marginLeft: .constant(15)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalScaleX: 1,
              modalScaleY: 1,
              modalShadowOffset: .init(width: 1, height: 1),
              modalShadowOpacity: 0.3,
              modalShadowRadius: 8,
              modalCornerRadius: 10,
              modalBackgroundOpacity: 0.87,
              modalBackgroundVisualEffect: UIBlurEffect(style: .regular),
              modalBackgroundVisualEffectIntensity: 1,
              backgroundVisualEffect: UIBlurEffect(style: .regular),
              backgroundVisualEffectIntensity: 0.04
            )
          ),
          // snap point - 2
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .center,
              width: RNILayoutValue(
                mode: .stretch
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.85)
              ),
              marginLeft: .constant(20),
              marginRight: .constant(20)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .init(width: 2, height: 2),
              modalShadowOpacity: 0.2,
              modalShadowRadius: 15,
              modalCornerRadius: 15,
              modalBackgroundOpacity: 0.9,
              modalBackgroundVisualEffectIntensity: 0.5,
              backgroundVisualEffectIntensity: 0.5
            )
          ),
        ],
        snapDirection: .leftToRight,
        undershootSnapPoint: .init(
          layoutPreset: .offscreenLeft,
          animationKeyframe: .init(
            modalScaleX: 0.5,
            modalScaleY: 0.5,
            modalCornerRadius: 5,
            backgroundVisualEffectIntensity: 0
          )
        ),
        overshootSnapPoint: AdaptiveModalSnapPointPreset(
          layoutPreset: .edgeRight
        )
      );
      
      case .demo04: return AdaptiveModalConfig(
        snapPoints: [
          // 1
          .init(
            snapPoint: .init(
              horizontalAlignment: .center,
              verticalAlignment: .top,
              width: .stretch,
              height: .percent(percentValue: 0.2),
              marginLeft: .constant(10),
              marginRight: .constant(10),
              marginTop: .multipleValues([
                .safeAreaInsets(insetKey: \.top),
                .constant(10)
              ])
            ),
            animationKeyframe: .init(
              modalScaleX: 1,
              modalScaleY: 1,
              modalShadowOpacity: 0.3,
              modalShadowRadius: 10,
              modalCornerRadius: 10
            )
          ),
          
          // 2
          .init(
            snapPoint: .init(
              horizontalAlignment: .center,
              verticalAlignment: .center,
              width: .stretch,
              height: .percent(percentValue: 0.5),
              marginLeft: .constant(15),
              marginRight: .constant(15)
            ),
            animationKeyframe: .init(
              modalShadowOffset: .init(width: 2, height: 2),
              modalShadowOpacity: 0.2,
              modalShadowRadius: 5,
              modalCornerRadius: 15,
              backgroundOpacity: 0.25
            )
          )
        ],
        snapDirection: .topToBottom,
        undershootSnapPoint: .init(
          layoutPreset: .offscreenTop,
          animationKeyframe: .init(
            modalScaleX: 0.75,
            modalScaleY: 0.75
          )
        ),
        overshootSnapPoint: .init(
          layoutPreset: .offscreenBottom,
          animationKeyframe: .init(
            modalScaleX: 0.9,
            modalScaleY: 0.9,
            modalOpacity: 0.8,
            backgroundOpacity: 0
          )
        )
      );
      
      case .demo05: return AdaptiveModalConfig(
        snapPoints: [
          // snap point - 1
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .left,
              verticalAlignment: .center,
              width: .percent(percentValue: 0.7),
              height: .stretch
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .init(width: 1, height: 0),
              modalShadowOpacity: 0.3,
              modalShadowRadius: 8,
              modalBackgroundOpacity: 0.87,
              modalBackgroundVisualEffect: UIBlurEffect(style: .regular),
              modalBackgroundVisualEffectIntensity: 1,
              backgroundVisualEffect: UIBlurEffect(style: .regular),
              backgroundVisualEffectIntensity: 0.04
            )
          ),
          
          // snap point - 2
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .center,
              width: .stretch,
              height: .stretch(
                offsetValue: .multipleValues([
                  .safeAreaInsets(insetKey: \.top),
                  .safeAreaInsets(insetKey: \.bottom),
                  .constant(40),
                ]),
                offsetOperation: .subtract
              ),
              marginLeft: .constant(20),
              marginRight: .constant(20)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .init(width: 2, height: 2),
              modalShadowOpacity: 0.2,
              modalShadowRadius: 15,
              modalCornerRadius: 15,
              modalBackgroundOpacity: 0.9,
              modalBackgroundVisualEffectIntensity: 0.5,
              backgroundVisualEffectIntensity: 0.5
            )
          ),
        ],
        snapDirection: .leftToRight,
        undershootSnapPoint: .init(
          layoutPreset: .offscreenLeft,
          animationKeyframe: .init(
            backgroundVisualEffectIntensity: 0
          )
        ),
        overshootSnapPoint: AdaptiveModalSnapPointPreset(
          layoutPreset: .edgeRight
        )
      );
      
      case .demo06: return AdaptiveModalConfig(
        snapPoints: [
          // snap point - 1
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: .percent(percentValue: 0.8),
              height: .percent(percentValue: 0.2),
              marginBottom: .init(
                mode: .safeAreaInsets(insetKey: \.bottom),
                minValue: .constant(15)
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .init(width: 0, height: -2),
              modalShadowOpacity: 0.3,
              modalShadowRadius: 7,
              modalCornerRadius: 10,
              backgroundOpacity: 0,
              backgroundVisualEffect: UIBlurEffect(style: .regular),
              backgroundVisualEffectIntensity: 0
            )
          ),
          
          // snap point - 2
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: .percent(percentValue: 0.85),
              height: .percent(percentValue: 0.5),
              marginBottom: .init(
                mode: .safeAreaInsets(insetKey: \.bottom),
                minValue: .constant(15)
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .init(width: 1, height: 1),
              modalShadowOpacity: 0.4,
              modalShadowRadius: 7,
              modalCornerRadius: 15,
              backgroundOpacity: 0.1
            )
          ),
          
          // snap point - 3
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: .percent(percentValue: 0.87),
              height: .percent(percentValue: 0.7),
              marginBottom: .init(
                mode: .safeAreaInsets(insetKey: \.bottom),
                minValue: .constant(15)
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .init(width: 2, height: 2),
              modalShadowOpacity: 0.3,
              modalShadowRadius: 8,
              backgroundOpacity: 0.3,
              backgroundVisualEffectIntensity: 0.3
            )
          ),
        ],
        snapDirection: .bottomToTop,
        overshootSnapPoint: AdaptiveModalSnapPointPreset(
          layoutPreset: .layoutConfig(
            .init(
              horizontalAlignment: .center,
              verticalAlignment: .center,
              width: .percent(percentValue: 0.87),
              height: .stretch,
              marginTop: .init(
                mode: .safeAreaInsets(insetKey: \.top),
                minValue: .constant(15)
              ),
              marginBottom: .init(
                mode: .safeAreaInsets(insetKey: \.bottom),
                minValue: .constant(15)
              )
            )
          ),
          animationKeyframe: AdaptiveModalAnimationConfig(
            modalShadowOffset: .init(width: 3, height: 3),
            modalShadowOpacity: 0.35,
            modalShadowRadius: 15
          )
        )
      );
      
      case .demo07: return AdaptiveModalConfig(
        snapPoints: [
          // snap point - 1
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .left,
              verticalAlignment: .center,
              width: .percent(percentValue: 0.7),
              height: .percent(percentValue: 0.65),
              marginLeft: .constant(15)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalScaleX: 1,
              modalScaleY: 1,
              modalShadowOffset: .init(width: 1, height: 1),
              modalShadowOpacity: 0.3,
              modalShadowRadius: 10,
              modalCornerRadius: 15,
              modalBackgroundOpacity: 0.85,
              modalBackgroundVisualEffectIntensity: 0.9,
              backgroundColor: .white,
              backgroundOpacity: 0.15,
              backgroundVisualEffectIntensity: 0.05
            )
          ),
          
          // snap point - 2
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .center,
              width: .stretch,
              height: .stretch
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .zero,
              modalShadowOpacity: 0,
              modalShadowRadius: 0,
              modalBackgroundOpacity: 0,
              modalBackgroundVisualEffectOpacity: 0,
              modalBackgroundVisualEffectIntensity: 0,
              backgroundColor: .white,
              backgroundOpacity: 0.75,
              backgroundVisualEffectIntensity: 1
            )
          ),
        ],
        snapDirection: .leftToRight,
        undershootSnapPoint: .init(
          layoutPreset: .offscreenLeft,
          animationKeyframe: .init(
            modalScaleX: 0.5,
            modalScaleY: 0.5,
            modalCornerRadius: 10,
            modalBackgroundOpacity: 1,
            modalBackgroundVisualEffect: UIBlurEffect(style: .regular),
            modalBackgroundVisualEffectIntensity: 0,
            backgroundVisualEffect: UIBlurEffect(style: .regular),
            backgroundVisualEffectIntensity: 0
          )
        ),
        overshootSnapPoint: AdaptiveModalSnapPointPreset(
          layoutPreset: .offscreenRight
        )
      );
      
      case .demo08: return AdaptiveModalConfig(
        snapPoints: [
          // Snap Point 1
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: .stretch,
              height: .percent(percentValue: 0.3)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .init(width: 0, height: -2),
              modalShadowOpacity: 0.2,
              modalShadowRadius: 7,
              modalCornerRadius: 0,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
              ],
              modalBackgroundOpacity: 0.9,
              modalBackgroundVisualEffect: UIBlurEffect(style: .systemUltraThinMaterial),
              modalBackgroundVisualEffectIntensity: 1,
              backgroundVisualEffect: UIBlurEffect(style: .regular),
              backgroundVisualEffectIntensity: 0
            )
          ),
          
          // Snap Point 2
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: .stretch,
              height: .percent(percentValue: 0.75)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .init(width: 0, height: -2),
              modalShadowOpacity: 0.2,
              modalShadowRadius: 7,
              modalCornerRadius: 15,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
              ],
              modalBackgroundOpacity: 0.85,
              modalBackgroundVisualEffectIntensity: 0.25,
              backgroundVisualEffectIntensity: 0.75
            )
          )
        ],
        snapDirection: .bottomToTop,
        overshootSnapPoint: AdaptiveModalSnapPointPreset(
          layoutPreset: .fitScreen
        )
      );
      
      case .demo09: return AdaptiveModalConfig(
        snapPoints: [
          // Snap Point 1
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: .stretch,
              height: .percent(percentValue: 0.3),
              marginLeft: .multipleValues([
                .safeAreaInsets(insetKey: \.left),
                .constant(15),
              ]),
              marginRight: .multipleValues([
                .safeAreaInsets(insetKey: \.right),
                .constant(15)
              ]),
              marginBottom: .multipleValues([
                .safeAreaInsets(insetKey: \.bottom),
                .keyboardRelativeSize(sizeKey: \.height),
                .constant(15)
              ])
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .init(width: 0, height: -2),
              modalShadowOpacity: 0.2,
              modalShadowRadius: 7,
              modalCornerRadius: 12,
              modalMaskedCorners: .allCorners,
              modalBackgroundOpacity: 0.9,
              modalBackgroundVisualEffect: UIBlurEffect(style: .systemUltraThinMaterial),
              modalBackgroundVisualEffectIntensity: 1,
              backgroundVisualEffect: UIBlurEffect(style: .regular),
              backgroundVisualEffectIntensity: 0
            )
          ),
        ],
        snapDirection: .bottomToTop,
        overshootSnapPoint: AdaptiveModalSnapPointPreset(
          layoutPreset: .fitScreen
        )
      );
      
      case .demo10: return AdaptiveModalConfig(
        snapPoints: [
          // snap point - 1
          AdaptiveModalSnapPointConfig(
            snapPoint: .init(
              horizontalAlignment: .left,
              verticalAlignment: .center,
              width: .percent(percentValue: 0.5),
              height: .percent(percentValue: 0.5)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalScaleX: 1,
              modalScaleY: 1,
              modalShadowOffset: .init(width: 1, height: 1),
              modalShadowOpacity: 0.3,
              modalShadowRadius: 8,
              modalCornerRadius: 10,
              modalMaskedCorners: .rightCorners,
              modalBackgroundOpacity: 0.87,
              modalBackgroundVisualEffect: UIBlurEffect(style: .regular),
              modalBackgroundVisualEffectIntensity: 1,
              backgroundVisualEffect: UIBlurEffect(style: .regular),
              backgroundVisualEffectIntensity: 0.04
            )
          ),
          // snap point - 2
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .left,
              verticalAlignment: .center,
              width: RNILayoutValue(
                mode: .stretch
              ),
              height: RNILayoutValue(
                mode: .percent(percentValue: 0.85)
              ),
              marginRight: .constant(25)
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalShadowOffset: .init(width: 2, height: 2),
              modalShadowOpacity: 0.2,
              modalShadowRadius: 15,
              modalCornerRadius: 15,
              modalBackgroundOpacity: 0.9,
              modalBackgroundVisualEffectIntensity: 0.5,
              backgroundVisualEffectIntensity: 0.5
            )
          ),
        ],
        snapDirection: .leftToRight,
        undershootSnapPoint: .init(
          layoutPreset: .offscreenLeft,
          animationKeyframe: .init(
            modalScaleX: 0.5,
            modalScaleY: 0.5,
            modalCornerRadius: 5,
            backgroundVisualEffectIntensity: 0
          )
        ),
        overshootSnapPoint: AdaptiveModalSnapPointPreset(
          layoutPreset: .edgeRight
        )
      );
    };
  };
};

