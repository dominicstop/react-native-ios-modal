//
//  AdaptiveModalManager+UIViewControllerTransitioningDelegate.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/8/23.
//

import UIKit

extension AdaptiveModalManager: UIAdaptivePresentationControllerDelegate {

  public func adaptivePresentationStyle(
    for controller: UIPresentationController,
    traitCollection: UITraitCollection
  ) -> UIModalPresentationStyle {
    
    return .custom;
  };
};


extension AdaptiveModalManager: UIViewControllerTransitioningDelegate {
  
  public func presentationController(
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
  
  public func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    
    self.presentationState = .presenting;
    return self;
  };

  public func animationController(
    forDismissed dismissed: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    
    self.presentationState = .dismissing;
    return self;
  };
};
