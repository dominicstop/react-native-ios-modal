//
//  RNIModalCustomSheetDetent.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/21/23.
//

import Foundation

enum RNIModalCustomSheetDetentMode {
  
  case relative(value: Double);
  case constant(value: Double);
  
  var rawValueString: String {
    switch self {
      case .constant: return "constant";
      case .relative: return "relative";
    };
  };
};

struct RNIModalCustomSheetDetent {
  
  typealias OnDetentDidCreate = (
    _ containerTraitCollection: UITraitCollection,
    _ maximumDetentValue: CGFloat,
    _ computedDetentValue: CGFloat,
    _ sender: RNIModalCustomSheetDetent
  ) -> Void;
  
  let mode: RNIModalCustomSheetDetentMode;
  let key: String;
  
  let offset: RNIComputableOffset?;
  
  let onDetentDidCreate: OnDetentDidCreate?;
  
  init?(
    forDict dict: Dictionary<String, Any>,
    onDetentDidCreate: OnDetentDidCreate? = nil
  ) {
    guard let rawMode = dict["mode"] as? String,
          let rawKey  = dict["key"] as? String
    else { return nil };
    
    self.key = rawKey;
    self.onDetentDidCreate = onDetentDidCreate;
    
    let mode: RNIModalCustomSheetDetentMode? = {
      switch rawMode {
        case "relative":
          guard let rawValue = dict["sizeMultiplier"] as? NSNumber
          else { return nil };
          
          return .relative(value: rawValue.doubleValue);
          
        case "constant":
          guard let rawValue = dict["sizeConstant"] as? NSNumber
          else { return nil };
          
          return .constant(value: rawValue.doubleValue);
          
        default:
          return nil;
      };
    }();
    
    guard let mode = mode else { return nil };
    self.mode = mode;
    
    self.offset = RNIComputableOffset(fromDict: dict as NSDictionary);
  };
  
  @available(iOS 15.0, *)
  var synthesizedDetentIdentifier:
    UISheetPresentationController.Detent.Identifier {
    
    UISheetPresentationController.Detent.Identifier(self.key);
  };
  
  @available(iOS 16.0, *)
  var synthesizedDetent: UISheetPresentationController.Detent {
    return .custom(identifier: self.synthesizedDetentIdentifier) { context in
      
      let computedValueBase: Double = {
        switch self.mode {
          case let .relative(value):
            return value * context.maximumDetentValue;
          
          case let .constant(value):
            return value;
        };
      }();
      
      let computedValueWithOffset =
        self.offset?.compute(withValue: computedValueBase);
        
      let computedValue = computedValueWithOffset ?? computedValueBase;
        
      self.onDetentDidCreate?(
        context.containerTraitCollection,
        context.maximumDetentValue,
        computedValue,
        self
      );
        
      return computedValue;
    };
  };
};
