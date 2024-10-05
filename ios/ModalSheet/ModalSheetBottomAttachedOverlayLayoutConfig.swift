//
//  ModalSheetBottomAttachedOverlayLayoutConfig.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/6/24.
//

import Foundation


public struct ModalSheetBottomAttachedOverlayLayoutConfig {

  public var horizontalPositionMode: ViewPositionHorizontal;
  
  public var marginLeft: CGFloat;
  public var marginRight: CGFloat;
  
  public var marginBottom: ModalSheetBottomDistance;
  public var paddingBottom: ModalSheetBottomDistance;
  
  init(
    horizontalPositionMode: ViewPositionHorizontal,
    marginLeft: CGFloat = 0,
    marginRight: CGFloat = 0,
    marginBottom: ModalSheetBottomDistance = .zero,
    paddingBottom: ModalSheetBottomDistance = .zero
  ) {
    self.horizontalPositionMode = horizontalPositionMode;
    self.marginLeft = marginLeft;
    self.marginRight = marginRight;
    self.marginBottom = marginBottom;
    self.paddingBottom = paddingBottom;
  };
  
  public func createExternalHorizontalConstraints(
    forView childView: UIView,
    attachingTo parentView: UIView,
    preferToUseWidthConstraint: Bool = false
  ) -> [NSLayoutConstraint] {
  
    let window =
         childView.window
      ?? parentView.window
      ?? UIApplication.shared.activeWindow;
  
    return self.horizontalPositionMode.createHorizontalConstraints(
      forView: childView,
      attachingTo: parentView,
      withWindow: window,
      marginLeading: self.marginLeft,
      marginTrailing: self.marginRight,
      preferToUseWidthConstraint: preferToUseWidthConstraint
    );
  };
  
  public func createExternalBottomConstraints(
    forView childView: UIView,
    attachingTo parentView: UIView
  ) -> [NSLayoutConstraint] {
  
    self.marginBottom.createBottomConstraint(
      forView: childView,
      attachingTo: parentView
    );
  };
  
  public func createInternalBottomConstraint(
    forView childView: UIView,
    attachingTo parentView: UIView
  ) -> [NSLayoutConstraint] {
  
    self.paddingBottom.createBottomConstraint(
      forView: childView,
      attachingTo: parentView
    );
  };
};
