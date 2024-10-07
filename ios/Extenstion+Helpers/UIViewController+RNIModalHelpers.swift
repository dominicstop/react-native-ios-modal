//
//  UIViewController+RNIModalHelpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/7/24.
//

import UIKit


public extension UIViewController {

  var modalMetrics: RNIModalViewControllerMetrics {
    .init(viewController: self);
  };
  
  var presentationControllerMetrics: RNIPresentationControllerMetrics? {
    self.presentationController?.presentationControllerMetrics;
  };
};
