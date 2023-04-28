//
//  RNIComputableValue.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/26/23.
//

import Foundation
import JavaScriptCore


public struct RNIComputableSize {
  let mode: RNIComputableSizeMode;
  
  let offsetWidth: RNIComputableOffset?;
  let offsetHeight: RNIComputableOffset?;
  
  func computeOffsets(withSize size: CGSize) -> CGSize {
    let offsetWidth =
      self.offsetWidth?.compute(withValue: size.width);
      
    let offsetHeight =
      self.offsetHeight?.compute(withValue: size.height);
    
    return CGSize(
      width: offsetWidth ?? size.width,
      height: offsetHeight ?? size.height
    );
  };
  
  func compute(
    withTargetSize targetSize: CGSize,
    currentSize: CGSize
  ) -> CGSize {
    switch self.mode {
      case .current:
        return currentSize;
        
      case .stretch:
        return targetSize;
        
      case let .constant(constantWidth, constantHeight):
        return CGSize(width: constantWidth, height: constantHeight);
        
      case let .percent(percentWidth, percentHeight):
        return CGSize(
          width: percentWidth * targetSize.width,
          height: percentHeight * targetSize.height
        );
    };
  };
    
  func computeWithOffsets(
    withTargetSize targetSize: CGSize,
    currentSize: CGSize
  ) -> CGSize {
    let computedSize = self.compute(
      withTargetSize: targetSize,
      currentSize: currentSize
    );
    
    return self.computeOffsets(withSize: computedSize);
  };
};

extension RNIComputableSize {
  init?(fromDict dict: NSDictionary){
    guard let mode = RNIComputableSizeMode(fromDict: dict)
    else { return nil };
    
    self.mode = mode;
    
    self.offsetWidth = {
      guard let offsetRaw = dict["offsetWidth"] as? NSDictionary,
            let offset = RNIComputableOffset(fromDict: offsetRaw)
      else { return nil };
      
      return offset;
    }();
    
    self.offsetHeight = {
      guard let offsetRaw = dict["offsetHeight"] as? NSDictionary,
            let offset = RNIComputableOffset(fromDict: offsetRaw)
      else { return nil };
      
      return offset;
    }();
  };
  
  init(mode: RNIComputableSizeMode){
    self.mode = mode;
    self.offsetWidth = nil;
    self.offsetHeight = nil;
  };
};
