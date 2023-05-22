//
//  RootViewController.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/17/23.
//

import UIKit

class RootViewController : UIViewController {
  override func loadView() {
    let view = UIView()
    view.backgroundColor = .white;

    let label = UILabel();
    label.text = "Show Modal!";
    label.textColor = .black;
    label.isUserInteractionEnabled = true;
    
    label.addGestureRecognizer(
      UITapGestureRecognizer(
        target: self,
        action: #selector(self.onPressButton(_:))
      )
    );
    
    view.addSubview(label);
    
    view.translatesAutoresizingMaskIntoConstraints = false;
    label.translatesAutoresizingMaskIntoConstraints = false;
    
    
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ]);
    
    self.view = view
  };
  
  @objc func onPressButton(_ sender: UITapGestureRecognizer){
  
    let modalVC = RNIDynamicModalViewController();
    
    // let transitionController = RNIDynamicModalTransitionController(
    //   presentedViewController: modalVC,
    //   presenting: self
    // );
    // 
    // modalVC.modalPresentationStyle = .custom;
    // modalVC.transitioningDelegate = transitionController;
    
    self.present(modalVC, animated: true);
  };
};
