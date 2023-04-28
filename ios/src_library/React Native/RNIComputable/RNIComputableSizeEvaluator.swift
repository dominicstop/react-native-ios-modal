//
//  RNIComputableSizeEvaluator.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/28/23.
//

import Foundation

public class RNIComputableSizeEvaluator {
  
  var computableSize = RNIComputableSize(mode: .stretch);
  var targetSize: Double?;
  
  lazy var computableValueEvaluator = RNIComputableValueEvaluator();
  
  func evaluate(
    withTargetSize targetSize: CGSize?,
    currentSize: CGSize?,
    rootView: UIView?,
    targetView: UIView?
  ) -> CGSize? {
    let computedSize: CGSize? = {
      switch self.computableSize.mode {
        case .current:
          guard let targetSize = targetSize else { return nil };
          return targetSize;
          
        case .stretch:
          guard let currentSize = targetSize else { return nil };
          return currentSize;
          
        case let .constant(constantWidth, constantHeight):
          return CGSize(
            width: constantWidth,
            height: constantHeight
          );
          
        case let .percent(percentWidth, percentHeight):
          guard let targetSize = targetSize else { return nil };
          
          return CGSize(
            width: targetSize.width * percentWidth,
            height: targetSize.height * percentHeight
          );
          
        case let .function(valueFunction):
          let evaluator = self.computableValueEvaluator;
          
          evaluator.rootView = rootView;
          evaluator.targetView = targetView;
          evaluator.jsString = valueFunction;
          
          guard let resultRaw = evaluator.computedValue,
                let resultDict = resultRaw.toDictionary(),
                let resultSize = CGSize(fromDict: resultDict as NSDictionary)
          else { return nil };
          
          return resultSize;
      };
    }();
    
    guard let computedSize = computedSize else { return nil };
    return self.computableSize.computeOffsets(withSize: computedSize);
  };
};
