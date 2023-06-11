//
//  AdaptiveModalManager+UIViewControllerAnimatedTransitioning.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/8/23.
//

import UIKit

extension AdaptiveModalManager: UIViewControllerAnimatedTransitioning {

  func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    // to be implemented
    return 1;
  };
  
  func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    guard let fromViewController = transitionContext.viewController(forKey: .from),
          let toViewController = transitionContext.view(forKey: .to)
    else { return };

    self.targetView = transitionContext.containerView;

    self.currentInterpolationIndex = 1;

    self.computeSnapPoints();
    
    self.setupInitViews();
    self.setupDummyModalView();
    self.setupGestureHandler();
    
    self.setupAddViews();
    self.setupViewConstraints();
    
    self.updateModal();
    
    print(
      "transitionContext"
      + "\n - containerView: \(transitionContext.containerView)"
      + "\n - modalView: + \(self.modalView)"
      + "\n - targetView: + \(self.targetView)"
      + "\n - currentInterpolationIndex: + \(self.currentInterpolationIndex)"
      + "\n - currentInterpolationStep: + \(self.currentInterpolationStep)"
    );
  };
};
