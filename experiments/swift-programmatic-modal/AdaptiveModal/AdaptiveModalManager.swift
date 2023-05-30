//
//  AdaptiveModalManager.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/24/23.
//

import UIKit


class AdaptiveModalManager {

  // MARK: -  Properties - Config-Related
  // ------------------------------------
  
  var modalConfig: AdaptiveModalConfig;
    
  var currentSnapPointIndex = 0;
  var enableSnapping = true;
  
  // MARK: -  Properties - Refs/Providers
  // ------------------------------------

  var currentSizeProvider: () -> CGSize;

  weak var targetView: UIView?;
  weak var modalView: UIView?;
  
  var gestureOffset: CGFloat?;
  var gestureVelocity: CGPoint?;
  var gestureInitialPoint: CGPoint?;
  var gesturePoint: CGPoint?;
  
  var prevModalFrame: CGRect = .zero;
  
  // MARK: -  Properties
  // -------------------
  
  var animator: UIViewPropertyAnimator?;
  
  var displayLink: CADisplayLink?;
  var displayLinkTimestampStart: CFTimeInterval?;
  
  /// The computed frames of the modal based on the snap points
  var interpolationSteps: [AdaptiveModalInterpolationPoint]?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var modalFrame: CGRect? {
    set {
      guard let modalView = self.modalView,
            let newValue = newValue
      else { return };
      
      self.prevModalFrame = modalView.frame;
      modalView.frame = newValue;
    }
    get {
      self.modalView?.frame;
    }
  };
  
  var isSwiping: Bool {
    self.gestureInitialPoint != nil
  };
  
  /// Defines which axis of the gesture point to use to drive the interpolation
  /// of the modal snap points
  ///
  var inputAxisKey: KeyPath<CGPoint, CGFloat> {
    switch self.modalConfig.snapDirection {
      case .topToBottom, .bottomToTop: return \.y;
      case .leftToRight, .rightToLeft: return \.x;
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

  // sorted based on the modal direction
  var interpolationStepsSorted: [AdaptiveModalInterpolationPoint]? {
    guard let interpolationSteps = self.interpolationSteps else { return nil };
    return self.modalConfig.sortInterpolationSteps(interpolationSteps);
  };
  
  var interpolationRangeInput: [CGFloat]? {
    self.interpolationStepsSorted?.map {
      $0.computedRect.origin[keyPath: self.inputAxisKey];
    };
  };
  
  var animationEndTimestamp: CFTimeInterval? {
    guard let startTimestamp = self.displayLinkTimestampStart,
          let animator = self.animator
    else { return nil };
    
    return startTimestamp + animator.duration;
  };
  
  // MARK: - Init
  // ------------
  
  init(
    modalConfig: AdaptiveModalConfig,
    modalView: UIView,
    targetView: UIView,
    currentSizeProvider: @escaping () -> CGSize
  ) {
    self.modalConfig = modalConfig;
    
    self.modalView = modalView;
    self.targetView = targetView;
    self.currentSizeProvider = currentSizeProvider;
  };
  

  // MARK: - Functions - Interpolation-Related
  // -----------------------------------------
  
  func interpolateModalRect(
    forInputValue inputValue: CGFloat,
    rangeInput: [CGFloat]? = nil,
    rangeOutput: [AdaptiveModalInterpolationPoint]? = nil
  ) -> CGRect? {
  
    guard let interpolationSteps      = rangeOutput ?? self.interpolationStepsSorted,
          let interpolationRangeInput = rangeInput  ?? self.interpolationRangeInput
    else { return nil };

    let clampConfig = modalConfig.interpolationClampingConfig;

    let nextHeight = Self.interpolate(
      inputValue: inputValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.computedRect.height
      },
      shouldClampMin: clampConfig.shouldClampModalLastHeight,
      shouldClampMax: clampConfig.shouldClampModalInitHeight
    );
    
    let nextWidth = Self.interpolate(
      inputValue: inputValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.computedRect.width
      },
      shouldClampMin: clampConfig.shouldClampModalLastWidth,
      shouldClampMax: clampConfig.shouldClampModalInitWidth
    );
    
    let nextX = Self.interpolate(
      inputValue: inputValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.computedRect.minX
      },
      shouldClampMin: clampConfig.shouldClampModalLastX,
      shouldClampMax: clampConfig.shouldClampModalInitX
    );
    
    let nextY = Self.interpolate(
      inputValue: inputValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.computedRect.minY
      },
      shouldClampMin: clampConfig.shouldClampModalLastY,
      shouldClampMax: clampConfig.shouldClampModalInitY
    );
    
    guard let nextX = nextX,
          let nextY = nextY,
          let nextWidth  = nextWidth,
          let nextHeight = nextHeight
    else { return nil };
          
    return CGRect(
      x: nextX,
      y: nextY,
      width: nextWidth,
      height: nextHeight
    );
  };
  
  func interpolateModalBorderRadius(
    forInputValue inputValue: CGFloat,
    modalBounds: CGRect,
    rangeInput: [CGFloat]? = nil,
    rangeOutput: [AdaptiveModalInterpolationPoint]? = nil
  ) -> CAShapeLayer? {
  
    guard let interpolationSteps      = rangeOutput ?? self.interpolationStepsSorted,
          let interpolationRangeInput = rangeInput  ?? self.interpolationRangeInput
    else { return nil };
    
    let radiusBottomLeft = Self.interpolate(
      inputValue: inputValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.modalRadiusBottomLeft
      }
    );
    
    let radiusBottomRight = Self.interpolate(
      inputValue: inputValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.modalRadiusBottomRight
      }
    );
    
    let radiusTopLeft = Self.interpolate(
      inputValue: inputValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.modalRadiusTopLeft
      }
    );
    
    let radiusTopRight = Self.interpolate(
      inputValue: inputValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.modalRadiusTopRight
      }
    );
    
    guard let radiusTopLeft     = radiusTopLeft,
          let radiusTopRight    = radiusTopRight,
          let radiusBottomLeft  = radiusBottomLeft,
          let radiusBottomRight = radiusBottomRight
    else { return nil };
    
    let nextRadiusPath = UIBezierPath(
      shouldRoundRect  : modalBounds,
      topLeftRadius    : radiusTopLeft,
      topRightRadius   : radiusTopRight,
      bottomLeftRadius : radiusBottomLeft,
      bottomRightRadius: radiusBottomRight
    );
    
    let shape = CAShapeLayer();
    shape.path = nextRadiusPath.cgPath;
    
    return shape;
  };
  
  func interpolateModal(forGesturePoint gesturePoint: CGPoint){
    guard let modalView = self.modalView else { return };
    let modalRect = modalView.frame;
    
    let gestureCoord = gesturePoint[keyPath: self.inputAxisKey];
    
    let gestureOffset = self.gestureOffset ?? {
      let modalCoord = modalRect.origin[keyPath: self.inputAxisKey];
      let offset = gestureCoord - modalCoord;
      
      self.gestureOffset = offset;
      return offset;
    }();
      
    let gestureInput = gestureCoord - gestureOffset;
    
    if let nextModalRect = self.interpolateModalRect(
      forInputValue: gestureInput
    ) {
      self.modalFrame = nextModalRect;
    };
    
    if let modalBorderRadiusMask = self.interpolateModalBorderRadius(
      forInputValue: gestureInput,
      modalBounds: modalView.bounds
    ) {
      modalView.layer.mask = modalBorderRadiusMask;
    };
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
    to interpolationPoint: AdaptiveModalInterpolationPoint,
    duration: CGFloat? = nil,
    completion: ((UIViewAnimatingPosition) -> Void)? = nil
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
    
    self.animator = animator;
    
    animator.addAnimations {
      modalView.frame = interpolationPoint.computedRect;
    };
    
    if let completion = completion {
      animator.addCompletion(completion);
    };
    
    animator.addCompletion{ _ in
      self.animator = nil;
      //self.modalFrame = interpolationPoint.computedRect;
    };

    animator.startAnimation();
  };
  
  func getClosestSnapPoint(
    forGestureCoord gestureCoord: CGFloat
  ) -> (
    snapPointIndex: Int,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    interpolationPoint: AdaptiveModalInterpolationPoint
  )? {
    guard let interpolationSteps = self.interpolationSteps else { return nil };
    
    let gestureOffset = self.gestureOffset ?? 0;
    let gestureCoordAdj = gestureCoord - gestureOffset;
    
    let delta = interpolationSteps.map {
      abs($0.computedRect.origin[keyPath: self.inputAxisKey] - gestureCoordAdj);
    };
    
    print(
        "snapRects: \(interpolationSteps.map { $0.computedRect.origin[keyPath: self.inputAxisKey] })"
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
      interpolationPoint: interpolationSteps[closestSnapPointIndex]
    );
  };
  
  func getClosestSnapPoint(
    forRect currentRect: CGRect
  ) -> (
    snapPointIndex: Int,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    interpolationPoint: AdaptiveModalInterpolationPoint,
    snapDistance: CGFloat
  )? {
    guard let interpolationSteps = self.interpolationSteps else { return nil };
    
    let delta = interpolationSteps.map {
      CGRect(
        x: abs($0.computedRect.origin.x - currentRect.origin.x),
        y: abs($0.computedRect.origin.y - currentRect.origin.y),
        width : abs($0.computedRect.size.height - currentRect.size.height),
        height: abs($0.computedRect.size.height - currentRect.size.height)
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
      interpolationPoint: interpolationSteps[closestSnapPointIndex],
      snapDistance: deltaAvg[closestSnapPointIndex]
    );
  };
  
    
  func startDisplayLink() {
    let displayLink = CADisplayLink(
      target: self,
      selector: #selector(self.onDisplayLinkTick(displayLink:))
    );
    
    self.displayLink = displayLink;
    displayLink.add(to: .current, forMode: .default);
  };
  
  func endDisplayLink() {
    self.displayLink?.invalidate();
    self.displayLinkTimestampStart = nil;
  };
  
  @objc func onDisplayLinkTick(displayLink: CADisplayLink){
    /// `Note:2023-05-30-16-13-29`
    ///
    /// The interpolation can be driven by either via **Method-A** or
    /// **Method-B**.
    ///
    /// * **Method-A** - Use the `modalView`'s position for the
    ///   interpolation input.
    ///
    /// * **Method-B** - Use the current `CADisplayLink.timestamp` for the
    ///   interpolation input.
    ///
    ///   * When the `modalView` is being animated via `UIViewPropertyAnimator`,
    ///     it's `CGRect.origin` does not update until the animation is
    ///     completed.
    ///
    ///   * Therefore we can't use the `modalView`'s position to drive the
    ///     interpolation, since it's "position data" does not update during the
    ///     course of the animation.
    ///
    ///   * As such, we need to resort to using the current time as the input
    ///     to drive the interpolation.
    ///
  
    guard let modalView = self.modalView else { return };
    
    if self.displayLinkTimestampStart == nil {
      self.displayLinkTimestampStart = displayLink.timestamp;
    };
    
    /// Will be `nil` if using **Method-A**.
    ///
    /// The interpolation input range if using **Method-B**, i.e., the
    /// timestamp of when the modal animation begins and ends.
    ///
    let rangeInput: [CGFloat]? = {
      guard let timestampStart = self.displayLinkTimestampStart,
            let timestampEnd   = self.animationEndTimestamp
      else { return nil };
      
      return [timestampStart, timestampEnd];
    }();
    
    let inputValue = rangeInput != nil
      ? displayLink.timestamp
      : modalView.frame.origin[keyPath: self.inputAxisKey];
    
    let nextModalBorderRadiusMask: CAShapeLayer? = {
    
      /// Will be `nil` if using **Method-A**
      /// The interpolation output range if using **Method-B**.
      ///
      let rangeOutput: [AdaptiveModalInterpolationPoint]? = {
        guard rangeInput != nil else { return nil };
      
        let indexNext = self.currentSnapPointIndex;
        let indexPrev = indexNext - 1;
      
        guard let interpolationSteps = self.interpolationSteps,
              let nextStep = interpolationSteps[safeIndex: indexNext],
              let prevStep = interpolationSteps[safeIndex: indexPrev]
        else { return nil };
        
        return [prevStep, nextStep];
      }();
      
      if let rangeInput = rangeInput,
         let rangeOutput = rangeOutput {
        
        let modalFrameRect = self.interpolateModalRect(
          forInputValue: inputValue,
          rangeInput: rangeInput,
          rangeOutput: rangeOutput
        );
        
        let modalBoundsRect = CGRect(
          origin: .zero,
          size: modalFrameRect!.size
        );
        
        return self.interpolateModalBorderRadius(
          forInputValue: inputValue,
          modalBounds: modalBoundsRect,
          rangeInput: rangeInput,
          rangeOutput: rangeOutput
        );
      };
    
      return self.interpolateModalBorderRadius(
        forInputValue: inputValue,
        modalBounds: modalView.bounds
      );
    }();
    
    print(
      "onDisplayLinkTick"
      + "\n - displayLink.timestamp: \(displayLink.timestamp)"
      + "\n - inputValue: \(inputValue)"
      + "\n - rangeInput: \(rangeInput)"
    );
    
    //guard inputValueNext != inputValuePrev else { return  };
    
    if let nextModalBorderRadiusMask = nextModalBorderRadiusMask {
      modalView.layer.mask = nextModalBorderRadiusMask;
    };
  };
  
  
  // MARK: - User-Invoked Functions
  // ------------------------------
  
  func computeSnapPoints() {
    guard let targetView = self.targetView else { return };
    let currentSize = self.currentSizeProvider();
    
    self.interpolationSteps = .Element.compute(
      usingModalConfig: self.modalConfig,
      withTargetRect: targetView.frame,
      currentSize: currentSize
    );
  };
  
  func notifyOnDragPanGesture(_ gesture: UIPanGestureRecognizer){
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
        let gestureFinalCoord = gestureFinalPoint[keyPath: self.inputAxisKey];
        
        let closestSnapPoint =
          self.getClosestSnapPoint(forGestureCoord: gestureFinalCoord);
        
        guard let closestSnapPoint = closestSnapPoint else {
          self.clearGestureValues();
          return;
        };
        
        self.animateModal(to: closestSnapPoint.interpolationPoint) { _ in
          self.endDisplayLink();
        };
        
        self.startDisplayLink();
        
        self.currentSnapPointIndex = closestSnapPoint.snapPointIndex;
        self.clearGestureValues();
        break;
        
      case .changed:
        self.interpolateModal(forGesturePoint: gesturePoint);

      default:
        break;
    };
  };
  
  func updateModal(){
    guard let targetView = self.targetView else { return };
    
    if let gesturePoint = self.gesturePoint {
      self.interpolateModal(forGesturePoint: gesturePoint);
      
    } else {
      let currentSnapPoint = self.currentSnapPointConfig.snapPoint;
      
      let computedRect = currentSnapPoint.computeRect(
        withTargetRect: targetView.frame,
        currentSize: self.currentSizeProvider()
      );
      
      self.modalFrame = computedRect;
    };
  };
  
  func snapToClosestSnapPoint(){
    guard let modalView = self.modalView,
          let targetView = self.targetView,
          let closestSnapPoint =
            self.getClosestSnapPoint(forRect: modalView.frame)
    else { return };
    
    let interpolatedDuration = Self.interpolate(
      inputValue: closestSnapPoint.snapDistance,
      rangeInput: [0, targetView.frame.height],
      rangeOutput: [0.2, 0.7]
    );
    
    self.animateModal(
      to: closestSnapPoint.interpolationPoint,
      duration: interpolatedDuration
    );
  };
};
