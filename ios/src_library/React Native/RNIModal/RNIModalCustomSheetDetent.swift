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
    _ maximumDetentValue: CGFloat
  ) -> Void;
  
  let mode: RNIModalCustomSheetDetentMode;
  let key: String;
  
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
  };
  
  @available(iOS 15.0, *)
  var synthesizedDetentIdentifier:
    UISheetPresentationController.Detent.Identifier {
    
    UISheetPresentationController.Detent.Identifier(self.key);
  };
  
  @available(iOS 16.0, *)
  var synthesizedDetent: UISheetPresentationController.Detent {
    return .custom(identifier: self.synthesizedDetentIdentifier) {
      self.onDetentDidCreate?(
        $0.containerTraitCollection,
        $0.maximumDetentValue
      );
      
      switch self.mode {
        case let .relative(value):
          return value * $0.maximumDetentValue;
        
        case let .constant(value):
          return value;
      };
    }
  };
};