//
//  UIModalTransitionStyle+Helpers.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/29/20.
//

import Foundation

extension UIModalTransitionStyle: CaseIterable {
  public static var allCases: [UIModalTransitionStyle] {
    return [
      .coverVertical,
      .crossDissolve,
      .flipHorizontal,
      .partialCurl,
    ];
  };
  
  public func stringDescription() -> String {
    switch self {
      case .coverVertical : return "coverVertical";
      case .flipHorizontal: return "flipHorizontal";
      case .crossDissolve : return "crossDissolve";
      case .partialCurl   : return "partialCurl";

      @unknown default: return "";
    };
  };
  
  public static func fromString(_ string: String) -> UIModalTransitionStyle? {
    return self.allCases.first{ $0.stringDescription() == string };
  };
};
