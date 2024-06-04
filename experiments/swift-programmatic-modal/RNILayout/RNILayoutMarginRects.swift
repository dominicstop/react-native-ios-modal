//
//  RNILayoutMarginRects.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/22/23.
//

import Foundation

public struct RNILayoutMarginRects {

  var left  : CGRect;
  var right : CGRect;
  var top   : CGRect;
  var bottom: CGRect;
  
  init(
    margins: RNILayoutMargins,
    viewRect: CGRect,
    targetRect: CGRect
  ) {
    self.left = CGRect(
      origin: .zero,
      size: CGSize(
        width: margins.left,
        height: targetRect.height
      )
    );
    
    self.right = CGRect(
      x: targetRect.maxX - margins.right,
      y: 0,
      width: margins.right,
      height: targetRect.height
    );
    
    self.top = CGRect(
      origin: .zero,
      size: CGSize(
        width: targetRect.width,
        height: margins.top
      )
    );
    
    self.bottom = CGRect(
      x: 0,
      y: targetRect.maxY - margins.bottom,
      width: targetRect.width,
      height: margins.bottom
    );
  };
};
