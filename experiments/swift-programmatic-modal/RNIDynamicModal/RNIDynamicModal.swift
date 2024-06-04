//
//  RNIDynamicModal.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/15/23.
//

import UIKit

class RNIDynamicModalAnimator: NSObject, UIViewControllerTransitioningDelegate {

  enum Direction {
    case left, right, top, bottom;
  };
  
  let direction: Direction;
  let isPresentation: Bool;
  
  init(
    direction: Direction,
    isPresentation: Bool
  ) {
    self.direction = direction;
    self.isPresentation = isPresentation;
    
    super.init();
  };
  
  // MARK: - UIViewControllerTransitioningDelegate
  // ---------------------------------------------
  
  func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return 0.3
  }

  func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
  
    // 1
    let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from

    guard let controller = transitionContext.viewController(forKey: key)
      else { return }
      
    // 2
    if isPresentation {
      transitionContext.containerView.addSubview(controller.view)
    }

    // 3
    let presentedFrame = transitionContext.finalFrame(for: controller)
    var dismissedFrame = presentedFrame;
    
    switch direction {
      case .left:
        dismissedFrame.origin.x = -presentedFrame.width
        
      case .right:
        dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        
      case .top:
        dismissedFrame.origin.y = -presentedFrame.height
        
      case .bottom:
        dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
    }
      
    // 4
    let initialFrame = isPresentation ? dismissedFrame : presentedFrame
    let finalFrame = isPresentation ? presentedFrame : dismissedFrame
      
    // 5
    let animationDuration = transitionDuration(using: transitionContext)
    controller.view.frame = initialFrame
    UIView.animate(
      withDuration: animationDuration,
      animations: {
        controller.view.frame = finalFrame
    }, completion: { finished in
      if !self.isPresentation {
        controller.view.removeFromSuperview()
      }
      transitionContext.completeTransition(finished)
    })
  }
};



class RNIDynamicModalViewController: UIViewController {

  override func loadView() {
    let rootView = UIView();
    rootView.backgroundColor = .white;
    
    self.view = rootView;
    
    let label = UILabel();
    label.text = "Hello World!";
    label.textColor = .black;
    
    
    rootView.addSubview(label);
    label.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ]);
  };
};
