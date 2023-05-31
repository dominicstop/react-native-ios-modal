//
//  RNIDraggableTestViewController.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/22/23.
//


import UIKit

enum AdaptiveModalConfigTestPresets: CaseIterable {
  
  static let `default`: Self = .test02;

  case test01;
  case test02;
  
  var config: AdaptiveModalConfig {
    switch self {
      case .test01: return AdaptiveModalConfig(
        snapPoints:  [
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
                horizontalAlignment: .center,
                verticalAlignment: .bottom,
                width: RNIComputableValue(
                  mode: .stretch
                ),
              height: RNIComputableValue(
                mode: .percent(percentValue: 0.1)
              )
            )
          ),
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNIComputableValue(
                mode: .stretch
              ),
              height: RNIComputableValue(
                mode: .percent(percentValue: 0.3)
              )
            )
          ),
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNIComputableValue(
                mode: .stretch
              ),
              height: RNIComputableValue(
                mode: .percent(percentValue: 0.7)
              )
            )
          ),
        ],
        snapDirection: .bottomToTop
      );
      case .test02: return AdaptiveModalConfig(
        snapPoints: [
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .bottom,
              width: RNIComputableValue(
                mode: .stretch
              ),
              height: RNIComputableValue(
                mode: .percent(percentValue: 0.3)
              )
            )
          ),
          AdaptiveModalSnapPointConfig(
            snapPoint: RNILayout(
              horizontalAlignment: .center,
              verticalAlignment: .center,
              width: RNIComputableValue(
                mode: .percent(percentValue: 0.7),
                maxValue: ScreenSize.iPhone8.size.width
              ),
              height: RNIComputableValue(
                mode: .percent(percentValue: 0.7),
                maxValue: ScreenSize.iPhone8.size.height
              )
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalRadiusTopLeft: 20,
              modalRadiusTopRight: 20,
              modalRadiusBottomLeft: 20,
              modalRadiusBottomRight: 20
            )
          ),
        ],
        snapDirection: .bottomToTop,
        interpolationClampingConfig: .init(
          shouldClampModalLastHeight: true,
          shouldClampModalLastWidth: true,
          shouldClampModalLastX: true
        )
      );
    };
  };
};


class RNIDraggableTestViewController : UIViewController {
  
  lazy var modalManager = AdaptiveModalManager(
    modalConfig: AdaptiveModalConfigTestPresets.default.config,
    modalView: self.floatingView,
    targetView: self.view,
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
  
  lazy var floatingView: MaskedView = {
    let view = MaskedView();
    
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
    
    self.modalManager.computeSnapPoints();
    self.modalManager.updateModal();
  };
  
  override func viewDidLayoutSubviews() {
    self.modalManager.computeSnapPoints();
    self.modalManager.updateModal();
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
