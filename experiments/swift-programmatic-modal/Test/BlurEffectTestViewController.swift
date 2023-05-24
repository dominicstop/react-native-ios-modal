//
//  BlurEffectTestViewController.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/22/23.
//

import UIKit





class BlurEffectIntensityManager {

  var animator: UIViewPropertyAnimator?;
  var onDisplayLinkUpdateBlock: (() -> Void)? = nil;
  
  
  func setBlur(
    forBlurEffectView blurEffectView: UIVisualEffectView,
    intensity: CGFloat = 1,
    blurEffectStyle: UIBlurEffect.Style = .systemMaterial,
    duration: CGFloat = 0,
    curve: UIView.AnimationCurve = .easeIn
  ) {
    guard self.animator == nil else { return };
    
    let animator = UIViewPropertyAnimator(duration: duration, curve: curve);
    self.animator = animator;
    
    
  
    animator.addAnimations {
      blurEffectView.effect = UIBlurEffect(style: blurEffectStyle);
      blurEffectView.alpha = intensity;
    };
    
    if duration == 0 {
      animator.fractionComplete = intensity;
      animator.stopAnimation(true);
      self.animator = nil;
      
    } else {
      animator.startAnimation();
      
      let displayLink = CADisplayLink(
        target: self,
        selector: #selector(self.onDisplayLinkUpdate)
      );
        
      displayLink.add(to: .current, forMode: .common)
      
      self.onDisplayLinkUpdateBlock = {
        guard animator.fractionComplete >= intensity else { return };
        animator.stopAnimation(true);
        
        self.animator = nil;
        self.onDisplayLinkUpdateBlock = nil;
      };
    };
  };
  
  @objc func onDisplayLinkUpdate() {
    self.onDisplayLinkUpdateBlock?();
  };
};


class BlurEffectTestViewController: UIViewController {

  lazy var blurEffectView = UIVisualEffectView();
  
  let blurManager = BlurEffectIntensityManager();
  var isBlurred = false;
  
  var boxView: UIView {
    let view = UIView();

    view.backgroundColor = UIColor(
      hue: CGFloat(Int.random(in: 0...360)) / 360,
      saturation: 50 / 100,
      brightness: 100 / 100,
      alpha: 1.0
    );
    
    view.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      view.heightAnchor.constraint(equalToConstant: 100),
      view.widthAnchor.constraint(equalToConstant: 100),
    ]);
    
    
    return view;
  };
  
  override func loadView() {
    let view = UIView();
    view.backgroundColor = .white;
    
    self.view = view;
    
    let blurEffectView = self.blurEffectView;
    
    blurEffectView.addGestureRecognizer(
      UITapGestureRecognizer(
        target: self,
        action: #selector(self.onPressBlurView(_:))
      )
    );
    
    let stackView = UIStackView(arrangedSubviews: [
      self.boxView,
      self.boxView,
      self.boxView,
      self.boxView
    ]);
    
    stackView.alignment = .center;
    
    view.addSubview(stackView);
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    
    view.addSubview(blurEffectView);
    blurEffectView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor),
      stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
      stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      blurEffectView.widthAnchor.constraint(equalTo: view.widthAnchor),
      blurEffectView.heightAnchor.constraint(equalTo: view.heightAnchor),
      blurEffectView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      blurEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  };
  
  override func viewDidLoad() {
    self.blurManager.setBlur(
      forBlurEffectView: self.blurEffectView,
      intensity: 1
    );
  };
  
  @objc func onPressBlurView(_ sender: UITapGestureRecognizer){
    if isBlurred {
      self.blurManager.setBlur(
        forBlurEffectView: self.blurEffectView,
        intensity: 0,
        duration: 1,
        curve: .easeIn
      );
    
    } else {
      self.blurManager.setBlur(
        forBlurEffectView: self.blurEffectView,
        intensity: 0.5,
        duration: 1,
        curve: .easeIn
      );
    };
    
    self.isBlurred.toggle();
  };
};
