//
//  RNIComputableValue.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/26/23.
//

import UIKit

public struct RNIComputableSize {
  
  // MARK: - Properties
  // ------------------
  
  public let mode: RNIComputableSizeMode;
  
  public let offsetWidth: RNIComputableOffset?;
  public let offsetHeight: RNIComputableOffset?;
  
  public let minWidth: CGFloat?;
  public let minHeight: CGFloat?;
  
  public let maxWidth: CGFloat?;
  public let maxHeight: CGFloat?;
  
  // MARK: - Internal Functions
  // --------------------------
  
  func sizeWithOffsets(forSize size: CGSize) -> CGSize {
    let offsetWidth =
      self.offsetWidth?.compute(withValue: size.width);
      
    let offsetHeight =
      self.offsetHeight?.compute(withValue: size.height);
    
    return CGSize(
      width: offsetWidth ?? size.width,
      height: offsetHeight ?? size.height
    );
  };
  
  func sizeWithClamp(forSize size: CGSize) -> CGSize {
    return CGSize(
      width: size.width.clamped(
        min: self.minWidth,
        max: self.maxWidth
      ),
      height: size.height.clamped(
        min: self.minHeight,
        max: self.maxHeight
      )
    );
  };

  // MARK: - Functions
  // -----------------
    
  public func computeRaw(
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
    
  public func compute(
    withTargetSize targetSize: CGSize,
    currentSize: CGSize
  ) -> CGSize {
    let rawSize = self.computeRaw(
      withTargetSize: targetSize,
      currentSize: currentSize
    );
    
    let clampedSize = self.sizeWithClamp(forSize: rawSize);
    return self.sizeWithOffsets(forSize: clampedSize);
  };
};

extension RNIComputableSize {
  public init?(fromDict dict: NSDictionary){
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
    
    self.minWidth =
      Self.getDoubleValue(forDict: dict, withKey: "minWidth");
      
    self.minHeight =
      Self.getDoubleValue(forDict: dict, withKey: "minHeight");
      
    self.maxWidth =
      Self.getDoubleValue(forDict: dict, withKey: "maxWidth");
      
    self.maxHeight =
      Self.getDoubleValue(forDict: dict, withKey: "maxHeight");
  };
  
  public init(mode: RNIComputableSizeMode){
    self.mode = mode;
    
    self.offsetWidth = nil;
    self.offsetHeight = nil;
    self.minWidth = nil;
    self.minHeight = nil;
    self.maxWidth = nil;
    self.maxHeight = nil;
  };
  
  static private func getDoubleValue(
    forDict dict: NSDictionary,
    withKey key: String
  ) -> CGFloat? {
    guard let number = dict[key] as? NSNumber else { return nil };
    return number.doubleValue;
  };
};
