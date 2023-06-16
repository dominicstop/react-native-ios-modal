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
  
    return self.modalConfig.snapAnimationConfig.springAnimationSettlingTime;
  };
  
  func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    guard let fromVC = transitionContext.viewController(forKey: .from),
          let toVC = transitionContext.viewController(forKey: .to)
    else { return }
    
    self.targetView = transitionContext.containerView;
    self.targetViewController = fromVC;
    
    self.prepareForPresentation();
    self.showModal() {
      transitionContext.completeTransition(true);
    };
    
    self.debug(prefix: "AdaptiveModalPresentationController.animateTransition");
    
    
    
    
    // if self.currentInterpolationIndex == 0 {
    //   self.prepareForPresentation(
    //     presentingViewController: fromVC,
    //     presentedViewController: toVC
    //   );
    // };
    //
    // self.showModal(){
    //   transitionContext.completeTransition(true);
    // };
    
    print(
      "AdaptiveModalPresentationController.animateTransition"
      + "\n - fromVC: \(fromVC)"
      + "\n - toVC: \(toVC)"
    );
  };
};
