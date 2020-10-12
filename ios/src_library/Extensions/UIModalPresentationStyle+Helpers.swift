//
//  UIModalPresentationStyle+Helpers.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/28/20.
//

import Foundation

extension UIModalPresentationStyle: CaseIterable {
  public static var availableStyles: [UIModalPresentationStyle] {
    var styles: [UIModalPresentationStyle] = [
      .fullScreen,
      .pageSheet,
      .formSheet,
      .currentContext,
      .custom,
      .overFullScreen,
      .overCurrentContext,
      .popover,
    ];
    
    if #available(iOS 13.0, *) {
      styles.append(.automatic);
    };
    
    #if !os(iOS)
    styles.append(.blurOverFullScreen);
    #endif
    
    return styles;
  };
  
  public static var allCases: [UIModalPresentationStyle] {
    return self.availableStyles;
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
  
  static func fromString(_ string: NSString) -> UIModalPresentationStyle? {
    return self.fromString(string as String);
  };
};
