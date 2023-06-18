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
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .bottom,
          marginTop: .constant(0),
          marginBottom: .percent(
            relativeTo: .currentHeight,
            percentValue: -1
          )
        );
      
      case .offscreenTop:
        return .init(
          derivedFrom: baseLayoutConfig,
          verticalAlignment: .top,
          marginTop: .percent(
            relativeTo: .currentHeight,
            percentValue: -1
          ),
          marginBottom: .constant(0)
        );
      
      case .offscreenLeft:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .left,
          marginLeft: .percent(
            relativeTo: .currentWidth,
            percentValue: -1
          ),
          marginRight: .constant(0)
        );
      
      case .offscreenRight:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .right,
          marginLeft: .constant(0),
          marginRight: .percent(
            relativeTo: .currentWidth,
            percentValue: -1
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
          marginTop: .constant(0),
          marginBottom: .percent(
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
          ),
          marginBottom: .constant(0)
        );
        
      case .halfOffscreenLeft:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .left,
          marginLeft: .percent(
            relativeTo: .currentWidth,
            percentValue: -0.5
          ),
          marginRight: .constant(0)
        );
        
      case .halfOffscreenRight:
        return .init(
          derivedFrom: baseLayoutConfig,
          horizontalAlignment: .right,
          marginLeft: .constant(0),
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
          ),
          marginLeft: .constant(0),
          marginRight: .constant(0),
          marginTop: .constant(0),
          marginBottom: .constant(0)
        );
        
      case .fitScreenHorizontally:
        return .init(
          derivedFrom: baseLayoutConfig,
          width: RNILayoutValue(
            mode: .stretch
          ),
          marginLeft: .constant(0),
          marginRight: .constant(0)
        );
        
      case .fitScreenVertically:
        return .init(
          derivedFrom: baseLayoutConfig,
          height: RNILayoutValue(
            mode: .stretch
          ),
          marginTop: .constant(0),
          marginBottom: .constant(0)
        );
      
      case let .layoutConfig(config):
        return config;
    };
  };
};


