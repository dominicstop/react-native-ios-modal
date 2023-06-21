//
//  RNILayoutMargin.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/22/23.
//

import Foundation

public struct RNILayoutMargins {
  public var left  : CGFloat;
  public var right : CGFloat;
  public var top   : CGFloat;
  public var bottom: CGFloat;
  
  public var horizontal: CGFloat {
    self.left + self.right;
  };
  
  public var vertical: CGFloat {
    self.top + self.bottom;
  };
  
  public var hasNegativeHorizontalMargins: Bool {
   self.left < 0 || self.right < 0;
  };
  
  public var hasNegativeVerticalMargins: Bool {
   self.top < 0 || self.bottom < 0;
  };
  
  init(
    left: CGFloat? = nil,
    right: CGFloat? = nil,
    top: CGFloat? = nil,
    bottom: CGFloat? = nil
  ) {
    self.left   = left   ?? 0;
    self.right  = right  ?? 0;
    self.top    = top    ?? 0;
    self.bottom = bottom ?? 0;
  }
};

public extension RNILayoutMargins {

  init(
    usingLayoutConfig layoutConfig: RNILayout,
    usingLayoutValueContext context: RNILayoutValueContext
  ) {
    self.left = layoutConfig.marginLeft?.computeValue(
      usingLayoutValueContext: context,
      preferredSizeKey: \.width
    ) ?? 0;
    
    self.right = layoutConfig.marginRight?.computeValue(
      usingLayoutValueContext: context,
      preferredSizeKey: \.width
    ) ?? 0;
    
    self.top = layoutConfig.marginTop?.computeValue(
      usingLayoutValueContext: context,
      preferredSizeKey: \.height
    ) ?? 0;
    
    self.bottom = layoutConfig.marginBottom?.computeValue(
      usingLayoutValueContext: context,
      preferredSizeKey: \.height
    ) ?? 0;
  };
};
