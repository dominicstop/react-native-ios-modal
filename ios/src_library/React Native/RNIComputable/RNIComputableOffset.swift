//
//  RNIComputableOffset.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/28/23.
//

import UIKit

public struct RNIComputableOffset {

  public enum OffsetOperation: String {
    case multiply, divide, add, subtract;
    
    func compute(a: Double, b: Double) -> Double {
      switch self {
        case .add:
          return a + b;
          
        case .divide:
          return a / b;
          
        case .multiply:
          return a * b;
          
        case .subtract:
          return a - b;
      };
    };
  };
  
  public var offset: Double;
  public var offsetOperation: OffsetOperation;
  
  public func compute(withValue value: Double) -> Double {
    return self.offsetOperation.compute(a: self.offset, b: value);
  };
};

extension RNIComputableOffset {

  public init?(fromDict dict: NSDictionary){
    guard let offset = dict["offset"] as? NSNumber else { return nil };
    self.offset = offset.doubleValue;
    
    self.offsetOperation = {
      guard let offsetOperationRaw = dict["offsetOperation"] as? String,
            let offsetOperation = OffsetOperation(rawValue: offsetOperationRaw)
      else { return .add };
      
      return offsetOperation;
    }();
  };
};
