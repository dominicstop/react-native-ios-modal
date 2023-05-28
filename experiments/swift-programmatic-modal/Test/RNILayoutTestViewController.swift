//
//  RNILayoutTestViewController.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/19/23.
//

import UIKit

enum ScreenSize {

  case iPhone8;
  
  var size: CGSize {
    switch self {
      case .iPhone8:
        return CGSize(width: 375, height: 667);
    };
  };
};

class RNILayoutTestViewController : UIViewController {
  
  lazy var layoutConfigs: [RNILayout] = [
    // 0 A
    RNILayout(
      horizontalAlignment: .left,
      verticalAlignment: .top,
      width: RNIComputableValue(
        mode: .constant(constantValue: 100)
      ),
      height: RNIComputableValue(
        mode: .constant(constantValue: 100)
      )
    ),
    // 1 B
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .top,
      width: RNIComputableValue(
        mode: .constant(constantValue: 100)
      ),
      height: RNIComputableValue(
        mode: .constant(constantValue: 100)
      )
    ),
    // 2 C
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .bottom,
      width: RNIComputableValue(
        mode: .constant(constantValue: 100)
      ),
      height: RNIComputableValue(
        mode: .constant(constantValue: 100)
      )
    ),
    // 3 D
    RNILayout(
      horizontalAlignment: .left,
      verticalAlignment: .bottom,
      width: RNIComputableValue(
        mode: .constant(constantValue: 100)
      ),
      height: RNIComputableValue(
        mode: .constant(constantValue: 100)
      )
    ),
    // 4 E
    RNILayout(
      horizontalAlignment: .left,
      verticalAlignment: .center,
      width: RNIComputableValue(
        mode: .percent(percentValue: 0.5)
      ),
      height: RNIComputableValue(
        mode: .stretch
      )
    ),
    // 5 F
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .center,
      width: RNIComputableValue(
        mode: .percent(percentValue: 0.5)
      ),
      height: RNIComputableValue(
        mode: .stretch
      )
    ),
    // 6 G
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
    // 7 H
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .top,
      width: RNIComputableValue(
        mode: .stretch
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.3)
      )
    ),
    // 8 I
    RNILayout(
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
    // 9 J
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .top,
      width: RNIComputableValue(
        mode: .stretch
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.3)
      ),
      marginLeft: 20,
      marginRight: 20
    ),
    // 10 K
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .bottom,
      width: RNIComputableValue(
        mode: .stretch
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.3)
      ),
      marginLeft: 20,
      marginRight: 20
    ),
    // 11 L
    RNILayout(
      horizontalAlignment: .left,
      verticalAlignment: .center,
      width: RNIComputableValue(
        mode: .percent(percentValue: 0.5)
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.6),
        maxValue: ScreenSize.iPhone8.size.height
      )
    ),
    // 12 M
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .center,
      width: RNIComputableValue(
        mode: .percent(percentValue: 0.5)
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.6),
        maxValue: ScreenSize.iPhone8.size.height
      )
    ),
    // N
    // O = 13
    RNILayout(
      horizontalAlignment: .left,
      verticalAlignment: .center,
      width: RNIComputableValue(
        mode: .percent(percentValue: 0.4)
      ),
      height: RNIComputableValue(
        mode: .stretch,
        maxValue: ScreenSize.iPhone8.size.height
      ),
      marginLeft: 20,
      marginTop: 20,
      marginBottom: 20
    ),
    // P
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .center,
      width: RNIComputableValue(
        mode: .percent(percentValue: 0.4)
      ),
      height: RNIComputableValue(
        mode: .stretch,
        maxValue: ScreenSize.iPhone8.size.height
      ),
      marginRight: 20,
      marginTop: 20,
      marginBottom: 20
    ),
    // Q = 15
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .bottom,
      width: RNIComputableValue(
        mode: .stretch
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.4)
      ),
      marginLeft: 20,
      marginRight: 20,
      marginBottom: 15
    ),
    // R - 16
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .top,
      width: RNIComputableValue(
        mode: .stretch
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.4)
      ),
      marginLeft: 20,
      marginRight: 20,
      marginTop: 20
    ),
    // S
    RNILayout(
      horizontalAlignment: .left,
      verticalAlignment: .top,
      width: RNIComputableValue(
        mode: .constant(constantValue: 100)
      ),
      height: RNIComputableValue(
        mode: .constant(constantValue: 100)
      ),
      marginLeft: 20,
      marginTop: 20
    ),
    // T
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .top,
      width: RNIComputableValue(
        mode: .percent(percentValue: 0.35),
        maxValue: ScreenSize.iPhone8.size.width * 0.6
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.25),
        maxValue: ScreenSize.iPhone8.size.height * 0.5
      ),
      marginRight: 20,
      marginTop: 20
    ),
    // U
    RNILayout(
      horizontalAlignment: .left,
      verticalAlignment: .bottom,
      width: RNIComputableValue(
        mode: .percent(percentValue: 0.4),
        maxValue: ScreenSize.iPhone8.size.width * 0.7
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.4),
        maxValue: ScreenSize.iPhone8.size.height * 0.7
      ),
      marginLeft: 20,
      marginBottom: 20
    ),
    // V
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .bottom,
      width: RNIComputableValue(
        mode: .percent(percentValue: 0.4),
        maxValue: ScreenSize.iPhone8.size.width * 0.7
      ),
      height: RNIComputableValue(
        mode: .percent(percentValue: 0.4),
        maxValue: ScreenSize.iPhone8.size.height * 0.7
      ),
      marginRight: 20,
      marginBottom: 20
    ),
    AdaptiveModalSnapPointPreset.offscreenTop.computeSnapPoint(
      fromSnapPointConfig: RNILayout(
        horizontalAlignment: .left,
        verticalAlignment: .top,
        width: RNIComputableValue(
          mode: .constant(constantValue: 100)
        ),
        height: RNIComputableValue(
          mode: .constant(constantValue: 100)
        )
      ),
      withTargetRect: self.view.frame,
      currentSize: .zero
    ),
  ];
  
  var layoutConfigCount = 0;
  
  var layoutConfigIndex: Int {
    self.layoutConfigCount % layoutConfigs.count;
  };
  
  var layoutConfig: RNILayout {
    return self.layoutConfigs[self.layoutConfigIndex];
  };
  
  lazy var floatingViewLabel: UILabel = {
    let label = UILabel();
    
    label.text = "\(self.layoutConfigIndex)";
    label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5);
    label.font = .boldSystemFont(ofSize: 22);
    
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
      UITapGestureRecognizer(
        target: self,
        action: #selector(self.onPressFloatingView(_:))
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
    
    self.view = view;
    self.updateFloatingView();
  };
  
  override func viewDidLayoutSubviews() {
    self.applyRadiusMaskFor();
  };
  
  func updateFloatingView(){
    let layoutConfig = self.layoutConfig;
    
    let computedRect = layoutConfig.computeRect(
      withTargetRect: self.view.frame,
      currentSize: CGSize(width: 300, height: 300)
    );
    
    let floatingView = self.floatingView;
    floatingView.frame = computedRect;
    
    self.floatingViewLabel.text = "\(self.layoutConfigIndex)";
    self.applyRadiusMaskFor();
  };
  
  @objc func onPressFloatingView(_ sender: UITapGestureRecognizer){
    self.layoutConfigCount += 1;
    self.updateFloatingView();
  };
  
  func applyRadiusMaskFor() {
    let path = UIBezierPath(
      shouldRoundRect  : self.floatingView.bounds,
      topLeftRadius    : 20,
      topRightRadius   : 20,
      bottomLeftRadius : 20,
      bottomRightRadius: 20
    );
    
    let shape = CAShapeLayer();
    shape.path = path.cgPath;
    
    self.floatingView.layer.mask = shape;
  };
};
