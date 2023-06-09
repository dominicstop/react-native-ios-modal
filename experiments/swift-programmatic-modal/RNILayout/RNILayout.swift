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
  
  public let marginLeft  : RNILayoutValueMode?;
  public let marginRight : RNILayoutValueMode?;
  public let marginTop   : RNILayoutValueMode?;
  public let marginBottom: RNILayoutValueMode?;
  
  // MARK: - Init
  // ------------
  
  init(
    horizontalAlignment: HorizontalAlignment,
    verticalAlignment  : VerticalAlignment,
    
    width : RNILayoutValue,
    height: RNILayoutValue,
    
    marginLeft  : RNILayoutValueMode? = nil,
    marginRight : RNILayoutValueMode? = nil,
    marginTop   : RNILayoutValueMode? = nil,
    marginBottom: RNILayoutValueMode? = nil
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
    
    marginLeft  : RNILayoutValueMode? = nil,
    marginRight : RNILayoutValueMode? = nil,
    marginTop   : RNILayoutValueMode? = nil,
    marginBottom: RNILayoutValueMode? = nil
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
          rect.setPoint(maxY: context.targetRect.maxY);
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
    
    let computedMarginLeft = self.marginLeft?.compute(
      usingLayoutValueContext: context,
      preferredSizeKey: \.width
    );
    
    let computedMarginRight = self.marginRight?.compute(
      usingLayoutValueContext: context,
      preferredSizeKey: \.width
    );
    
    let computedMarginTop = self.marginTop?.compute(
      usingLayoutValueContext: context,
      preferredSizeKey: \.height
    );
    
    let computedMarginBottom = self.marginBottom?.compute(
      usingLayoutValueContext: context,
      preferredSizeKey: \.height
    );
    
    let computedMarginHorizontal =
      (computedMarginLeft ?? 0) + (computedMarginRight ?? 0);
      
    let computedMargiVertical =
      (computedMarginTop ?? 0) + (computedMarginBottom ?? 0);
   
    // Margin - X-Axis
    switch self.horizontalAlignment {
      case .left:
        guard let marginLeft = computedMarginLeft else { break };
        rect.origin.x = rect.origin.x + marginLeft;
        
      case .right:
        guard let marginRight = computedMarginRight else { break };
        rect.origin.x = rect.origin.x - marginRight;
        
      case .center:
        if case .stretch = self.width.mode {
          rect.size.width = rect.size.width - computedMarginHorizontal;
          
          // re-compute origin
          rect = self.computeRawRectOrigin(
            usingLayoutValueContext: context,
            forRect: rect,
            ignoreYAxis: true
          );
        };
    };
    
    // Margin - Y-Axis
    switch self.verticalAlignment {
      case .top:
        guard let marginTop = computedMarginTop else { break };
        rect.origin.y = rect.origin.y + marginTop;
        
      case .bottom:
        guard let marginBottom = computedMarginBottom else { break };
        rect.origin.y = rect.origin.y - marginBottom;
        
      case .center:
        if case .stretch = self.height.mode {
          rect.size.height = rect.size.height - computedMargiVertical;

          // re-compute origin
          rect = self.computeRawRectOrigin(
            usingLayoutValueContext: context,
            forRect: rect,
            ignoreXAxis: true
          );
        };
    };
    
    return rect;
  };
};
