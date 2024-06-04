//
//  RNILayout.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/19/23.
//

import UIKit

public struct RNILayout {

  // MARK: - Public Types
  // --------------------
  
  public enum HorizontalAlignment: String {
    case left, right, center;
  };
  
  public enum VerticalAlignment: String {
    case top, bottom, center;
  };
  
  // MARK: - Properties
  // ------------------
  
  public let horizontalAlignment: HorizontalAlignment;
  public let verticalAlignment  : VerticalAlignment;
  
  public let width : RNILayoutValue;
  public let height: RNILayoutValue;
  
  public let marginLeft  : RNILayoutValue?;
  public let marginRight : RNILayoutValue?;
  public let marginTop   : RNILayoutValue?;
  public let marginBottom: RNILayoutValue?;
  
  // MARK: - Init
  // ------------
  
  init(
    horizontalAlignment: HorizontalAlignment,
    verticalAlignment  : VerticalAlignment,
    
    width : RNILayoutValue,
    height: RNILayoutValue,
    
    marginLeft  : RNILayoutValue? = nil,
    marginRight : RNILayoutValue? = nil,
    marginTop   : RNILayoutValue? = nil,
    marginBottom: RNILayoutValue? = nil
  ) {
    self.horizontalAlignment = horizontalAlignment;
    self.verticalAlignment   = verticalAlignment;
    
    self.width  = width;
    self.height = height;
    
    self.marginLeft   = marginLeft;
    self.marginRight  = marginRight;
    self.marginTop    = marginTop;
    self.marginBottom = marginBottom;
  };
  
  init(
    derivedFrom prev: Self,
    horizontalAlignment: HorizontalAlignment? = nil,
    verticalAlignment  : VerticalAlignment? = nil,
    
    width : RNILayoutValue? = nil,
    height: RNILayoutValue? = nil,
    
    marginLeft  : RNILayoutValue? = nil,
    marginRight : RNILayoutValue? = nil,
    marginTop   : RNILayoutValue? = nil,
    marginBottom: RNILayoutValue? = nil
  ) {
    self.horizontalAlignment = horizontalAlignment ?? prev.horizontalAlignment;
    self.verticalAlignment   = verticalAlignment   ?? prev.verticalAlignment;
    
    self.width  = width  ?? prev.width;
    self.height = height ?? prev.height;
    
    self.marginLeft   = marginLeft   ?? prev.marginLeft;
    self.marginRight  = marginRight  ?? prev.marginRight;
    self.marginTop    = marginTop    ?? prev.marginTop;
    self.marginBottom = marginBottom ?? prev.marginBottom;
  };
  
  // MARK: - Intermediate Functions
  // ------------------------------
  
  /// Compute Rect - Step 1
  /// * Rect with the computed size based on `size` config.
  ///
  public func computeRawRectSize(
    usingLayoutValueContext context: RNILayoutValueContext
  ) -> CGSize {
  
    let computedWidth = self.width.computeValue(
      usingLayoutValueContext: context,
      preferredSizeKey: \.width
    );
    
    let computedHeight = self.height.computeValue(
      usingLayoutValueContext: context,
      preferredSizeKey: \.height
    );
    
    return CGSize(
      width : computedWidth  ?? 0,
      height: computedHeight ?? 0
    );
  };
  
  /// Compute Rect - Step 2
  /// * Rect with the origin based on `horizontalAlignment`, and
  ///   `verticalAlignment` config.
  ///
  public func computeRawRectOrigin(
    usingLayoutValueContext context: RNILayoutValueContext,
    forRect rect: CGRect? = nil,
    ignoreXAxis: Bool = false,
    ignoreYAxis: Bool = false
  ) -> CGRect {
  
    let origin = rect?.origin ?? .zero;
    let size = rect?.size ?? context.currentSize ?? .zero;
    
    var rect = CGRect(origin: origin, size: size);
    
    if !ignoreXAxis {
      // Compute Origin - X
      switch self.horizontalAlignment {
        case .center:
          rect.setPoint(midX: context.targetRect.midX);
          
        case .left:
          rect.setPoint(minX: context.targetRect.minX);
          
        case .right:
          rect.setPoint(maxX: context.targetRect.maxX);
      };
    };
    
    if !ignoreYAxis {
      // Compute Origin - Y
      switch self.verticalAlignment {
        case .center:
          rect.setPoint(midY: context.targetRect.midY);
          
        case .top:
          rect.setPoint(minY: context.targetRect.minY);
          
        case .bottom:
          rect.origin.y = context.targetRect.height - rect.height;
      };
    };
    
    return rect;
  };
  
  // MARK: - Functions
  // -----------------
  
  /// Compute Rect - Step 3
  /// * Rect with the computed size based on `size` config.
  ///
  /// * Rect with the origin based on `horizontalAlignment`, and
  ///   `verticalAlignment` config.
  ///
  /// * Rect with margins applied to it based on the margin-related properties
  ///
  public func computeRect(
    usingLayoutValueContext baseContext: RNILayoutValueContext
  ) -> CGRect {
  
    let computedSize = self.computeRawRectSize(
      usingLayoutValueContext: baseContext
    );
    
    let context = RNILayoutValueContext(
      derivedFrom: baseContext,
      currentSize: computedSize
    );
  
    var rect = self.computeRawRectOrigin(usingLayoutValueContext: context);
    
    let computedMargins = RNILayoutMargins(
      usingLayoutConfig: self,
      usingLayoutValueContext: context
    );
    
    let marginRects = RNILayoutMarginRects(
      margins: computedMargins,
      viewRect: rect,
      targetRect: context.targetRect
    );
    
    let shouldResizeWidth: Bool = {
      if computedMargins.horizontal == 0 {
        return false;
      };
      
      if self.width.mode == .stretch &&
         !computedMargins.hasNegativeHorizontalMargins {
         
        return true;
      };
    
      return (
           computedMargins.left       > 0
        && computedMargins.right      > 0
        && computedMargins.horizontal > rect.width
      );
    }();
       
    let shouldResizeHeight: Bool = {
      if computedMargins.vertical == 0 {
        return false;
      };
      
      if self.height.mode == .stretch &&
         !computedMargins.hasNegativeVerticalMargins {
         
        return true;
      };
    
      return (
           computedMargins.top > 0
        && computedMargins.bottom > 0
        && computedMargins.vertical > rect.height
      );
    }();

    if shouldResizeWidth {
      let offsetWidth = self.width.mode == .stretch
        ? computedMargins.horizontal
        : computedMargins.horizontal - rect.width;
      
      rect.size.width -= offsetWidth;
    };
    
    if shouldResizeHeight {
      let offsetHeight = self.height.mode == .stretch
        ? computedMargins.vertical
        : computedMargins.vertical - rect.height;
      
      rect.size.height -= offsetHeight;
    };
    
    let shouldOffsetX: Bool = {
      switch self.horizontalAlignment {
        case .left, .right:
          return true;
          
        case .center:
          return
            marginRects.left.maxX > rect.minX ||
            marginRects.right.minX < rect.maxX;
      };
    }();
    
    let shouldOffsetY: Bool = {
      switch self.verticalAlignment {
        case .top, .bottom:
          return true;
          
        case .center:
          return
            marginRects.top.maxY > rect.minY ||
            marginRects.bottom.minY < rect.maxY;
      };
    }();
      
    if shouldOffsetX {
      let offsetLeft = computedMargins.left - rect.minX;
      
      let shouldApplyNegativeLeftMargin =
        self.horizontalAlignment == .left &&
        computedMargins.left < 0;
      
      if offsetLeft > 0 {
        rect.origin.x += offsetLeft;
        
      } else if shouldApplyNegativeLeftMargin {
        rect.origin.x -= abs(computedMargins.left);
      };
      
      let offsetRight: CGFloat = {
        let marginRightX = context.targetRect.maxX - computedMargins.right;
        return rect.maxX - marginRightX;
      }();
      
      let shouldApplyNegativeRightMargin =
        self.horizontalAlignment == .right &&
        computedMargins.right < 0;
        
      if offsetRight > 0 {
        rect.origin.x -= offsetRight;
        
      } else if shouldApplyNegativeRightMargin {
        rect.origin.x += abs(computedMargins.right);
      };
    };
    
    if shouldOffsetY {
      let offsetTop = computedMargins.top - rect.minY;
      
      let shouldApplyNegativeTopMargin =
        self.verticalAlignment == .top &&
        computedMargins.top < 0;
      
      if offsetTop > 0 {
        rect.origin.y += offsetTop;
        
      } else if shouldApplyNegativeTopMargin {
        rect.origin.y -= abs(computedMargins.top); 
      };
      
      let offsetBottom: CGFloat = {
        let marginBottomY = context.targetRect.maxY - computedMargins.bottom;
        return rect.maxY - marginBottomY;
      }();
      
      let shouldApplyNegativeBottomMargin =
        self.verticalAlignment == .bottom &&
        computedMargins.bottom < 0;
        
      if offsetBottom > 0 {
        rect.origin.y -= offsetBottom;
        
      } else if shouldApplyNegativeBottomMargin {
         rect.origin.y += abs(computedMargins.bottom);
      };
    };
    
    let shouldRecomputeXAxis: Bool = {
      switch self.horizontalAlignment {
        case .center:
          return !shouldOffsetX && shouldResizeWidth
      
        default:
          return false;
      };
    }();
    
    let shouldRecomputeYAxis: Bool = {
      switch self.verticalAlignment {
        case .center:
          return !shouldOffsetY && shouldResizeHeight
      
        default:
          return false;
      };
    }();
    
    if shouldRecomputeXAxis || shouldRecomputeYAxis {
      // re-compute origin
      rect = self.computeRawRectOrigin(
        usingLayoutValueContext: context,
        forRect: rect,
        ignoreXAxis: !shouldRecomputeXAxis,
        ignoreYAxis: !shouldRecomputeYAxis
      );
    };
    
    return rect;
  };
};
