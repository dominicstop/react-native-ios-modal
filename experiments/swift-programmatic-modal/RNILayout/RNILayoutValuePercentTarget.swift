//
//  RNILayoutValuePercentTarget.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/8/23.
//

import UIKit

public enum RNILayoutValuePercentTarget {

  case screenSize , screenWidth , screenHeight;
  case windowSize , windowWidth , windowHeight;
  case targetSize , targetWidth , targetHeight;
  case currentSize, currentWidth, currentHeight;
  
  public func getValue(
    layoutValueContext context: RNILayoutValueContext,
    preferredSizeKey: KeyPath<CGSize, CGFloat>
  ) -> CGFloat? {
  
    switch self {
      case .screenSize:
        return context.screenSize[keyPath: preferredSizeKey];
        
      case .screenWidth:
        return context.screenSize.width;
        
      case .screenHeight:
        return context.screenSize.height;
        
      case .windowSize:
        return context.windowSize?[keyPath: preferredSizeKey];
        
      case .windowWidth:
        return context.windowSize?.width;
        
      case .windowHeight:
        return context.windowSize?.height;
        
      case .targetSize:
        return context.targetSize[keyPath: preferredSizeKey];
        
      case .targetWidth:
        return context.targetSize.width;
        
      case .targetHeight:
        return context.targetSize.height;
        
      case .currentSize:
        return context.currentSize?[keyPath: preferredSizeKey];
        
      case .currentWidth:
        return context.currentSize?.width;
        
      case .currentHeight:
        return context.currentSize?.height;
    };
  };
};
