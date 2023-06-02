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
            ),
            animationKeyframe: AdaptiveModalAnimationConfig(
              modalCornerRadius: 15,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
              ],
              backgroundVisualEffect: UIBlurEffect(style: .regular),
              backgroundVisualEffectIntensity: 0
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
              modalCornerRadius: 20,
              modalMaskedCorners: [
                .layerMinXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMinYCorner,
                .layerMaxXMaxYCorner
              ],
              backgroundVisualEffect: UIBlurEffect(style: .regular),
              backgroundVisualEffectIntensity: 0.5
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
    backgroundVisualEffectView: self.backgroundVisualEffectView,
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
      saturation: 0/100,
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
  
  lazy var backgroundVisualEffectView = UIVisualEffectView();
  
  lazy var dummyBackgroundView: UIView = {
    let view = UIView();
    
    let imageView = UIImageView(
      image: UIImage(named: "DummyBackgroundImage")
    );
    
    imageView.contentMode = .scaleAspectFill;
    
    view.addSubview(imageView);
    
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: view.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ]);
    
    return view;
  }();

  override func viewDidLoad() {
    self.view.backgroundColor = .white;
    
    let dummyBackgroundView = self.dummyBackgroundView;
    self.view.addSubview(dummyBackgroundView);
    
    let backgroundVisualEffectView = self.backgroundVisualEffectView;
    self.view.addSubview(backgroundVisualEffectView);
    
    // backgroundVisualEffectView.effect = nil;
    
    let floatingView = self.floatingView;
    self.view.addSubview(floatingView);
    
    self.floatingViewLabel.text = "\(self.modalManager.currentSnapPointIndex)";
    
    dummyBackgroundView.translatesAutoresizingMaskIntoConstraints = false;
    backgroundVisualEffectView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      dummyBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
      dummyBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      dummyBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      dummyBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      
      backgroundVisualEffectView.topAnchor.constraint(equalTo: self.view.topAnchor),
      backgroundVisualEffectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      backgroundVisualEffectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      backgroundVisualEffectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
    ]);
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
