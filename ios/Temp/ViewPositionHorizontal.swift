//
//  ViewPositionHorizontal.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/4/24.
//

import Foundation
import DGSwiftUtilities

public enum ViewPositionHorizontal {

  public typealias Identifier = ViewPositionHorizontalIdentifier;

  // MARK: - Case Members
  // --------------------
  
  case stretch;
  case stretchPercent(percent: CGFloat);
  
  case stretchWindow;
  case stretchWindowPercent(percent: CGFloat);
  
  case center;
  case centerStretch(percent: CGFloat);
  case centerFixedWidth(constant: CGFloat);
  
  case leading;
  case leadingStretch(percent: CGFloat);
  case leadingFixedWidth(constant: CGFloat);
  
  case trailing;
  case trailingStretch(percent: CGFloat);
  case trailingFixedWidth(constant: CGFloat);
  
  // MARK: Computed Properties
  // -------------------------
  
  public var percentMultiplier: CGFloat?  {
    switch self {
      case let .stretchPercent(percent):
        return percent;
        
      case let .stretchWindowPercent(percent):
        return percent;
        
      case let .centerStretch(percent):
        return percent;
        
      case let .leadingStretch(percent):
        return percent;
        
      case let .trailingStretch(percent):
        return percent;
        
      default:
        return nil;
    };
  };
  
  public var constantWidth: CGFloat? {
    switch self {
      case let .centerFixedWidth(constant):
        return constant;

      case let .leadingFixedWidth(constant):
        return constant;
        
      case let .trailingFixedWidth(constant):
        return constant;
      
      default:
        return nil;
    };
  };
  
  public var hasImplicitWidth: Bool {
    switch self {
      case .stretch, .stretchPercent,
           .stretchWindow, .stretchWindowPercent,
           .centerStretch, .leadingStretch, .trailingStretch:
        return true;
        
      default:
        return false;
    };
  };
  
  public var hasExplicitWidth: Bool {
    self.constantWidth != nil;
  };
  
  /// `false` if the width is ambiguous
  public var willSatisfyWidthConstraint: Bool {
       self.hasImplicitWidth
    || self.hasExplicitWidth;
  };
  
  // MARK: Functions
  // ---------------
  
  public func createHorizontalConstraintsGrouped(
    forView childView: UIView,
    attachingTo parentView: UIView,
    withWindow window: UIWindow?,
    marginLeading: CGFloat = 0,
    marginTrailing: CGFloat = 0,
    preferToUseWidthConstraint: Bool = false
  ) -> (
    constraintLeading    : NSLayoutConstraint?,
    constraintTrailing   : NSLayoutConstraint?,
    constraintWidth      : NSLayoutConstraint?,
    constraintCenterX    : NSLayoutConstraint?,
    constraintLeadingMin : NSLayoutConstraint?,
    constraintTrailingMin: NSLayoutConstraint?
  ) {
  
    var constraintLeading    : NSLayoutConstraint?;
    var constraintTrailing   : NSLayoutConstraint?;
    var constraintWidth      : NSLayoutConstraint?;
    var constraintCenterX    : NSLayoutConstraint?;
    var constraintLeadingMin : NSLayoutConstraint?;
    var constraintTrailingMin: NSLayoutConstraint?;
    
    let marginTotal = marginLeading + marginTrailing;
    
    switch (self, preferToUseWidthConstraint) {
      case (.stretch, false):
        constraintLeading = childView.leadingAnchor.constraint(
          equalTo: parentView.leadingAnchor,
          constant: marginLeading
        );
        
        constraintTrailing = childView.trailingAnchor.constraint(
          equalTo: parentView.trailingAnchor,
          constant: -marginTrailing
        );
        
      case (.stretch, true):
        constraintWidth = childView.widthAnchor.constraint(
          equalTo: parentView.widthAnchor,
          constant: -marginTotal
        );
        
        constraintCenterX = childView.centerXAnchor.constraint(
          equalTo: parentView.centerXAnchor
        );
        
      case (let .stretchPercent(percent), _):
        if marginTotal == 0 {
          constraintWidth = childView.widthAnchor.constraint(
            equalTo: parentView.widthAnchor,
            multiplier: percent
          );
          
          constraintCenterX = childView.centerXAnchor.constraint(
            equalTo: parentView.centerXAnchor
          );
          
        } else {
          constraintWidth = childView.widthAnchor.constraint(
            equalTo: parentView.widthAnchor,
            multiplier: percent
          );
          
          constraintLeadingMin = childView.leadingAnchor.constraint(
            greaterThanOrEqualTo: parentView.leadingAnchor,
            constant: marginLeading
          );
          
          constraintTrailingMin = childView.trailingAnchor.constraint(
            greaterThanOrEqualTo: parentView.trailingAnchor,
            constant: marginTrailing
          );
          
          constraintWidth!.priority = .required;
          constraintLeadingMin!.priority = .defaultHigh;
          constraintTrailingMin!.priority = .defaultHigh;
        };
        
      case (.stretchWindow, false):
        let parentViewAdj = window ?? parentView;
        
        constraintLeading = childView.leadingAnchor.constraint(
          equalTo: parentViewAdj.leadingAnchor,
          constant: marginLeading
        );
        
        constraintTrailing = childView.trailingAnchor.constraint(
          equalTo: parentViewAdj.trailingAnchor,
          constant: marginTrailing
        );
        
      case (.stretchWindow, true):
        let parentViewAdj = window ?? parentView;
        
        constraintWidth = childView.widthAnchor.constraint(
          equalTo: parentViewAdj.widthAnchor,
          constant: -marginTotal
        );
        
        constraintCenterX = childView.centerXAnchor.constraint(
          equalTo: parentViewAdj.centerXAnchor
        );
        
      case (let .stretchWindowPercent(percent), _):
        let parentViewAdj = window ?? parentView;
        
        if marginTotal == 0 {
          constraintWidth = childView.widthAnchor.constraint(
            equalTo: parentViewAdj.widthAnchor,
            multiplier: percent
          );
          
          constraintCenterX = childView.centerXAnchor.constraint(
            equalTo: parentViewAdj.centerXAnchor
          );
          
        } else {
          constraintWidth = childView.widthAnchor.constraint(
            equalTo: parentViewAdj.widthAnchor,
            multiplier: percent
          );
          
          constraintLeadingMin = childView.leadingAnchor.constraint(
            greaterThanOrEqualTo: parentViewAdj.leadingAnchor,
            constant: marginLeading
          );
          
          constraintTrailingMin = childView.trailingAnchor.constraint(
            greaterThanOrEqualTo: parentViewAdj.trailingAnchor,
            constant: marginTrailing
          );
          
          constraintWidth!.priority = .required;
          constraintLeadingMin!.priority = .defaultHigh;
          constraintTrailingMin!.priority = .defaultHigh;
        };
        
      case (.center, _):
        // TODO: handle margins
        constraintCenterX = childView.centerXAnchor.constraint(
          equalTo: parentView.centerXAnchor
        );
        
      case (let .centerStretch(percent), _):
        // TODO: handle margins
        constraintWidth = childView.widthAnchor.constraint(
          equalTo: parentView.widthAnchor,
          multiplier: percent,
          constant: -marginTotal
        );
        
        constraintCenterX = childView.centerXAnchor.constraint(
          equalTo: parentView.centerXAnchor
        );
        
      case (let .centerFixedWidth(constant), _):
        // TODO: handle margins
        constraintWidth = childView.widthAnchor.constraint(
          equalToConstant: constant
        );
        
        constraintCenterX = childView.centerXAnchor.constraint(
          equalTo: parentView.centerXAnchor
        );
        
      case (.leading, _):
        constraintLeading = childView.leadingAnchor.constraint(
          equalTo: parentView.leadingAnchor,
          constant: marginLeading
        );
        
      case (let .leadingStretch(percent), _):
        // TODO: handle trailing margins
        constraintWidth = childView.widthAnchor.constraint(
          equalTo: parentView.widthAnchor,
          multiplier: percent
        );
        
        constraintLeading = childView.leadingAnchor.constraint(
          equalTo: parentView.leadingAnchor,
          constant: marginLeading
        );
        
      case (let .leadingFixedWidth(constant), _):
        // TODO: handle trailing margin
        constraintWidth = childView.widthAnchor.constraint(
          equalToConstant: constant
        );
        
        constraintLeading = childView.leadingAnchor.constraint(
          equalTo: parentView.leadingAnchor,
          constant: marginLeading
        );
        
      case (.trailing, _):
        constraintTrailing = childView.trailingAnchor.constraint(
          equalTo: parentView.trailingAnchor,
          constant: -marginTrailing
        );
        
      case (let .trailingStretch(percent), _):
        // TODO: handle leading margin
        constraintWidth = childView.widthAnchor.constraint(
          equalTo: parentView.widthAnchor,
          multiplier: percent
        );
        
        constraintTrailing = childView.trailingAnchor.constraint(
          equalTo: parentView.trailingAnchor,
          constant: -marginTrailing
        );
        
      case (let .trailingFixedWidth(constant), _):
        // TODO: handle leading margin
        constraintWidth = childView.widthAnchor.constraint(
          equalToConstant: constant
        );
        
        constraintTrailing = childView.trailingAnchor.constraint(
          equalTo: parentView.trailingAnchor,
          constant: -marginTrailing
        );
    };
    
    return (
      constraintLeading,
      constraintTrailing,
      constraintWidth,
      constraintCenterX,
      constraintLeadingMin,
      constraintTrailingMin
    );
  };
  
  public func createHorizontalConstraints(
    forView childView: UIView,
    attachingTo parentView: UIView,
    withWindow window: UIWindow?,
    marginLeading: CGFloat = 0,
    marginTrailing: CGFloat = 0,
    preferToUseWidthConstraint: Bool = false
  ) -> [NSLayoutConstraint] {
    
    let groupedConstraints = self.createHorizontalConstraintsGrouped(
      forView: childView,
      attachingTo: parentView,
      withWindow: window,
      marginLeading: marginLeading,
      marginTrailing: marginTrailing,
      preferToUseWidthConstraint: preferToUseWidthConstraint
    );
    
    var constraints: [NSLayoutConstraint] = [];
    constraints.unwrapThenAppend(groupedConstraints.constraintLeading);
    constraints.unwrapThenAppend(groupedConstraints.constraintTrailing);
    constraints.unwrapThenAppend(groupedConstraints.constraintWidth);
    constraints.unwrapThenAppend(groupedConstraints.constraintCenterX);
    constraints.unwrapThenAppend(groupedConstraints.constraintLeadingMin);
    constraints.unwrapThenAppend(groupedConstraints.constraintTrailingMin);

    return constraints;
  };
};

// MARK: ViewPositionHorizontal+Helpers
// ------------------------------------

public extension ViewPositionHorizontal {
  
  func findConstraint(
    inConstraints constraints: [NSLayoutConstraint],
    withIdentifier identifierPreset: Identifier
  ) -> NSLayoutConstraint? {
    
    constraints.first {
      $0.identifier == identifierPreset.identifier;
    };
  };
  
  func findConstraint(
    inView view: UIView,
    withIdentifier identifierPreset: Identifier
  ) -> NSLayoutConstraint? {
    
    view.constraints.first {
      $0.identifier == identifierPreset.identifier;
    };
  };
  
  func recursivelyFindConstraint(
    inView view: UIView,
    withIdentifier identifierPreset: Identifier
  ) -> NSLayoutConstraint? {
    
    view.recursivelyFindConstraint(
      withIdentifier: identifierPreset.identifier
    );
  };
};
