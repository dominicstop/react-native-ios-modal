//
//  ModalSheetBottomDistance.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/6/24.
//

import Foundation
import DGSwiftUtilities

public enum ModalSheetBottomDistance {
  case constant(value: CGFloat);
  
  case safeArea(
    additionalValue: CGFloat,
    minValue: CGFloat
  );
  
  // MARK: - Functions
  // -----------------
  
  public func createBottomConstraint(
    forView childView: UIView,
    attachingTo parentView: UIView
  ) -> [NSLayoutConstraint] {
  
    switch self {
      case let .constant(value):
        return [
          childView.bottomAnchor.constraint(
            equalTo: parentView.bottomAnchor,
            constant: -value
          ),
        ];
        
      case let .safeArea(additionalValue, minValue):
        let hasMinValue = minValue != 0;
        
        guard hasMinValue else {
          return [
            childView.bottomAnchor.constraint(
              equalTo: parentView.safeAreaLayoutGuide.bottomAnchor,
              constant: additionalValue
            ),
          ];
        };
        
        let minDistanceConstraint = childView.bottomAnchor.constraint(
          equalTo: parentView.safeAreaLayoutGuide.bottomAnchor,
          constant: additionalValue
        );
        
        minDistanceConstraint.identifier = "bottomSafeAreaWithMinDistance";
        minDistanceConstraint.priority = .required;
        
        let additionalDistanceConstraint = childView.bottomAnchor.constraint(
          equalTo: parentView.safeAreaLayoutGuide.bottomAnchor,
          constant: additionalValue
        );
        
        additionalDistanceConstraint.identifier = "bottomAdditionalDistance";
        additionalDistanceConstraint.priority = .defaultHigh;
        
        return [
          minDistanceConstraint,
          additionalDistanceConstraint,
        ];
    }
  };
};

// MARK: - ModalSheetBottomDistance+StaticAlias
// --------------------------------------------

public extension ModalSheetBottomDistance {
  static let zero: Self = .constant(value: 0);
  
  static let safeArea: Self = .safeArea(
    additionalValue: 0,
    minValue: 0
  );
  
  static func safeArea(additionalValue: CGFloat) -> Self {
    .safeArea(
      additionalValue: additionalValue,
      minValue: 0
    );
  };
  
  static func safeArea(minValue: CGFloat) -> Self {
    .safeArea(
      additionalValue: 0,
      minValue: minValue
    );
  };
};

// MARK: - ModalSheetBottomDistance
// --------------------------------

extension ModalSheetBottomDistance: EnumCaseStringRepresentable {
  public var caseString: String {
    switch self {
      case .constant:
        return "constant";
        
      case .safeArea:
        return "safeArea";
    }
  };
};
