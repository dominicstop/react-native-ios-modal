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
    return nil;
  };

  func animationController(
    forDismissed dismissed: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return nil;
  };
  
  func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    
    return AdaptiveModalPresentationController(
      presentedViewController: presented,
      presenting: presenting,
      modalManager: self
    );
  };
};
