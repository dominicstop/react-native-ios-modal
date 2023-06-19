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
   };
  
   override func presentationTransitionDidEnd(_ completed: Bool) {
   };
   
  override func viewWillTransition(
    to size: CGSize,
    with coordinator: UIViewControllerTransitionCoordinator
  ) {
  }
};
