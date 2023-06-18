//
//  RNILayout.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/19/23.
//

import UIKit

public struct RNILayout {
  
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
  
  public func computeMargins(
    usingLayoutValueContext context: RNILayoutValueContext
  ) -> (
    left  : CGFloat?,
    right : CGFloat?,
    top   : CGFloat?,
    bottom: CGFloat?,
    
    horizontal: CGFloat,
    vertical  : CGFloat
  ) {
    let computedMarginLeft = self.marginLeft?.computeValue(
      usingLayoutValueContext: context,
      preferredSizeKey: \.width
    );
    
    let computedMarginRight = self.marginRight?.computeValue(
      usingLayoutValueContext: context,
      preferredSizeKey: \.width
    );
    
    let computedMarginTop = self.marginTop?.computeValue(
      usingLayoutValueContext: context,
      preferredSizeKey: \.height
    );
    
    let computedMarginBottom = self.marginBottom?.computeValue(
      usingLayoutValueContext: context,
      preferredSizeKey: \.height
    );
    
    let computedMarginHorizontal =
      (computedMarginLeft ?? 0) + (computedMarginRight ?? 0);
      
    let computedMarginVertical =
      (computedMarginTop ?? 0) + (computedMarginBottom ?? 0);
      
    return (
      left  : computedMarginLeft   ?? 0,
      right : computedMarginRight  ?? 0,
      top   : computedMarginTop    ?? 0,
      bottom: computedMarginBottom ?? 0,
      
      horizontal: computedMarginHorizontal,
      vertical  : computedMarginVertical
    );
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
    
    let computedMargins = self.computeMargins(usingLayoutValueContext: context);
   
    // Margin - X-Axis
    switch self.horizontalAlignment {
      case .left:
        guard let marginLeft = computedMargins.left else { break };
        rect.origin.x = rect.origin.x + marginLeft;
        
      case .right:
        guard let marginRight = computedMargins.right else { break };
        rect.origin.x = rect.origin.x - marginRight;
        
      case .center:
        break;
    };
    
    // Margin - Y-Axis
    switch self.verticalAlignment {
      case .top:
        guard let marginTop = computedMargins.top else { break };
        rect.origin.y = rect.origin.y + marginTop;
        
      case .bottom:
        guard let marginBottom = computedMargins.bottom else { break };
        rect.origin.y = rect.origin.y - marginBottom;
        
      case .center:
        break;
    };
    
    let shouldRecomputeXAxis: Bool = {
      switch self.width.mode {
        case .stretch: return abs(computedMargins.horizontal) < rect.width;
        default: return false;
      };
    }();
    
    let shouldRecomputeYAxis: Bool = {
      switch self.height.mode {
        case .stretch: return abs(computedMargins.vertical) < rect.height;
        default: return false;
      };
    }();
    
    if shouldRecomputeXAxis {
      rect.size.width = rect.size.width - computedMargins.horizontal;
    };
    
    if shouldRecomputeYAxis {
      rect.size.height = rect.size.height - computedMargins.vertical;
    };
    
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
