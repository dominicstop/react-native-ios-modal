//
//  RNIContentSizingMode.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/6/24.
//

import Foundation
import DGSwiftUtilities


/// Should this really be an enum?
/// Wouldn't it be better if this was an `OptionSet`?
///
public enum RNIContentSizingMode: String {
  case sizingFromReact;
  case sizingFromNative;
  
  case sizingWidthFromReactAndHeightFromNative;
  case sizingHeightFromReactAndWidthFromNative;
  
  // MARK: Computed Properties
  // -------------------------
  
  public var isSizingHeightFromNative: Bool {
    switch self {
      case .sizingFromNative, .sizingWidthFromReactAndHeightFromNative:
        return true;
    
      default:
        return false;
    };
  };
  
  public var isSizingWidthFromNative: Bool {
    switch self {
      case .sizingFromNative, .sizingHeightFromReactAndWidthFromNative:
        return true;
    
      default:
        return false;
    };
  };
  
  public var isSizingHeightFromReact: Bool {
    switch self {
      case .sizingFromReact, .sizingHeightFromReactAndWidthFromNative:
        return true;
    
      default:
        return false;
    };
  };
  
  public var isSizingWidthFromReact: Bool {
    switch self {
      case .sizingFromReact, .sizingWidthFromReactAndHeightFromNative:
        return true;
    
      default:
        return false;
    };
  };
  
  // MARK: Functions
  // ---------------
  
  public func derivedSizingMode(
    isSizingWidthFromNative: Bool,
    isSizingHeightFromNative: Bool
  ) -> Self {
  
    switch (isSizingWidthFromNative, isSizingHeightFromNative) {
      case (true, true):
        return .sizingFromNative;
        
      case (false, true):
        return .sizingWidthFromReactAndHeightFromNative;
        
      case (true, false):
        return .sizingHeightFromReactAndWidthFromNative;
        
      case (false, false):
        return .sizingFromReact;
    };
  };
  
  public func derivedSizingMode(
    fromHorizontalViewPosition horizontalViewPosition: ViewPositionHorizontal,
    isSizingHeightFromNative: Bool
  ) -> Self {
    
    self.derivedSizingMode(
      isSizingWidthFromNative: horizontalViewPosition.willSatisfyWidthConstraint,
      isSizingHeightFromNative: isSizingHeightFromNative
    );
  };
  
  public func derivedSizingMode(
    fromHorizontalAlignmentPosition horizontalAlignmentPosition: HorizontalAlignmentPosition,
    isSizingHeightFromNative: Bool
  ) -> Self {
    
    self.derivedSizingMode(
      isSizingWidthFromNative: horizontalAlignmentPosition.isStretching,
      isSizingHeightFromNative: isSizingHeightFromNative
    );
  };
  
  public func derivedSizingMode(
    fromVerticalAlignmentPosition verticalAlignmentPosition: VerticalAlignmentPosition,
    isSizingWidthFromNative: Bool
  ) -> Self {
    
    self.derivedSizingMode(
      isSizingWidthFromNative: isSizingWidthFromNative,
      isSizingHeightFromNative: verticalAlignmentPosition.isStretching
    );
  };
  
  public func derivedSizingMode(
    fromHorizontalAlignmentPosition horizontalAlignmentPosition: HorizontalAlignmentPosition,
    verticalAlignmentPosition: VerticalAlignmentPosition
  ) -> Self {
    
    self.derivedSizingMode(
      isSizingWidthFromNative: horizontalAlignmentPosition.isStretching,
      isSizingHeightFromNative: verticalAlignmentPosition.isStretching
    );
  };
};
