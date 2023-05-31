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
  
  /// The computed frames of the modal based on the snap points
  var interpolationSteps: [AdaptiveModalInterpolationPoint]?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var modalRect: CGRect? {
    set {
      guard let modalView = self.modalView,
            let newValue = newValue
      else { return };
      
      if let modalPresentationLayer = modalView.layer.presentation() {
        self.prevModalFrame = modalPresentationLayer.frame;
      };
      
      modalView.bounds.size = newValue.size;
      
      modalView.transform = CGAffineTransform(
        translationX: newValue.midX,
        y: newValue.midY
      );
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
    guard let modalView = self.modalView,
          let gestureInitialPoint = self.gestureInitialPoint
    else { return };
    
    let modalRect = modalView.frame;
    
    let gestureCoord        = gesturePoint       [keyPath: self.inputAxisKey];
    let gestureCoordInitial = gestureInitialPoint[keyPath: self.inputAxisKey];
    
    let gestureOffset = self.gestureOffset ?? {
      let modalCoord = modalRect.origin[keyPath: self.inputAxisKey];
      let offset = gestureCoord - modalCoord;
      
      self.gestureOffset = offset;
      return offset;
    }();
      
    let gestureInput = gestureCoord - gestureOffset;
    let gestureInputMin = gestureCoordInitial;
    
    
    
    if let nextModalRect = self.interpolateModalRect(
      forInputValue: gestureInput
    ) {
      self.modalRect = nextModalRect;
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
      self.modalRect = interpolationPoint.computedRect;
      modalView.layer.mask = interpolationPoint.modalRadiusMask
    };
    
    if let completion = completion {
      animator.addCompletion(completion);
    };
    
    animator.addCompletion { _ in
      self.animator = nil;
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
    
    displayLink.preferredFrameRateRange =
      CAFrameRateRange(minimum: 60, maximum: 120);
    
    displayLink.add(to: .current, forMode: .common);
  };
  
  func endDisplayLink() {
    self.displayLink?.invalidate();
  };
  
  @objc func onDisplayLinkTick(displayLink: CADisplayLink){
    return;
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
  
    guard let modalView = self.modalView,
          let modalViewPresentationLayer = modalView.layer.presentation()
    else { return };
    
    if self.isSwiping {
      self.endDisplayLink();
    };
    
    let prevModalFrame = self.prevModalFrame;
    let nextModalFrame = modalViewPresentationLayer.frame;
    
    let inputValueNext = nextModalFrame.origin[keyPath: self.inputAxisKey];
    let inputValuePrev = prevModalFrame.origin[keyPath: self.inputAxisKey];
    
    guard inputValueNext != inputValuePrev else { return  };
    self.prevModalFrame = nextModalFrame;
    
    if let nextModalBorderRadiusMask = self.interpolateModalBorderRadius(
      forInputValue: inputValueNext,
      modalBounds: modalViewPresentationLayer.bounds
    ) {
      modalView.layer.mask = nextModalBorderRadiusMask;
    };

    print(
      "onDisplayLinkTick"
      + "\n - displayLink.timestamp: \(displayLink.timestamp)"
      + "\n - inputValueNext: \(inputValueNext)"
      + "\n - inputValuePrev: \(inputValuePrev)"
    );
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
        self.animator?.stopAnimation(true);
    
      case .changed:
        self.interpolateModal(forGesturePoint: gesturePoint);
        
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
      
      self.modalRect = computedRect;
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
