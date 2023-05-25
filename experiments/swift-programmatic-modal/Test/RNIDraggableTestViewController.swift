//
//  RNIDraggableTestViewController.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/22/23.
//


import UIKit




class RNIDraggableTestViewController : UIViewController {
  
  lazy var modalManager = AdaptiveModalManager(
    targetRectProvider: { [unowned self] in
      self.view.frame;
    },
    currentSizeProvider: {
      .zero
    },
    modalView: self.floatingView
  );
  
  private var initialGesturePoint: CGPoint = .zero;
  private var floatingViewInitialCenter: CGPoint = .zero
  
  lazy var floatingViewLabel: UILabel = {
    let label = UILabel();
    
    // label.text = "\(self.modalManager.currentSnapPointIndex)";
    label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5);
    label.font = .boldSystemFont(ofSize: 22);
    
    label.addGestureRecognizer(
      UITapGestureRecognizer(
        target: self,
        action: #selector(self.onPressFloatingViewLabel(_:))
      )
    );
    
    return label;
  }();
  
  lazy var floatingView: UIView = {
    let view = UIView();
    
    view.backgroundColor = UIColor(
      hue: 0/360,
      saturation: 50/100,
      brightness: 100/100,
      alpha: 1.0
    );
    
    view.addGestureRecognizer(
      UIPanGestureRecognizer(
        target: self,
        action: #selector(self.onDragPanGestureView(_:))
      )
    );
    
    let floatingViewLabel = self.floatingViewLabel;
    view.addSubview(floatingViewLabel);
    
    floatingViewLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      floatingViewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      floatingViewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ]);
    
    return view;
  }();

  override func viewDidLoad() {
    self.view.backgroundColor = .white;
    
    let floatingView = self.floatingView;
    self.view.addSubview(floatingView);
    
    let initialSnapPoint = self.modalManager.currentSnapPoint;
    
    let computedRect = initialSnapPoint.computeRect(
      withTargetRect: self.view.frame,
      currentSize: CGSize(width: 300, height: 300)
    );
    
    self.floatingView.frame = computedRect;
    self.floatingViewLabel.text = "\(self.modalManager.currentSnapPointIndex)";
  };
  
  func updateFloatingView(
    nextFrame: CGRect,
    isAnimated: Bool = false
  ) {

    let animationBlock = {
      self.floatingView.frame = nextFrame;
      self.floatingViewLabel.text = "\(self.modalManager.currentSnapPointIndex)";
    };
  
    if isAnimated {
      let animator = UIViewPropertyAnimator(
        duration:0.2,
        curve: .easeIn,
        animations: animationBlock
      );
  
      animator.startAnimation();
  
    } else {
      animationBlock();
    };
  };

  
  @objc func onPressFloatingViewLabel(_ sender: UITapGestureRecognizer){
    // self.layoutConfigCount += 1;
    // self.updateFloatingView(isAnimated: true);
  };
  
  @objc func onDragPanGestureView(_ sender: UIPanGestureRecognizer) {
    let floatingView = self.floatingView;
    
    let gesturePoint = sender.location(in: self.view);
    let relativeGesturePoint = sender.translation(in: self.view);
    
    print(
        "onDragPanGestureView"
      + "\n" + " - sender.state: \(sender.state)"
      + "\n" + " - gesturePoint: \(gesturePoint)"
      + "\n"
    );
    
    switch sender.state {
      case .began:
        self.floatingViewInitialCenter = floatingView.center;
        self.initialGesturePoint = gesturePoint;
    
      case .cancelled, .ended:
        self.modalManager.gestureOffset = nil;

        let currentRect = self.floatingView.frame;
        
        let nextSnapPoint =
          self.modalManager.getNextSnapPoint(forRect: currentRect);
        
        self.updateFloatingView(
          nextFrame: nextSnapPoint.computedRect,
          isAnimated: true
        );
        break;
        
      case .changed:
        let computedRect = self.modalManager.interpolateModalRect(
          forGesturePoint: gesturePoint
        );

        floatingView.frame = computedRect;

      default:
        break;
    };
  };
};
