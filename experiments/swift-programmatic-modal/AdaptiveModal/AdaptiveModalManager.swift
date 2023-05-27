//
//  AdaptiveModalManager.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/24/23.
//

import UIKit

enum AdaptiveModalConfigTestPresets {
  case test01;
  
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
        snapDirection: .vertical
      );
    };
  };
};

class AdaptiveModalManager {

  // MARK: -  Properties
  // -------------------
  
  let modalConfig: AdaptiveModalConfig =
    AdaptiveModalConfigTestPresets.test01.config;
    
  var currentSnapPointIndex = 1;

  var targetRectProvider: () -> CGRect;
  var currentSizeProvider: () -> CGSize;
  
  let maxGestureVelocity: CGFloat = 20;
  
  weak var targetView: UIView?;
  weak var modalView: UIView?;
  
  var gestureOffset: CGFloat?;
  var gestureVelocity: CGPoint?;
  var gestureInitialPoint: CGPoint?;
  var gesturePoint: CGPoint?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  /// Defines which axis of the gesture point to use to drive the interpolation
  /// of the modal snap points
  ///
  var inputAxisKey: KeyPath<CGPoint, CGFloat> {
    switch self.modalConfig.snapDirection {
      case .vertical  : return \.y;
      case .horizontal: return \.x;
    };
  };
  
  /// The computed frames of the modal based on the snap points
  var computedSnapRects: [CGRect] {
    let targetSize  = self.targetRectProvider();
    let currentSize = self.currentSizeProvider();
    
    return self.modalConfig.snapPoints.map {
      $0.snapPoint.computeRect(
        withTargetRect: targetSize,
        currentSize: currentSize
      );
    };
  };
  
  var currentSnapPointConfig: AdaptiveModalSnapPointConfig {
    self.modalConfig.snapPoints[self.currentSnapPointIndex];
  };
  
  var gestureInitialVelocity: CGVector? {
    guard let gestureInitialPoint = self.gestureInitialPoint,
          let gestureFinalPoint   = self.gesturePoint,
          let gestureVelocity     = self.gestureVelocity
    else { return nil };
  
    let gestureInitialCoord  = gestureInitialPoint[keyPath: self.inputAxisKey];
    let gestureFinalCoord    = gestureFinalPoint  [keyPath: self.inputAxisKey];
    let gestureVelocityCoord = gestureVelocity    [keyPath: self.inputAxisKey];
    
    var velocity: CGFloat = 0;
    let distance = gestureFinalCoord - gestureInitialCoord;
    
    if distance != 0 {
      velocity = gestureVelocityCoord / distance;
    };
    
    velocity = velocity.clamped(
      min: -self.maxGestureVelocity,
      max:  self.maxGestureVelocity
    );
    
    return CGVector(dx: velocity, dy: velocity);
  };
  
  /// Based on the gesture's velocity and it's current position, estimate
  /// where would it eventually "stop" (i.e. it's final position) if it were to
  /// decelerate over time
  ///
  var gestureFinalPoint: CGPoint? {
    guard let gesturePoint = self.gesturePoint,
          let gestureVelocity = self.gestureVelocity
    else { return nil };
    
    let maxVelocity: CGFloat = 300;
    
    let gestureVelocityClamped = CGPoint(
      x: (gestureVelocity.x / 2).clamped(minMax: maxVelocity),
      y: (gestureVelocity.y / 2).clamped(minMax: maxVelocity)
    );
    
    let nextX = Self.computeFinalPosition(
      position: gesturePoint.x,
      initialVelocity: gestureVelocityClamped.x
    );
    
    let nextY = Self.computeFinalPosition(
      position: gesturePoint.y,
      initialVelocity: gestureVelocityClamped.y
    );
    
    return CGPoint(x: nextX, y: nextY);
  };
  
  // MARK: - Init
  // ------------
  
  init(
    modalView: UIView,
    targetView: UIView,
    targetRectProvider: @escaping () -> CGRect,
    currentSizeProvider: @escaping () -> CGSize
  ){
    self.targetRectProvider = targetRectProvider;
    self.currentSizeProvider = currentSizeProvider;
    
    self.modalView = modalView;
    self.targetView = targetView;
  };
  
  // MARK: - Functions
  // -----------------
  
  func setFrameForModal(){
    guard let modalView = self.modalView else { return };
    
    let currentSnapPoint = self.currentSnapPointConfig.snapPoint;
    
    modalView.frame = currentSnapPoint.computeRect(
      withTargetRect: self.targetRectProvider(),
      currentSize: self.currentSizeProvider()
    );
  };
  
  func animateModal(toRect nextRect: CGRect) {
    guard let modalView = self.modalView else { return };
    
    let animator: UIViewPropertyAnimator = {
      if let gestureInitialVelocity = self.gestureInitialVelocity {
        let springTiming = UISpringTimingParameters(
          dampingRatio: 1,
          initialVelocity: gestureInitialVelocity
        );
        
        // Move to animation config
        let springAnimationSettlingTime: CGFloat = 0.4;
        
        return UIViewPropertyAnimator(
          duration: springAnimationSettlingTime,
          timingParameters: springTiming
        );
      };
      
      return UIViewPropertyAnimator(
        duration: 0.2,
        curve: .easeIn
      );
    }();
    
    animator.addAnimations {
      modalView.frame = nextRect;
    };
  
    animator.startAnimation();
  };
  
  func getClosestSnapPoint(
    forGestureCoord gestureCoord: CGFloat
  ) -> (
    snapPointIndex: Int,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    computedRect: CGRect
  ) {
    let snapRects = self.computedSnapRects;
    let gestureCoordAdj = gestureCoord + (self.gestureOffset ?? 0);
    
    let delta = snapRects.map {
      abs($0.origin[keyPath: self.inputAxisKey] - gestureCoordAdj);
    };
    
    let deltaSorted = delta.enumerated().sorted {
      $0.element < $1.element
    };
    
    let closestSnapPoint = deltaSorted.first!;
    let closestSnapPointIndex = closestSnapPoint.offset;
    
    return (
      snapPointIndex: closestSnapPointIndex,
      snapPointConfig: self.modalConfig.snapPoints[closestSnapPointIndex],
      computedRect: snapRects[closestSnapPointIndex]
    );
  };
  
  func interpolateModalRect(
    forGesturePoint gesturePoint: CGPoint
  ) -> CGRect {
  
    guard let modalView = self.modalView else { return .zero };
    
    let targetRect = self.targetRectProvider();
    let modalRect = modalView.frame;
    
    let gestureCoord = gesturePoint[keyPath: self.inputAxisKey];
    let snapRects = self.computedSnapRects.reversed();
    
    let gestureOffset = self.gestureOffset ?? {
      let modalCoord = modalRect.origin[keyPath: self.inputAxisKey];
      return gestureCoord - modalCoord;
    }();
      
    if self.gestureOffset == nil {
      self.gestureOffset = gestureOffset;
    };
    
    let gestureInput = gestureCoord - gestureOffset;
    let rangeInputGesture = snapRects.map { $0.minY };
    
    print(
        "gesturePoint: \(gesturePoint)"
      + "\n" + " - targetRect: \(targetRect)"
      + "\n" + " - gestureInput: \(gestureInput)"
      + "\n" + " - offset: \(gestureOffset)"
      + "\n" + " - snapRects: \(snapRects)"
      + "\n" + " - rangeInputGesture: \(rangeInputGesture)"
    );
    
    let nextHeight = Self.interpolate(
      inputValue: gestureInput,
      rangeInput: rangeInputGesture,
      rangeOutput: snapRects.map { $0.height }
    );
    
    print(" - nextHeight: \(nextHeight!)");
    
    let nextWidth = Self.interpolate(
      inputValue: gestureInput,
      rangeInput: rangeInputGesture,
      rangeOutput: snapRects.map { $0.width }
    );
    
    print(" - nextWidth: \(nextWidth!)");
    
    let nextX = Self.interpolate(
      inputValue: gestureInput,
      rangeInput: rangeInputGesture,
      rangeOutput: snapRects.map { $0.minX }
    );
    
    print(" - nextX: \(nextX!)");
    
    let nextY = Self.interpolate(
      inputValue: gestureInput,
      rangeInput: rangeInputGesture,
      rangeOutput: snapRects.map { $0.minY }
    )!;

    print(" - nextY: \(nextY)");
    
    let nextRect = CGRect(
      x: nextX!,
      y: nextY,
      width: nextWidth!,
      height: nextHeight!
    );
    
    print(
               " - modalRect: \(modalRect)"
      + "\n" + " - nextRect: \(nextRect)"
      + "\n"
    );
    
    return nextRect;
  };
  
  func notifyOnDragPanGesture(_ gesture: UIPanGestureRecognizer){
    guard let modalView = self.modalView else { return };
    
    let gesturePoint = gesture.location(in: self.targetView);
    self.gesturePoint = gesturePoint;
    
    let gestureVelocity = gesture.velocity(in: self.targetView);
    self.gestureVelocity = gestureVelocity;
    
    let gestureVelocityCoord = gestureVelocity[keyPath: self.inputAxisKey];
    
    switch gesture.state {
      case .began:
        self.gestureInitialPoint = gesturePoint;
        break;
    
      case .cancelled, .ended:
        let gestureFinalPoint = self.gestureFinalPoint ?? gesturePoint;
        
        let closestSnapPoint = self.getClosestSnapPoint(
          forGestureCoord: gestureFinalPoint[keyPath: self.inputAxisKey]
        );
        
        self.animateModal(toRect: closestSnapPoint.computedRect);
        self.currentSnapPointIndex = closestSnapPoint.snapPointIndex;
        
        self.gestureOffset = nil;
        self.gestureInitialPoint = nil;
        self.gestureVelocity = nil;
        break;
        
      case .changed:
        let computedRect = self.interpolateModalRect(
          forGesturePoint: gesturePoint
        );

        modalView.frame = computedRect;

      default:
        break;
    };
  };
};
