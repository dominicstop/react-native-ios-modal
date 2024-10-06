//
//  RNIContentPositioningMode.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/6/24.
//

import Foundation


/// * `.stretch` is better for: `UIScrollView`
/// * `.centered` is better for regular views when sizing fast
///
/// Notes:
/// * In some cases, fabric/paper + yoga might not be able to keep up with
///   layout, so it will appear to stutter/lag behind if it's parent resizes
///   a lot.
///
/// * This is most noticeable when things are anchored to right and
///   bottom edges (e.g. views that are floating via absolute positioning), or
///   when certain views or subviews are centered.
///
/// * However `.centered` needs some extra logic, namely there needs to be
///   2 constant constraints that need to be updated whenever react resizes
///
/// * as such, when creating the constraints via ,
///   `RNIContentPositioningMode.createConstraints` these argument must be
///   provided: `sizingLayoutGuide`
///
/// * If `sizingLayoutGuide` is not provided in `createConstraints`, then it'll
///   fallback to: `.stretch`
///
/// * set the constraints of `sizingLayoutGuide` such that it's height and
///   width is not ambiguous (e.g. via `heightConstraint`, and
///   `widthConstraint` + some constant value, etc)
///
/// * when react layouts, update `sizingLayoutGuide`.
///
public enum RNIContentPositioningMode: String {
  case stretch;
  case centered;
  
  // MARK: - Functions
  // -----------------
  
  public func createConstraints(
    forView childView: UIView,
    attachingTo parentView: UIView,
    withContentSizingMode contentSizingMode: RNIContentSizingMode? = nil,
    usingSizingLayoutGuide sizingLayoutGuide: UILayoutGuide? = nil,
    shouldConstrainParentSizeToSizingLayoutGuide: Bool = false
  ) -> [NSLayoutConstraint] {
    
    switch (self, sizingLayoutGuide) {
      case (.stretch, _),
           (.centered, .none):
           
        return [
          childView.leadingAnchor.constraint(
            equalTo: parentView.leadingAnchor
          ),
          childView.trailingAnchor.constraint(
            equalTo: parentView.trailingAnchor
          ),
          childView.topAnchor.constraint(
            equalTo: parentView.topAnchor
          ),
          childView.bottomAnchor.constraint(
            equalTo: parentView.bottomAnchor
          ),
        ];
        
      case (.centered, let .some(sizingLayoutGuide)):
        var constraints = [
          childView.centerXAnchor.constraint(
            equalTo: parentView.centerXAnchor
          ),
          childView.centerYAnchor.constraint(
            equalTo: parentView.centerYAnchor
          ),
          childView.widthAnchor.constraint(
            equalTo: sizingLayoutGuide.widthAnchor
          ),
          childView.heightAnchor.constraint(
            equalTo: sizingLayoutGuide.heightAnchor
          ),
        ];
        
      guard shouldConstrainParentSizeToSizingLayoutGuide,
            let contentSizingMode = contentSizingMode
      else {
        return constraints;
      };
      
      if contentSizingMode.isSizingHeightFromNative {
        constraints.append(
          parentView.heightAnchor.constraint(
            equalTo: sizingLayoutGuide.heightAnchor
          )
        );
      };
      
      if contentSizingMode.isSizingWidthFromNative {
        constraints.append(
          parentView.widthAnchor.constraint(
            equalTo: sizingLayoutGuide.widthAnchor
          )
        );
      };
      
      return constraints;
    };
  };
};
