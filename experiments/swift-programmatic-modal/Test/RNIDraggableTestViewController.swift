//
//  RNIDraggableTestViewController.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/22/23.
//


import UIKit

class RNIDraggableTestViewController : UIViewController {
  
  lazy var modalManager = AdaptiveModalManager(
    modalView: self.floatingView,
    targetView: self.view,
    targetRectProvider: { [unowned self] in
      self.view.frame;
    },
    currentSizeProvider: {
      .zero
    }
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
    
    self.floatingViewLabel.text = "\(self.modalManager.currentSnapPointIndex)";
    
    self.modalManager.setFrameForModal();
  };
  
  @objc func onPressFloatingViewLabel(_ sender: UITapGestureRecognizer){
    // self.layoutConfigCount += 1;
    // self.updateFloatingView(isAnimated: true);
  };
  
  @objc func onDragPanGestureView(_ sender: UIPanGestureRecognizer) {
    print("onDragPanGestureView - velocity: \(sender.velocity(in: self.view))");
  
    self.modalManager.notifyOnDragPanGesture(sender);
  };
};
