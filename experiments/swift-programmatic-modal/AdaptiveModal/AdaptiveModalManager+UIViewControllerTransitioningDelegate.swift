//
//  AdaptiveModalManager+UIViewControllerTransitioningDelegate.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/8/23.
//

import UIKit



extension AdaptiveModalManager: UIViewControllerTransitioningDelegate {

  func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return self;
  };

  func animationController(
    forDismissed dismissed: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return self;
  };
  
  func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    
    let presentationController = AdaptiveModalPresentationController(
      presentedViewController: presented,
      presenting: presenting,
      modalManager: self
    );
    
    //presentationController.delegate = self;
    return presentationController;
  };
};
