//
//  RNIContentSizingMode.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/6/24.
//

import Foundation
import DGSwiftUtilities
import react_native_ios_utilities


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
  
  public var isSizingWidthOrHeightFromReact: Bool {
       self.isSizingHeightFromReact
    || self.isSizingWidthFromReact;
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
  
  public func updateReactSizeIfNeeded(
    forReactParent reactParentView: RNIContentViewParentDelegate,
    withNewSize newSize: CGSize
  ){
    
    switch self {
      case .sizingFromReact:
        return;
        
      case .sizingFromNative:
        let didSizeChange =
             reactParentView.intrinsicContentSize.width != newSize.width
          || reactParentView.intrinsicContentSize.height != newSize.height;
          
        guard didSizeChange else {
          return;
        };
        
        reactParentView.setSize(newSize);
        reactParentView.intrinsicContentSizeOverride = newSize;
        reactParentView.invalidateIntrinsicContentSize();
        
      case .sizingWidthFromReactAndHeightFromNative:
        let oldReactHeight = reactParentView.intrinsicContentSize.height;
        let newReactHeight = newSize.height;
        
        guard newReactHeight != oldReactHeight else {
          return;
        };
        
        reactParentView.intrinsicContentSizeOverride = .init(
          width: 0,
          height: newReactHeight
        );
        
        reactParentView.invalidateIntrinsicContentSize();
        
        #if RCT_NEW_ARCH_ENABLED
        reactParentView.requestToUpdateState(
          .init(
            minSize: .init(width: 0, height: newReactHeight),
            shouldSetMinWidth: true,
            maxSize: .init(width: 0, height: newReactHeight),
            shouldSetMaxHeight: true
          )
        );
        #else
        guard let shadowView = reactParentView.cachedShadowView else {
          return;
        };
        
        let didChange =
             CGFloat(shadowView.minHeight.value) != newReactHeight
          || CGFloat(shadowView.maxHeight.value) != newReactHeight;
          
        guard didChange else {
          return;
        };
        
        shadowView.minHeight = .init(
          value: Float(newReactHeight),
          unit: .point
        );
        
        shadowView.maxHeight = .init(
          value: Float(newReactHeight),
          unit: .point
        );
        
        shadowView.dirtyLayout();
        #endif
        
      case .sizingHeightFromReactAndWidthFromNative:
        let oldReactWidth = reactParentView.intrinsicContentSize.width;
        let newReactWidth = newSize.width;
        
        guard newReactWidth != oldReactWidth else {
          return;
        };
        
        reactParentView.intrinsicContentSizeOverride = .init(
          width: newReactWidth,
          height: 0
        );
        
        #if RCT_NEW_ARCH_ENABLED
        reactParentView.requestToUpdateState(
          .init(
            minSize: .init(width: newReactWidth, height: 0),
            shouldSetMinWidth: true,
            maxSize: .init(width: newReactWidth, height: 0),
            shouldSetMaxHeight: true
          )
        );
        #else
        guard let shadowView = reactParentView.cachedShadowView else {
          return;
        };
        
        let didChange =
             CGFloat(shadowView.minWidth.value) != newReactWidth
          || CGFloat(shadowView.maxWidth.value) != newReactWidth;
          
        guard didChange else {
          return;
        };
        
        shadowView.minWidth = .init(
          value: Float(newReactWidth),
          unit: .point
        );
        
        shadowView.maxWidth = .init(
          value: Float(newReactWidth),
          unit: .point
        );
        
        shadowView.dirtyLayout();
        #endif
    };
  };
};
