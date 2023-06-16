//
//  AdaptiveModalManager+UIViewControllerTransitioningDelegate.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/8/23.
//

import UIKit

extension AdaptiveModalManager: UIAdaptivePresentationControllerDelegate {
  func adaptivePresentationStyle(
    for controller: UIPresentationController,
    traitCollection: UITraitCollection
  ) -> UIModalPresentationStyle {
    
    return .custom;
  };
};


extension AdaptiveModalManager: UIViewControllerTransitioningDelegate {
  
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
    
    presentationController.delegate = self;
    return presentationController;
  };
  
  func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    
    self.presentationState = .presenting;
    return self;
  };

  func animationController(
    forDismissed dismissed: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    
    self.presentationState = .dismissing;
    return self;
  };
};
