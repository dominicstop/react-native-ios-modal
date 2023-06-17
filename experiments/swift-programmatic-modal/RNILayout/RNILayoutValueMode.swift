//
//  RNILayoutValueMode.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/8/23.
//

import UIKit

public enum RNILayoutValueMode {

  case stretch;
  
  case constant(_: CGFloat);
  
  case percent(
    relativeTo: RNILayoutValuePercentTarget = .targetSize,
    percentValue: Double
  );
  
  case safeAreaInsets(
    insetKey: KeyPath<UIEdgeInsets, CGFloat>
  );
  
  case multipleValues(_ values: [Self]);
  
  // MARK: Functions
  // ---------------
  
  public func compute(
    usingLayoutValueContext context: RNILayoutValueContext,
    preferredSizeKey: KeyPath<CGSize, CGFloat>?
  ) -> CGFloat? {
  
    switch self {
      case .stretch:
        guard let preferredSizeKey = preferredSizeKey else { return nil };
        return context.targetSize[keyPath: preferredSizeKey];
        
      case let .constant(constantValue):
        return constantValue;
        
      case let .percent(relativeToValue, percentValue):
        guard let preferredSizeKey = preferredSizeKey else { return nil };
      
        let targetValue = relativeToValue.getValue(
          layoutValueContext: context,
          preferredSizeKey: preferredSizeKey
        );
        
        guard let targetValue = targetValue else { return nil };
        return targetValue * percentValue;
        
      case let .safeAreaInsets(insetKey):
        return context.safeAreaInsets?[keyPath: insetKey];
        
      case let .multipleValues(computableValues):
        return computableValues.reduce(0) {
          let computedValue = $1.compute(
            usingLayoutValueContext: context,
            preferredSizeKey: preferredSizeKey
          );
          
          guard let computedValue = computedValue else { return 0 };
          return $0 + computedValue;
        };
    };
  };
};
