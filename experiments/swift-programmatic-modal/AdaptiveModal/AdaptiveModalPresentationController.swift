//
//  AdaptiveModalPresentationController.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/8/23.
//

import UIKit

class AdaptiveModalPresentationController: UIPresentationController {

  weak var modalManager: AdaptiveModalManager!;

  init(
    presentedViewController: UIViewController,
    presenting presentingViewController: UIViewController?,
    modalManager: AdaptiveModalManager
  ) {
    super.init(
      presentedViewController: presentedViewController,
      presenting: presentingViewController
    );
    
    self.modalManager = modalManager;
  };
  
   override func presentationTransitionWillBegin() {
    print(
        "AdaptiveModalPresentationController.presentationTransitionWillBegin"
      + "\n - presentedViewController: \(self.presentedViewController)"
      + "\n - presenting: \(self.presentingViewController)"
      + "\n - presentedViewController - frame: \(self.presentedViewController.view.frame)"
      + "\n - presenting - frame: \(self.presentingViewController.view.frame)"
      + "\n - presentedViewController - superview: \(self.presentedViewController.view.superview)"
      + "\n - presenting - superview: \(self.presentingViewController.view.superview)"
      + "\n"
    );

   };
  
   override func presentationTransitionDidEnd(_ completed: Bool) {
    print(
        "AdaptiveModalPresentationController.presentationTransitionDidEnd"
      + "\n - presentedViewController: \(self.presentedViewController)"
      + "\n - presenting: \(self.presentingViewController)"
      + "\n"
    );
   };
};
