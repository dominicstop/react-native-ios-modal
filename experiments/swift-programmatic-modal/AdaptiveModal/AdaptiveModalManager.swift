//
//  AdaptiveModalManager.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/24/23.
//

import UIKit


class AdaptiveModalManager {

  // MARK: -  Properties - Config
  // ----------------------------
  
  var modalConfig: AdaptiveModalConfig;
    
  var currentSnapPointIndex = 0;
  var enableSnapping = true;
  
  // MARK: -  Properties - Refs/Providers
  // ------------------------------------
  
  var targetRectProvider: () -> CGRect;
  var currentSizeProvider: () -> CGSize;

  weak var targetView: UIView?;
  weak var modalView: UIView?;
  
  var gestureOffset: CGFloat?;
  var gestureVelocity: CGPoint?;
  var gestureInitialPoint: CGPoint?;
  var gesturePoint: CGPoint?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var isSwiping: Bool {
    self.gestureInitialPoint != nil
  };
  
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
    
    let snapAnimationConfig = self.modalConfig.snapAnimationConfig;
    
    velocity = velocity.clamped(
      min: -snapAnimationConfig.maxGestureVelocity,
      max:  snapAnimationConfig.maxGestureVelocity
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
    modalConfig: AdaptiveModalConfig,
    modalView: UIView,
    targetView: UIView,
    targetRectProvider: @escaping () -> CGRect,
    currentSizeProvider: @escaping () -> CGSize
  ){
    self.modalConfig = modalConfig;
    
    self.modalView = modalView;
    self.targetView = targetView;
    
    self.targetRectProvider = targetRectProvider;
    self.currentSizeProvider = currentSizeProvider;
  };
  
  // MARK: - Functions
  // -----------------
  
  func clearGestureValues(){
    self.gestureOffset = nil;
    self.gestureInitialPoint = nil;
    self.gestureVelocity = nil;
    self.gesturePoint = nil;
  };
  
  func animateModal(
    toRect nextRect: CGRect,
    duration: CGFloat? = nil
  ) {
    guard let modalView = self.modalView else { return };
    
    let animator: UIViewPropertyAnimator = {
      // A - Animation based on duration
      if let duration = duration {
        return UIViewPropertyAnimator(
          duration: duration,
          curve: .easeInOut
        );
      };
      
      // B - Spring Animation, based on gesture velocity
      if let gestureInitialVelocity = self.gestureInitialVelocity {
        let snapAnimationConfig = self.modalConfig.snapAnimationConfig;
        
        let springTiming = UISpringTimingParameters(
          dampingRatio: snapAnimationConfig.springDampingRatio,
          initialVelocity: gestureInitialVelocity
        );

        return UIViewPropertyAnimator(
          duration: snapAnimationConfig.springAnimationSettlingTime,
          timingParameters: springTiming
        );
      };
      
      // C - Default
      return UIViewPropertyAnimator(
        duration: 0.3,
        curve: .easeInOut
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
    
    let gestureOffset = self.gestureOffset ?? 0;
    let gestureCoordAdj = gestureCoord - gestureOffset;
    
    let delta = snapRects.map {
      abs($0.origin[keyPath: self.inputAxisKey] - gestureCoordAdj);
    };
    
    print(
        "snapRects: \(snapRects.map { $0.origin[keyPath: self.inputAxisKey] })"
      + "\n - delta: \(delta)"
      + "\n - gestureCoord: \(gestureCoord)"
      + "\n - gestureOffset: \(gestureOffset)"
      + "\n - gestureCoordAdj: \(gestureCoordAdj)"
      + "\n"
    );
    
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
  
  func getClosestSnapPoint(
    forRect currentRect: CGRect
  ) -> (
    snapPointIndex: Int,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    computedRect: CGRect,
    snapDistance: CGFloat
  ) {
    let snapRects = self.computedSnapRects;
    
    let delta = snapRects.map {
      CGRect(
        x: abs($0.origin.x - currentRect.origin.x),
        y: abs($0.origin.y - currentRect.origin.y),
        width : abs($0.size.height - currentRect.size.height),
        height: abs($0.size.height - currentRect.size.height)
      );
    };
    
    let deltaAvg = delta.map {
      ($0.origin.x + $0.origin.y + $0.width + $0.height) / 4;
    };
    
    let deltaAvgSorted = deltaAvg.enumerated().sorted {
      $0.element < $1.element;
    };
    
    let closestSnapPoint = deltaAvgSorted.first!;
    let closestSnapPointIndex = closestSnapPoint.offset;
    
    return (
      snapPointIndex: closestSnapPointIndex,
      snapPointConfig: self.modalConfig.snapPoints[closestSnapPointIndex],
      computedRect: snapRects[closestSnapPointIndex],
      snapDistance: deltaAvg[closestSnapPointIndex]
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
  
  // MARK: - User-Invoked Functions
  // ------------------------------
  
  func notifyOnDragPanGesture(_ gesture: UIPanGestureRecognizer){
    guard let modalView = self.modalView else { return };
    
    let gesturePoint = gesture.location(in: self.targetView);
    self.gesturePoint = gesturePoint;
    
    let gestureVelocity = gesture.velocity(in: self.targetView);
    self.gestureVelocity = gestureVelocity;
    
    switch gesture.state {
      case .began:
        self.gestureInitialPoint = gesturePoint;
    
      case .cancelled, .ended:
        guard self.enableSnapping else {
          self.clearGestureValues();
          return;
        };
        
        let gestureFinalPoint = self.gestureFinalPoint ?? gesturePoint;
        
        let closestSnapPoint = self.getClosestSnapPoint(
          forGestureCoord: gestureFinalPoint[keyPath: self.inputAxisKey]
        );
        
        print(
          "closestSnapPoint: \(closestSnapPoint.computedRect)"
          + "\n - gesturePoint: \(gesturePoint)"
          + "\n - gestureFinalPoint: \(gestureFinalPoint)"
        );
        
        self.animateModal(toRect: closestSnapPoint.computedRect);
        self.currentSnapPointIndex = closestSnapPoint.snapPointIndex;
        
        self.clearGestureValues();
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
  
  func setFrameForModal(){
    guard let modalView = self.modalView else { return };
    
    let computedRect: CGRect = {
      if let gesturePoint = self.gesturePoint {
        return self.interpolateModalRect(
          forGesturePoint: gesturePoint
        );
      };
      
      let currentSnapPoint = self.currentSnapPointConfig.snapPoint;
      
      return currentSnapPoint.computeRect(
        withTargetRect: self.targetRectProvider(),
        currentSize: self.currentSizeProvider()
      );
    }();
    
    modalView.frame = computedRect;
  };
  
  func snapToClosestSnapPoint(){
    guard let modalView = self.modalView else { return };
    let targetRect = self.targetRectProvider();
    
    let closestSnapPoint = self.getClosestSnapPoint(forRect: modalView.frame);
    
    let interpolatedDuration = Self.interpolate(
      inputValue: closestSnapPoint.snapDistance,
      rangeInput: [0, targetRect.height],
      rangeOutput: [0.2, 0.7]
    );
    
    self.animateModal(
      toRect: closestSnapPoint.computedRect,
      duration: interpolatedDuration
    );
  };
};
