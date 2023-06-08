//
//  RNILayoutPreset.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/23/23.
//

import UIKit

enum RNILayoutPreset {
  case offscreenBottom,
       offscreenTop,
       offscreenLeft,
       offscreenRight;
       
  case halfOffscreenBottom,
       halfOffscreenTop,
       halfOffscreenLeft,
       halfOffscreenRight;
      
  case edgeBottom,
       edgeTop,
       edgeLeft,
       edgeRight;
       
  case fitScreen,
       fitScreenHorizontally,
       fitScreenVertically;
       
  case center;
  
  case layoutConfig(_ config: RNILayout);
  
  // MARK: Functions
  // ---------------
  
  func getLayoutConfig(
    fromBaseLayoutConfig baseLayoutConfig: RNILayout
  ) -> RNILayout {
  
    switch self {
      case .offscreenBottom:
        return .init(
          derivedFrom: baseLayoutConfig
        );
      
      case .offscreenTop:
        return .init(
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .top,
          marginTop: .percent(
            relativeTo: .currentHeight,
            percentValue: -1
          )
        );
      
      case .offscreenLeft:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .left,
          marginLeft: .percent(
            relativeTo: .currentWidth,
            percentValue: -1
          )
        );
      
      case .offscreenRight:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .right,
          marginRight: .percent(
            relativeTo: .currentWidth,
            percentValue: 1
          )
        );
      
      case .edgeBottom:
        return .init(
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .bottom
        );
        
      case .halfOffscreenBottom:
        return .init(
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .top,
          marginTop: .percent(
            relativeTo: .currentHeight,
            percentValue: 0.5
          )
        );
      
      case .halfOffscreenTop:
        return .init(
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .top,
          marginTop: .percent(
              relativeTo: .currentHeight,
              percentValue: -0.5
            )
        );
        
      case .halfOffscreenLeft:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .left,
          marginLeft: .percent(
            relativeTo: .currentWidth,
            percentValue: -0.5
          )
        );
        
      case .halfOffscreenRight:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .right,
          marginRight: .percent(
            relativeTo: .currentWidth,
            percentValue: 0.5
          )
        );
      
      case .edgeTop:
        return .init(
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .top
        );
      
      case .edgeLeft:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .left
        );
      
      case .edgeRight:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .right
        );
      
      case .center:
        return .init(
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .center
        );
        
      case .fitScreen:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .center,
          verticalAlignment: .center,
          width: RNILayoutValue(
            mode: .stretch
          ),
          height: RNILayoutValue(
            mode: .stretch
          )
        );
        
      case .fitScreenHorizontally:
        return .init(
          derivedFrom: baseLayoutConfig,
          width: RNILayoutValue(
            mode: .stretch
          )
        );
        
      case .fitScreenVertically:
        return .init(
          derivedFrom: baseLayoutConfig,
          height: RNILayoutValue(
            mode: .stretch
          )
        );
      
      case let .layoutConfig(config):
        return config;
    };
  };
};


