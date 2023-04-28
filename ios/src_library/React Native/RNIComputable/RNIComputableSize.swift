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
      self.offsetWidth?.compute(withValue: size.width) ?? 0;
      
    let offsetHeight =
      self.offsetHeight?.compute(withValue: size.height) ?? 0;
    
    return CGSize(
      width: size.width + offsetWidth,
      height: size.height + offsetHeight
    );
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
