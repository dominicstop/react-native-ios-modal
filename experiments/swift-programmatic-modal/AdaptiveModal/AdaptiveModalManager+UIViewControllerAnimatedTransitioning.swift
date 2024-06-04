//
//  AdaptiveModalManager+UIViewControllerAnimatedTransitioning.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/8/23.
//

import UIKit

extension AdaptiveModalManager: UIViewControllerAnimatedTransitioning {

  public func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
  
    return self.modalConfig.snapAnimationConfig.springAnimationSettlingTime;
  };
  
  public func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    guard let fromVC = transitionContext.viewController(forKey: .from)
    else { return };
    
    switch self.presentationState {
      case .presenting:
        self.targetView = transitionContext.containerView;
        self.targetViewController = fromVC;
        
        self.prepareForPresentation();
        
        self.showModal() {
          transitionContext.completeTransition(true);
        };
      
      case .dismissing:
        self.hideModal(){
          transitionContext.completeTransition(true);
        };
        
      case .none:
        break;
    };
  };
};
