//
//  AdaptiveModalPresentationTest.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/7/23.
//

import UIKit

fileprivate class TestModalViewController: UIViewController, AdaptiveModalEventNotifiable {

  weak var modalManager: AdaptiveModalManager?;
  
  var showDismissButton = true;
  var showCustomSnapPointButton = false;

  lazy var floatingViewLabel: UILabel = {
    let label = UILabel();
    
    label.text = "\(self.modalManager?.currentInterpolationIndex ?? -1)";
    label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5);
    label.font = .boldSystemFont(ofSize: 22);

    return label;
  }();
  
  override func viewDidLoad() {
    self.view.backgroundColor = .white;
    
    let dismissButton: UIButton = {
      let button = UIButton();
      
      button.setTitle("Dismiss Modal", for: .normal);
      button.configuration = .filled();
      
      button.addTarget(
        self,
        action: #selector(self.onPressButtonDismiss(_:)),
        for: .touchUpInside
      );
      
      return button;
    }();
    
    let customSnapPointButton: UIButton = {
      let button = UIButton();
      
      button.setTitle("Custom Snap Point", for: .normal);
      button.configuration = .filled();
      
      button.addTarget(
        self,
        action: #selector(self.onPressButtonCustomSnapPoint(_:)),
        for: .touchUpInside
      );
      
      return button;
    }();
    
    let stackView: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .equalSpacing;
      stack.alignment = .center;
      stack.spacing = 10;
      
      stack.addArrangedSubview(self.floatingViewLabel);
      
      if self.showDismissButton {
        stack.addArrangedSubview(dismissButton);
      };
      
      if self.showCustomSnapPointButton {
        stack.addArrangedSubview(customSnapPointButton);
      };
      
      return stack;
    }();
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(stackView);
    
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
    ]);
  };
  
  @objc func onPressButtonDismiss(_ sender: UIButton){
    self.dismiss(animated: true);
  };
  
  @objc func onPressButtonCustomSnapPoint(_ sender: UIButton){
    let snapPoint = AdaptiveModalSnapPointConfig(
      key: .string("custom"),
      snapPoint: .init(
        horizontalAlignment: .center,
        verticalAlignment: .center,
        width: .stretch,
        height: .stretch,
        marginLeft: .constant(15),
        marginRight: .constant(15),
        marginTop: .multipleValues([
          .safeAreaInsets(insetKey: \.top),
          .constant(15),
        ]),
        marginBottom: .multipleValues([
          .safeAreaInsets(insetKey: \.bottom),
          .constant(15),
        ])
      ),
      animationKeyframe: .init(
        modalCornerRadius: 15,
        modalMaskedCorners: [
          .layerMaxXMaxYCorner,
          .layerMaxXMinYCorner,
          .layerMinXMaxYCorner,
          .layerMinXMinYCorner,
        ],
        modalBackgroundOpacity: 0.9,
        backgroundOpacity: 0
      )
    );
  
    //self.dismiss(animated: true);
    self.modalManager?.snapTo(
      snapPointConfig: snapPoint
    );
  };
  
  func notifyOnModalWillSnap(
    prevSnapPointIndex: Int?,
    nextSnapPointIndex: Int,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    interpolationPoint: AdaptiveModalInterpolationPoint
  ) {
    self.floatingViewLabel.text = "\(nextSnapPointIndex)";
  };
  
  func notifyOnModalDidSnap(
    prevSnapPointIndex: Int?,
    currentSnapPointIndex: Int,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    interpolationPoint: AdaptiveModalInterpolationPoint
  ) {
    self.floatingViewLabel.text = "\(currentSnapPointIndex)";
  };
};

class AdaptiveModalPresentationTestViewController : UIViewController {

  lazy var adaptiveModalManager = AdaptiveModalManager(
    modalConfig: self.currentModalConfigPreset.config
  );
  
  let modalConfigs: [AdaptiveModalConfigTestPresets] = [
    .demo01,
    .demo02,
    .demo03,
    .demo04,
    .demo05,
    .demo06,
    .demo07,
    .demo08,
  ];
  
  var currentModalConfigPresetCounter = 0;
  
  var currentModalConfigPresetIndex: Int {
    self.currentModalConfigPresetCounter % self.modalConfigs.count
  };
  
  var currentModalConfigPreset: AdaptiveModalConfigTestPresets {
    self.modalConfigs[self.currentModalConfigPresetIndex];
    //AdaptiveModalConfigTestPresets.default;
  };
  
  var currentModalManagerAdjustmentBlock: () -> Void {
    let defaultBlock = {
      self.adaptiveModalManager.enableOverShooting = true;
    
      self.adaptiveModalManager.shouldSnapToUnderShootSnapPoint = true;
      self.adaptiveModalManager.shouldSnapToOvershootSnapPoint = false;
      
      self.adaptiveModalManager.shouldDismissModalOnSnapToUnderShootSnapPoint = true;
      self.adaptiveModalManager.shouldDismissModalOnSnapToOverShootSnapPoint = false;
    };
  
    switch self.currentModalConfigPreset {
      case .demo04: return {
        self.adaptiveModalManager.shouldSnapToOvershootSnapPoint = true;
        self.adaptiveModalManager.shouldDismissModalOnSnapToOverShootSnapPoint = true;
      };
      
      case .demo07: return {
        self.adaptiveModalManager.enableOverShooting = false;
      };
      
      default: return defaultBlock;
    };
  };
  
  var counterLabel: UILabel?;
  
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
    
    let counterLabel: UILabel = {
      let label = UILabel();
      
      label.text = "\(self.currentModalConfigPresetIndex)";
      label.font = .systemFont(ofSize: 24, weight: .bold);
      label.textColor = .white;
      
      self.counterLabel = label;

      return label;
    }();
    
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
    
    let nextConfigButton: UIButton = {
      let button = UIButton();
      button.setTitle("Next Modal Config", for: .normal);
      
      button.addTarget(
        self,
        action: #selector(self.onPressButtonNextConfig(_:)),
        for: .touchUpInside
      );
      
      return button;
    }();
    
    
    let stackView: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .equalSpacing;
      stack.alignment = .center;
      stack.spacing = 7;
      
      stack.addArrangedSubview(counterLabel);
      stack.addArrangedSubview(presentButton);
      stack.addArrangedSubview(nextConfigButton);
      
      return stack;
    }();
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(stackView);
    
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
    ]);
  };
  
  override func viewDidLayoutSubviews() {

  };
  
  @objc func onPressButtonPresentViewController(_ sender: UIButton) {
    let testVC = TestModalViewController();
    
    switch self.currentModalConfigPreset {
      case .demo08, .demo07:
        testVC.showCustomSnapPointButton = true;
      
      default: break;
    };
    
    self.adaptiveModalManager.eventDelegate = testVC;
    testVC.modalManager = self.adaptiveModalManager;
    
    
    self.adaptiveModalManager.presentModal(
      viewControllerToPresent: testVC,
      presentingViewController: self
    );
  };
  
  @objc func onPressButtonNextConfig(_ sender: UIButton) {
    self.currentModalConfigPresetCounter += 1;
    self.counterLabel!.text = "\(self.currentModalConfigPresetIndex)";
    
    self.adaptiveModalManager.modalConfig = self.currentModalConfigPreset.config;
    self.currentModalManagerAdjustmentBlock();
  };
};
