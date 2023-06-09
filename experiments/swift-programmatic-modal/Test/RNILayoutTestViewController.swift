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
      width: RNILayoutValue(
        mode: .constant(100)
      ),
      height: RNILayoutValue(
        mode: .constant(100)
      ),
      marginLeft: .safeAreaInsets(insetKey: \.left),
      marginTop: .safeAreaInsets(insetKey: \.top)
    ),
    // 1 B
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .top,
      width: RNILayoutValue(
        mode: .constant(100)
      ),
      height: RNILayoutValue(
        mode: .constant(100)
      ),
      marginRight: .safeAreaInsets(insetKey: \.right),
      marginTop: .safeAreaInsets(insetKey: \.top)
    ),
    // 2 C
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .bottom,
      width: RNILayoutValue(
        mode: .constant(100)
      ),
      height: RNILayoutValue(
        mode: .constant(100)
      )
    ),
    // 3 D
    RNILayout(
      horizontalAlignment: .left,
      verticalAlignment: .bottom,
      width: RNILayoutValue(
        mode: .constant(100)
      ),
      height: RNILayoutValue(
        mode: .constant(100)
      )
    ),
    // 4 E
    RNILayout(
      horizontalAlignment: .left,
      verticalAlignment: .center,
      width: RNILayoutValue(
        mode: .percent(percentValue: 0.5)
      ),
      height: RNILayoutValue(
        mode: .stretch
      )
    ),
    // 5 F
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .center,
      width: RNILayoutValue(
        mode: .percent(percentValue: 0.5)
      ),
      height: RNILayoutValue(
        mode: .stretch
      )
    ),
    // 6 G
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .bottom,
      width: RNILayoutValue(
        mode: .stretch
      ),
      height: RNILayoutValue(
        mode: .percent(percentValue: 0.3)
      )
    ),
    // 7 H
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .top,
      width: RNILayoutValue(
        mode: .stretch
      ),
      height: RNILayoutValue(
        mode: .percent(percentValue: 0.3)
      )
    ),
    // 8 I
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .center,
      width: RNILayoutValue(
        mode: .percent(percentValue: 0.7),
        maxValue: .constant(ScreenSize.iPhone8.size.width)
      ),
      height: RNILayoutValue(
        mode: .percent(percentValue: 0.7),
        maxValue: .constant(ScreenSize.iPhone8.size.height)
      )
    ),
    // 9 J
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .top,
      width: RNILayoutValue(
        mode: .stretch
      ),
      height: RNILayoutValue(
        mode: .percent(percentValue: 0.3)
      ),
      marginLeft: .constant(20),
      marginRight: .constant(20)
    ),
    // 10 K
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .bottom,
      width: RNILayoutValue(
        mode: .stretch
      ),
      height: RNILayoutValue(
        mode: .percent(percentValue: 0.3)
      ),
      marginLeft: .constant(20),
      marginRight: .constant(20)
    ),
    // 11 L
    RNILayout(
      horizontalAlignment: .left,
      verticalAlignment: .center,
      width: RNILayoutValue(
        mode: .percent(percentValue: 0.5)
      ),
      height: RNILayoutValue(
        mode: .percent(percentValue: 0.6),
        maxValue: .constant(ScreenSize.iPhone8.size.height)
      )
    ),
    // 12 M
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .center,
      width: RNILayoutValue(
        mode: .percent(percentValue: 0.5)
      ),
      height: RNILayoutValue(
        mode: .percent(percentValue: 0.6),
        maxValue: .constant(ScreenSize.iPhone8.size.height)
      )
    ),
    // N
    // O = 13
    RNILayout(
      horizontalAlignment: .left,
      verticalAlignment: .center,
      width: RNILayoutValue(
        mode: .percent(percentValue: 0.4)
      ),
      height: RNILayoutValue(
        mode: .stretch,
        maxValue: .constant(ScreenSize.iPhone8.size.height)
      ),
      marginLeft: .constant(20),
      marginTop: .constant(20),
      marginBottom: .constant(20)
    ),
    // P
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .center,
      width: RNILayoutValue(
        mode: .percent(percentValue: 0.4)
      ),
      height: RNILayoutValue(
        mode: .stretch,
        maxValue: .constant(ScreenSize.iPhone8.size.height)
      ),
      marginRight: .constant(20),
      marginTop: .constant(20),
      marginBottom: .constant(20)
    ),
    // Q = 15
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .bottom,
      width: RNILayoutValue(
        mode: .stretch
      ),
      height: RNILayoutValue(
        mode: .percent(percentValue: 0.4)
      ),
      marginLeft: .constant(20),
      marginRight: .constant(20),
      marginBottom: .constant(15)
    ),
    // R - 16
    RNILayout(
      horizontalAlignment: .center,
      verticalAlignment: .top,
      width: RNILayoutValue(
        mode: .stretch
      ),
      height: RNILayoutValue(
        mode: .percent(percentValue: 0.4)
      ),
      marginLeft: .constant(20),
      marginRight: .constant(20),
      marginTop: .constant(20)
    ),
    // S
    RNILayout(
      horizontalAlignment: .left,
      verticalAlignment: .top,
      width: RNILayoutValue(
        mode: .constant(100)
      ),
      height: RNILayoutValue(
        mode: .constant(100)
      ),
      marginLeft: .constant(20),
      marginTop: .constant(20)
    ),
    // T
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .top,
      width: RNILayoutValue(
        mode: .percent(percentValue: 0.35),
        maxValue: .constant(ScreenSize.iPhone8.size.width * 0.6)
      ),
      height: RNILayoutValue(
        mode: .percent(percentValue: 0.25),
        maxValue: .constant(ScreenSize.iPhone8.size.height * 0.5)
      ),
      marginRight: .constant(20),
      marginTop: .constant(20)
    ),
    // U
    RNILayout(
      horizontalAlignment: .left,
      verticalAlignment: .bottom,
      width: RNILayoutValue(
        mode: .percent(percentValue: 0.4),
        maxValue: .constant(ScreenSize.iPhone8.size.width * 0.7)
      ),
      height: RNILayoutValue(
        mode: .percent(percentValue: 0.4),
        maxValue: .constant(ScreenSize.iPhone8.size.height * 0.7)
      ),
      marginLeft: .constant(20),
      marginBottom: .constant(20)
    ),
    // V
    RNILayout(
      horizontalAlignment: .right,
      verticalAlignment: .bottom,
      width: RNILayoutValue(
        mode: .percent(percentValue: 0.4),
        maxValue: .constant(ScreenSize.iPhone8.size.width * 0.7)
      ),
      height: RNILayoutValue(
        mode: .percent(percentValue: 0.4),
        maxValue: .constant(ScreenSize.iPhone8.size.height * 0.7)
      ),
      marginRight: .constant(20),
      marginBottom: .constant(20)
    ),
    RNILayoutPreset.halfOffscreenTop.getLayoutConfig(
      fromBaseLayoutConfig: RNILayout(
        horizontalAlignment: .left,
        verticalAlignment: .top,
        width: RNILayoutValue(
          mode: .constant(100)
        ),
        height: RNILayoutValue(
          mode: .constant(100)
        )
      )
    ),
  ];
  
  var layoutConfigCount = 0;
  
  var layoutConfigIndex: Int {
    self.layoutConfigCount % layoutConfigs.count;
  };
  
  var layoutConfig: RNILayout {
    return self.layoutConfigs[self.layoutConfigIndex];
  };
  
  var layoutValueContext: RNILayoutValueContext? {
    .init(fromTargetViewController: self)
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
  };
  
  override func viewDidLayoutSubviews() {
    self.updateFloatingView();
    // self.applyRadiusMaskFor();
  };
  
  func updateFloatingView(){
    guard let layoutValueContext = self.layoutValueContext else { return };
    
    let layoutConfig = self.layoutConfig;
    
    let computedRect = layoutConfig.computeRect(
      usingLayoutValueContext: layoutValueContext
    );
    
    let floatingView = self.floatingView;
    floatingView.frame = computedRect;
    
    self.floatingViewLabel.text = "\(self.layoutConfigIndex)";
    //self.applyRadiusMaskFor();
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
