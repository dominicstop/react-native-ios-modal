//
//  RNIDraggableTestViewController.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/22/23.
//


import UIKit


class AdaptiveModalManager {
  
  let snapPoints: [RNILayout] = [
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .bottom,
      width: RNIComputableValue(
        mode: .stretch
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.3)
      )
    ),
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .bottom,
      width: RNIComputableValue(
        mode: .stretch
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.7)
      )
    ),
  ];
  
  var currentSnapPointIndex = 0;
  
  var currentSnapPoint: RNILayout {
    return self.snapPoints[self.currentSnapPointIndex];
  };

  func getNextSnapPoint(
    forRect currentRect: CGRect,
    isIncreasing: Bool,
    withTargetRect targetRect: CGRect,
    withCurrentSize currentSize: CGSize
  ) -> (
    nextSnapPointIndex: Int,
    nextSnapPoint: RNILayout,
    computedRect: CGRect
  ) {
    let snapPointRects = self.snapPoints.map {
      $0.computeRect(
        withTargetRect: targetRect,
        currentSize: currentSize
      );
    };
    
    let diffY = snapPointRects.map {
      $0.origin.y - currentRect.origin.y
    };
    
    let closestSnapPoint = diffY.enumerated().first { item in
      diffY.allSatisfy {
        abs(item.element) <= abs($0)
      };
    };
    
    let closestSnapPointIndex = closestSnapPoint!.offset;
    let nextSnapPoint = self.snapPoints[closestSnapPointIndex];
    
    print("forRect", currentRect);
    print("withTargetRect", targetRect);
    print("snapPointRects", snapPointRects);
    print("diffY", diffY);
    print("closestSnapPoint", closestSnapPoint, "\n");
    
    return (
      nextSnapPointIndex: closestSnapPointIndex,
      nextSnapPoint: nextSnapPoint,
      computedRect: snapPointRects[closestSnapPointIndex]
    );
  };
};

class RNIDraggableTestViewController : UIViewController {
  
  var modalManager = AdaptiveModalManager();
  
  private var initialGesturePoint: CGPoint = .zero;
  private var floatingViewInitialCenter: CGPoint = .zero
  
  lazy var floatingViewLabel: UILabel = {
    let label = UILabel();
    
    label.text = "\(self.modalManager.currentSnapPointIndex)";
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
    
    let gesturePoint = sender.translation(in: self.view);
    
    switch sender.state {
      case .began:
        self.floatingViewInitialCenter = floatingView.center;
        self.initialGesturePoint = gesturePoint;
    
      case .cancelled, .ended:
        let gesturePointDiff = self.initialGesturePoint.y - gesturePoint.y;
        let isIncreasing = gesturePointDiff >= 0;
      
        let currentRect = self.floatingView.frame;
        
        let nextSnapPoint = self.modalManager.getNextSnapPoint(
          forRect: currentRect,
          isIncreasing: isIncreasing,
          withTargetRect: self.view.frame,
          withCurrentSize: .zero
        );
        
        self.updateFloatingView(
          nextFrame: nextSnapPoint.computedRect,
          isAnimated: true
        );
        break;
        
      case .changed:
        let newCenter = CGPoint(
          x: floatingViewInitialCenter.x + gesturePoint.x,
          y: floatingViewInitialCenter.y + gesturePoint.y
        );
      
        floatingView.center = newCenter;

      default:
        break;
    };
  };
};
