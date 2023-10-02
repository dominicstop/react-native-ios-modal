//
//  RNIComputableValueMode.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/19/23.
//

import UIKit


public enum RNIComputableValueMode {
  case current;
  case stretch;
  case constant(constantValue: Double);
  case percent(percentValue: Double);
};

extension RNIComputableValueMode {
  public init?(fromDict dict: NSDictionary){
    guard let mode = dict["mode"] as? String else { return nil };
    
    switch mode {
      case "current":
        self = .current;
        
      case "stretch":
        self = .stretch;
      
      case "constant":
        guard let value = dict["constantValue"] as? NSNumber
        else { return nil };
        
        self = .constant(
          constantValue: value.doubleValue
        );
      
      case "percent":
        guard let value = dict["percentValue"] as? NSNumber
        else { return nil };
        
        self = .percent(percentValue: value.doubleValue);
        
      default:
        return nil;
    };
  };
};

