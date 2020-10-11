//
//  UIModalPresentationStyle+Helpers.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/28/20.
//

import Foundation

extension UIModalPresentationStyle: CaseIterable {
  public static var allCases: [UIModalPresentationStyle] {
    var styles: [UIModalPresentationStyle] = [
      .automatic,
      .fullScreen,
      .pageSheet,
      .formSheet,
      .currentContext,
      .custom,
      .overFullScreen,
      .overCurrentContext,
      .popover,
    ];
    
    #if !os(iOS)
    styles.append(.blurOverFullScreen);
    #endif
    
    return styles;
  };
  
  func stringDescription() -> String {
    switch self {
      case .automatic         : return "automatic";
      case .none              : return "none";
      case .fullScreen        : return "fullScreen";
      case .pageSheet         : return "pageSheet";
      case .formSheet         : return "formSheet";
      case .currentContext    : return "currentContext";
      case .custom            : return "custom";
      case .overFullScreen    : return "overFullScreen";
      case .overCurrentContext: return "overCurrentContext";
      case .popover           : return "popover";
      
      #if !os(iOS)
      case .blurOverFullScreen: return "blurOverFullScreen";
      #endif
      
      @unknown default: return "";
    };
  };
  
  static func fromString(_ string: String) -> UIModalPresentationStyle? {
    return self.allCases.first{ $0.stringDescription() == string };
  };
};
