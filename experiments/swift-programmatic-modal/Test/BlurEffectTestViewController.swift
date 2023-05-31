//
//  BlurEffectTestViewController.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/22/23.
//

import UIKit


class BlurEffectView: UIVisualEffectView {
    
  var animator = UIViewPropertyAnimator(duration: 1, curve: .linear);
  
  func setBlur(intensity: CGFloat){
    self.animator.fractionComplete = intensity;
  };
  
  override func didMoveToSuperview() {
    guard let superview = superview else { return }
    backgroundColor = .clear
    frame = superview.bounds //Or setup constraints instead
    setupBlur()
  }
  
  private func setupBlur() {
    animator.stopAnimation(true)
    effect = nil

    animator.addAnimations { [weak self] in
      self?.effect = UIBlurEffect(style: .dark)
    }
    animator.fractionComplete = 0.1; //This is your blur intensity in range 0 - 1
  }
  
  deinit {
    animator.stopAnimation(true)
  }
}


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
    let animator = UIViewPropertyAnimator(duration: duration, curve: curve);
    self.animator = animator;
    
    blurEffectView.effect = nil;
    
    animator.addAnimations {
      blurEffectView.effect = UIBlurEffect(style: blurEffectStyle);
      // blurEffectView.alpha = intensity;
    };
    
    if duration == 0 {
      animator.fractionComplete = intensity;
      animator.stopAnimation(true);
      self.animator = nil;
      
    } else {
      animator.startAnimation();
      return;
      
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
    return;
    self.onDisplayLinkUpdateBlock?();
  };
};


class BlurEffectTestViewController: UIViewController {

  lazy var blurEffectView = BlurEffectView();
  
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
    blurEffectView.effect = UIBlurEffect(style: .prominent);
    
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
    return;
    self.blurManager.setBlur(
      forBlurEffectView: self.blurEffectView,
      intensity: 1
    );
  };
  
  @objc func onPressBlurView(_ sender: UITapGestureRecognizer){

    if isBlurred {
      self.blurEffectView.setBlur(intensity: 0);
    
    } else {
      self.blurEffectView.setBlur(intensity: 1);
    };
    
    self.isBlurred.toggle();
  };
};
