//
//  AdaptiveModalPresentationTest.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/7/23.
//

import UIKit

class TestViewController: UIViewController {
  override func viewDidLoad() {
    self.view.backgroundColor = .white;
  };
};

class AdaptiveModalPresentationTestViewController : UIViewController {

  lazy var adaptiveModalManager = AdaptiveModalManager(
    modalConfig: AdaptiveModalConfigTestPresets.test03.config
  );
  
  override func viewDidLoad() {
    self.view.backgroundColor = .white;
    
    let dummyBackgroundView: UIView = {
      let imageView = UIImageView(
        image: UIImage(named: "DummyBackgroundImage2")
      );
      
      imageView.contentMode = .scaleAspectFill;
      return imageView;
    }();
    
    self.view.addSubview(dummyBackgroundView);
    dummyBackgroundView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      dummyBackgroundView.topAnchor     .constraint(equalTo: self.view.topAnchor     ),
      dummyBackgroundView.bottomAnchor  .constraint(equalTo: self.view.bottomAnchor  ),
      dummyBackgroundView.leadingAnchor .constraint(equalTo: self.view.leadingAnchor ),
      dummyBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
    ]);
    
    let presentButton: UIButton = {
      let button = UIButton();
      button.setTitle("Present View Controller", for: .normal);
      
      button.addTarget(
        self,
        action: #selector(self.onPressButtonPresentViewController(_:)),
        for: .touchUpInside
      );
      
      return button;
    }();
    
    self.view.addSubview(presentButton);
    presentButton.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      presentButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      presentButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
    ]);
  };
  
  override func viewDidLayoutSubviews() {

  };
  
  @objc func onPressButtonPresentViewController(_ sender: UIButton) {
    let testVC = TestViewController();
    
    self.adaptiveModalManager.set(
      viewControllerToPresent: testVC,
      presentingViewController: self
    );
    
    
    self.present(testVC, animated: true);
  };
};
