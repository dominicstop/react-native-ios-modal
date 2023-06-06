//
//  RoundedViewTestViewController.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/4/23.
//

import UIKit

class RoundedView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame);
    
    let bounds = CGRect(
      origin: .zero,
      size: frame.size
    );
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  };
  
  override func layoutSubviews() {
    super.layoutSubviews();
  };
  
  func makeShapeMask(bounds: CGRect) -> CAShapeLayer {
    let path = UIBezierPath(
      shouldRoundRect: bounds,
      topLeftRadius: 30,
      topRightRadius: 30,
      bottomLeftRadius: 30,
      bottomRightRadius: 30
    );
    
    let shape = CAShapeLayer();
    shape.path = path.cgPath;
    
    return shape;
  };
};

class RoundedViewTestViewController: UIViewController {

  lazy var roundedView: RoundedView = {
    let view = RoundedView(frame: CGRect(
      origin: .zero,
      size: CGSize(width: 150, height: 150)
      )
    );
    
    view.backgroundColor = .red;
    
    return view;
  }();
  
  override func viewDidLoad() {
    self.view.backgroundColor = .systemBackground;
  
    let roundedView = self.roundedView;
    roundedView.center = self.view.center;
    roundedView.frame = roundedView.frame.offsetBy(dx: 0, dy: -200)
  
    self.view.addSubview(roundedView);
    
    let prevFrame = roundedView.frame;
    let prevBounds = roundedView.bounds;
    
    var nextFrame = roundedView.frame.offsetBy(dx: 0, dy: 300);
    nextFrame.size = CGSize(
      width: nextFrame.width + 100,
      height: nextFrame.height + 100
    );
    
    let nextBounds = CGRect(
      origin: .zero,
      size: nextFrame.size
    );
    
    let prevMask: CAShapeLayer = {
      let path = UIBezierPath(
        shouldRoundRect: prevBounds,
        topLeftRadius: 10,
        topRightRadius: 10,
        bottomLeftRadius: 10,
        bottomRightRadius: 10
      );
      
      let shape = CAShapeLayer();
      shape.path = path.cgPath;
      
      return shape;
    }();
    
    let nextMask: CAShapeLayer = {
      let path = UIBezierPath(
        shouldRoundRect: nextBounds,
        topLeftRadius: 30,
        topRightRadius: 30,
        bottomLeftRadius: 30,
        bottomRightRadius: 30
      );
      
      let shape = CAShapeLayer();
      shape.path = path.cgPath;
      
      return shape;
    }();
    
    let viewAnimator = UIViewPropertyAnimator(
      duration: 4,
      curve: .easeInOut
    );
    
    roundedView.translatesAutoresizingMaskIntoConstraints = false;

    viewAnimator.addAnimations {
      UIView.addKeyframe(
        withRelativeStartTime: 0,
        relativeDuration: 0
      ) {
        roundedView.frame = prevFrame;
        //roundedView.layer.frame = prevFrame;
        //roundedView.layer.mask = prevMask;
      };
      
      UIView.addKeyframe(
        withRelativeStartTime: 1,
        relativeDuration: 0
      ) {
        roundedView.frame = nextFrame;
        //roundedView.layer.frame = nextFrame;
        //roundedView.layer.mask = nextMask;
      };
    };
    
    
    // define your new path to animate the mask layer to
    //let path = UIBezierPath(roundedRect: CGRectInset(view.bounds, 100, 100), cornerRadius: 20.0)
    //path.appendPath(UIBezierPath(rect: view.bounds))

    // create new animation
    let pathAnimator = CABasicAnimation(keyPath: "path");
    
    let shapeMask = CAShapeLayer();
    
    let prevPath = UIBezierPath(
      shouldRoundRect: prevBounds,
      topLeftRadius: 10,
      topRightRadius: 10,
      bottomLeftRadius: 10,
      bottomRightRadius: 10
    );

    // from value is the current mask path
    pathAnimator.fromValue = prevPath.cgPath;
    
    let nextPath = UIBezierPath(
      shouldRoundRect: nextBounds,
      topLeftRadius: 25,
      topRightRadius: 25,
      bottomLeftRadius: 25,
      bottomRightRadius: 25
    );

    // to value is the new path
    pathAnimator.toValue = nextPath.cgPath;

    // duration of your animation
    pathAnimator.duration = viewAnimator.duration;

    // custom timing function to make it look smooth
    pathAnimator.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut);
    
    pathAnimator.isRemovedOnCompletion = false;
    pathAnimator.fillMode = .both;

    // add animation
    shapeMask.add(pathAnimator, forKey: nil);

    // update the path property on the mask layer, using a CATransaction to prevent an implicit animation
    CATransaction.begin();
    
    roundedView.layer.mask = shapeMask;
    CATransaction.commit();
    
    
    
    
    
    viewAnimator.startAnimation();
  };
};

