//
//  UIGestureRecognizer+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/22/23.
//

import UIKit

extension UIGestureRecognizer.State: CustomStringConvertible {
  public var description: String {
    switch self {
      case .possible : return "possible";
      case .began    : return "began";
      case .changed  : return "changed";
      case .ended    : return "ended";
      case .cancelled: return "cancelled";
      case .failed   : return "failed";
      
      @unknown default: return "";
    };
  };
};
