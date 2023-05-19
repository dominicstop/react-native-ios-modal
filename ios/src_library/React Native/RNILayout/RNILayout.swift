//
//  RNILayout.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/19/23.
//

import Foundation

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
  public let verticalAlignment: VerticalAlignment;
  
  public let width: RNIComputableValue;
  public let height: RNIComputableValue;
  
  public let marginLeft: CGFloat?;
  public let marginRight: CGFloat?;
  public let marginTop: CGFloat?;
  public let marginBottom: CGFloat?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var marginHorizontal: CGFloat {
    (self.marginLeft ?? 0) + (self.marginRight ?? 0)
  };
  
  public var marginVertical: CGFloat {
    (self.marginTop ?? 0) + (self.marginBottom ?? 0)
  };
  
  // MARK: - Init
  // ------------
  
  init(
    horizontalAlignment: HorizontalAlignment,
    verticalAlignment: VerticalAlignment,
    width: RNIComputableValue,
    height: RNIComputableValue,
    marginLeft: CGFloat? = nil,
    marginRight: CGFloat? = nil,
    marginTop: CGFloat? = nil,
    marginBottom: CGFloat? = nil
  ) {
    self.horizontalAlignment = horizontalAlignment;
    self.verticalAlignment = verticalAlignment;
    self.width = width;
    self.height = height;
    self.marginLeft = marginLeft;
    self.marginRight = marginRight;
    self.marginTop = marginTop;
    self.marginBottom = marginBottom;
  };
  
  // MARK: - Intermediate Functions
  // ------------------------------
  
  /// Compute Rect - Step 1
  /// * Rect with the computed size based on `size` config.
  ///
  public func computeRawRectSize(
    withTargetRect targetRect: CGRect,
    currentSize:  CGSize
  ) -> CGRect {
    let targetSize = targetRect.size;
  
    let computedSize = CGSize(
      width: self.width.compute(
        withTargetValue: targetSize.width,
        currentValue: currentSize.width
      ),
      height: self.height.compute(
        withTargetValue: targetSize.height,
        currentValue: currentSize.height
      )
    );
  
    return CGRect(origin: .zero, size: computedSize);
  };
  
  /// Compute Rect - Step 2
  /// * Rect with the computed size based on `size` config.
  ///
  /// * Rect with the origin based on `horizontalAlignment`, and
  ///   `verticalAlignment` config.
  ///
  public func computeRawRectOrigin(
    forRect rect: CGRect? = nil,
    withTargetRect targetRect: CGRect,
    currentSize: CGSize,
    ignoreXAxis: Bool = false,
    ignoreYAxis: Bool = false
  ) -> CGRect {
  
    var rect = rect ?? self.computeRawRectSize(
      withTargetRect: targetRect,
      currentSize: currentSize
    );
    
    if !ignoreXAxis {
      // Compute Origin - X
      switch self.horizontalAlignment {
        case .center:
          rect.setPoint(midX: targetRect.midX);
          
        case .left:
          rect.setPoint(minX: targetRect.minX);
          
        case .right:
          rect.setPoint(maxX: targetRect.maxX);
      };
    };
    
    if !ignoreYAxis {
      // Compute Origin - Y
      switch self.verticalAlignment {
        case .center:
          rect.setPoint(midY: targetRect.midY);
          
        case .top:
          rect.setPoint(minY: targetRect.minY);
          
        case .bottom:
          rect.setPoint(maxY: targetRect.maxY);
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
    withTargetRect targetRect: CGRect,
    currentSize: CGSize
  ) -> CGRect {
    var rect = self.computeRawRectOrigin(
      withTargetRect: targetRect,
      currentSize: currentSize
    );
    
    // Margin - X-Axis
    switch self.horizontalAlignment {
      case .left:
        guard let marginLeft = self.marginLeft else { break };
        rect.origin.x = rect.origin.x + marginLeft;
        
      case .right:
        guard let marginRight = self.marginRight else { break };
        rect.origin.x = rect.origin.x - marginRight;
        
      case .center:
        if case .stretch = self.width.mode {
          rect.size.width = rect.size.width - self.marginHorizontal;
          
          // re-compute origin
          rect = self.computeRawRectOrigin(
            forRect: rect,
            withTargetRect: targetRect,
            currentSize: currentSize,
            ignoreYAxis: true
          );
        };
    };
    
    // Margin - Y-Axis
    switch self.verticalAlignment {
      case .top:
        guard let marginTop = self.marginTop else { break };
        rect.origin.y = rect.origin.y + marginTop;
        
      case .bottom:
        guard let marginBottom = self.marginBottom else { break };
        rect.origin.y = rect.origin.y - marginBottom;
        
      case .center:
        if case .stretch = self.height.mode {
          rect.size.height = rect.size.height - self.marginVertical;
          
          // re-compute origin
          rect = self.computeRawRectOrigin(
            forRect: rect,
            withTargetRect: targetRect,
            currentSize: currentSize,
            ignoreXAxis: true
          );
        };
    };
    
    return rect;
  };
};
