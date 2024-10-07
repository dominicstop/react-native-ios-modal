//
//  ModalSheetBottomAttachedOverlayLayoutConfigPreset.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/6/24.
//

import Foundation

/// These are mainly used for testing
///
public enum ModalSheetBottomAttachedOverlayLayoutConfigPreset: String, CaseIterable {
  
  case stretchWithSafeAreaPadding;
  
  case centerFloatStretch80Percent;
  case centerAttachedStretch90Percent;
  
  case leadingFloatStretchQuarter;
  case leadingFloatStretchHalf;
  case leadingFloatStretchThreeQuarters;
  
  case trailingFloatStretchQuarter;
  case trailingFloatStretchHalf;
  case trailingFloatStretchThreeQuarters;
  
  case leadingAttachedStretchQuarter;
  case leadingAttachedStretchHalf;
  case leadingAttachedStretchThreeQuarters;
  
  case trailingAttachedStretchQuarter;
  case trailingAttachedStretchHalf;
  case trailingAttachedStretchThreeQuarters;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var config: ModalSheetBottomAttachedOverlayLayoutConfig {
    switch self {
      case .stretchWithSafeAreaPadding:
        return .init(
          horizontalPositionMode: .stretch,
          paddingBottom: .safeArea(
            additionalValue: 0,
            minValue: 0
          )
        );
        
      case .centerFloatStretch80Percent:
        return .init(
          horizontalPositionMode: .centerStretch(percent: 0.8),
          marginBottom: .safeArea(
            additionalValue: 0,
            minValue: 12
          )
        );
        
      case .centerAttachedStretch90Percent:
        return .init(
          horizontalPositionMode: .centerStretch(percent: 0.9),
          paddingBottom: .safeArea(
            additionalValue: 0,
            minValue: 12
          )
        );
        
      case .leadingFloatStretchQuarter:
        return .init(
          horizontalPositionMode: .leadingStretch(percent: 0.25),
          marginLeft: 12,
          marginBottom: .safeArea(
            additionalValue: 0,
            minValue: 12
          )
        );
      
      case .leadingFloatStretchHalf:
        return .init(
          horizontalPositionMode: .leadingStretch(percent: 0.5),
          marginLeft: 12,
          marginBottom: .safeArea(
            additionalValue: 0,
            minValue: 12
          )
        );
        
      case .leadingFloatStretchThreeQuarters:
        return .init(
          horizontalPositionMode: .leadingStretch(percent: 0.75),
          marginLeft: 12,
          marginBottom: .safeArea(
            additionalValue: 0,
            minValue: 12
          )
        );
  
      case .trailingFloatStretchQuarter:
        return .init(
          horizontalPositionMode: .trailingStretch(percent: 0.25),
          marginRight: 12,
          marginBottom: .safeArea(
            additionalValue: 0,
            minValue: 12
          )
        );
        
      case .trailingFloatStretchHalf:
        return .init(
          horizontalPositionMode: .trailingStretch(percent: 0.5),
          marginRight: 12,
          marginBottom: .safeArea(
            additionalValue: 0,
            minValue: 12
          )
        );
        
      case .trailingFloatStretchThreeQuarters:
        return .init(
          horizontalPositionMode: .trailingStretch(percent: 0.75),
          marginRight: 12,
          marginBottom: .safeArea(
            additionalValue: 0,
            minValue: 12
          )
        );
      
      case .leadingAttachedStretchQuarter:
        return .init(
          horizontalPositionMode: .leadingStretch(percent: 0.25),
          paddingBottom: .safeArea(minValue: 12)
        );
        
      case .leadingAttachedStretchHalf:
        return .init(
          horizontalPositionMode: .leadingStretch(percent: 0.5),
          paddingBottom: .safeArea(minValue: 12)
        );
        
      case .leadingAttachedStretchThreeQuarters:
        return .init(
          horizontalPositionMode: .leadingStretch(percent: 0.75),
          paddingBottom: .safeArea(minValue: 12)
        );
      
      case .trailingAttachedStretchQuarter:
        return .init(
          horizontalPositionMode: .trailingStretch(percent: 0.25),
          paddingBottom: .safeArea(minValue: 12)
        );
        
      case .trailingAttachedStretchHalf:
        return .init(
          horizontalPositionMode: .trailingStretch(percent: 0.5),
          paddingBottom: .safeArea(minValue: 12)
        );
        
      case .trailingAttachedStretchThreeQuarters:
        return .init(
          horizontalPositionMode: .trailingStretch(percent: 0.5),
          paddingBottom: .safeArea(minValue: 12)
        );
    };
  };
};
