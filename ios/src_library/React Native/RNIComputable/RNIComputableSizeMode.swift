//
//  RNIComputableSizeOffset.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/28/23.
//

import Foundation

public enum RNIComputableSizeMode {
  case current;
  case stretch;
  case constant(constantWidth: Double, constantHeight: Double);
  case percent(percentWidth: Double, percentHeight: Double);
};

extension RNIComputableSizeMode {
  public init?(fromDict dict: NSDictionary){
    guard let mode = dict["mode"] as? String else { return nil };
    
    switch mode {
      case "current":
        self = .current;
        
      case "stretch":
        self = .stretch;
      
      case "constant":
        guard let width  = dict["constantWidth"] as? NSNumber,
              let height = dict["constantHeight"] as? NSNumber
        else { return nil };
        
        self = .constant(
          constantWidth: width.doubleValue,
          constantHeight: height.doubleValue
        );
      
      case "percent":
        guard let width  = dict["percentWidth"] as? NSNumber,
              let height = dict["percentHeight"] as? NSNumber
        else { return nil };
        
        self = .percent(
          percentWidth: width.doubleValue,
          percentHeight: height.doubleValue
        );
        
      default:
        return nil;
    };
  };
};
