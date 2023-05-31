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
  
  var gestureOffset: CGPoint?;
  var gestureVelocity: CGPoint?;
  var gestureInitialPoint: CGPoint?;
  var gesturePoint: CGPoint?;
  
  var prevModalFrame: CGRect = .zero;
  
  var modalViewMaskedCornersAnimator: AdaptiveModalPropertyAnimator?;
  
  // MARK: -  Properties
  // -------------------
  
  var animator: UIViewPropertyAnimator?;
  var displayLink: CADisplayLink?;
  
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
  
  var currentInterpolationStep: AdaptiveModalInterpolationPoint? {
    self.interpolationSteps?[self.currentSnapPointIndex];
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
  ) -> CGFloat? {
  
    guard let interpolationSteps      = rangeOutput ?? self.interpolationStepsSorted,
          let interpolationRangeInput = rangeInput  ?? self.interpolationRangeInput
    else { return nil };
    
    let modalCornerRadius = Self.interpolate(
      inputValue: inputValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.modalCornerRadius
      }
    );
    
    guard let modalCornerRadius = modalCornerRadius else { return nil };
    return modalCornerRadius;
  };
  
  func applyInterpolationToModalMaskedCorners(
    forInputValue inputValue: CGFloat
  ) {
    guard let modalView = self.modalView,
          let inputRange = self.getInterpolationStepRange(
            forInputValue: inputValue
          )
    else { return };
    
    let animator: AdaptiveModalPropertyAnimator = {
      if var animator = self.modalViewMaskedCornersAnimator {
        animator.update(
          interpolationRangeStart: inputRange.rangeStart,
          interpolationRangeEnd: inputRange.rangeEnd
        );
        
        return animator;
      };
      
      return AdaptiveModalPropertyAnimator(
        interpolationRangeStart: inputRange.rangeStart,
        interpolationRangeEnd: inputRange.rangeEnd,
        forComponent: modalView,
        withInputAxisKey: self.inputAxisKey
      ) {
        $0.layer.maskedCorners = $1.modalMaskedCorners;
      };
    }();
    
    animator.setFractionComplete(forInputValue: inputValue);
  };
  
  func applyInterpolationToModal(forPoint point: CGPoint){
    guard let modalView = self.modalView else { return };
    let inputValue = point[keyPath: self.inputAxisKey];
    
    let nextModalRect = self.interpolateModalRect(
      forInputValue: inputValue
    );
    
    let nextModalRadius = self.interpolateModalBorderRadius(
      forInputValue: inputValue,
      modalBounds: modalView.bounds
    );
    
    if let nextModalRect = nextModalRect{
      self.modalFrame = nextModalRect;
    };
    
    if let nextModalRadius = nextModalRadius  {
      modalView.layer.cornerRadius = nextModalRadius;
    };
    
    self.applyInterpolationToModalMaskedCorners(forInputValue: inputValue);
  };
  
  func applyInterpolationToModal(forGesturePoint gesturePoint: CGPoint){
    guard let modalView = self.modalView,
          let gestureInitialPoint = self.gestureInitialPoint
    else { return };
    
    let modalRect = modalView.frame;

    let gestureOffset = self.gestureOffset ?? {
      return CGPoint(
        x: gestureInitialPoint.x - modalRect.origin.x,
        y: gestureInitialPoint.y - modalRect.origin.y
      );
    }();
    
    if self.gestureOffset == nil {
      self.gestureOffset = gestureOffset;
    };
      
    let gestureInputPoint = CGPoint(
      x: gesturePoint.x - gestureOffset.x,
      y: gesturePoint.y - gestureOffset.y
    );
  
    self.applyInterpolationToModal(forPoint: gestureInputPoint);
  };
  
  // MARK: - Functions
  // -----------------
  
  func clearGestureValues(){
    self.gestureOffset = nil;
    self.gestureInitialPoint = nil;
    self.gestureVelocity = nil;
    self.gesturePoint = nil;
  };
  
  func clearAnimators(){
    self.modalViewMaskedCornersAnimator = nil;
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
      interpolationPoint.apply(toModalView: modalView);
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
    guard let interpolationSteps = self.interpolationSteps,
          let modalView = self.modalView
    else { return nil };
    
    let inputCoord = modalView.frame.origin[keyPath: self.inputAxisKey];
    
    let delta = interpolationSteps.map {
      abs($0.computedRect.origin[keyPath: self.inputAxisKey] - inputCoord);
    };
    
    let deltaSorted = delta.enumerated().sorted {
      $0.element < $1.element
    };
    
    let closestSnapPoint = deltaSorted.first!;
    
    let closestSnapPointIndex = min(
      closestSnapPoint.offset,
      self.modalConfig.snapPointLastIndex
    );
    
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
  
  func getInterpolationStepRange(
   forInputValue inputValue: CGFloat
  ) -> (
    rangeStart: AdaptiveModalInterpolationPoint,
    rangeEnd: AdaptiveModalInterpolationPoint
  )? {
    guard let interpolationSteps = self.interpolationSteps,
          let minStep = interpolationSteps.first,
          let maxStep = interpolationSteps.last
    else { return nil };
    
    let lastIndex = interpolationSteps.count - 1;
    
    if inputValue <= minStep.computedRect.origin[keyPath: self.inputAxisKey]{
      return (
        rangeStart: minStep,
        rangeEnd: interpolationSteps[1]
      );
    };
    
    if inputValue >= maxStep.computedRect.origin[keyPath: self.inputAxisKey]{
      return (
        rangeStart: interpolationSteps[lastIndex - 1],
        rangeEnd: maxStep
      );
    };
    
    let firstMatch = interpolationSteps.enumerated().first {
      guard let nextItem = interpolationSteps[safeIndex: $0.offset + 1]
      else { return false };
      
      let coordCurrent =
        $0.element.computedRect.origin[keyPath: self.inputAxisKey];
        
      let coordNext =
        nextItem.computedRect.origin[keyPath: self.inputAxisKey];
      
      return coordCurrent >= inputValue && inputValue <= coordNext;
    };
    
    guard let rangeStart = firstMatch?.element,
          let rangeStartIndex = firstMatch?.offset,
          let rangeEnd = interpolationSteps[safeIndex: rangeStartIndex + 1]
    else { return nil };
    
    return (rangeStart, rangeEnd);
  };
  
  // MARK: - Functions - DisplayLink-Related
  // ---------------------------------------
    
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
  
  @objc func onDisplayLinkTick(displayLink: CADisplayLink) {
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
        self.applyInterpolationToModal(forGesturePoint: gesturePoint);
        
      case .cancelled, .ended:
        self.clearAnimators();
      
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
    guard let modalView = self.modalView else { return };
    
    if let gesturePoint = self.gesturePoint {
      self.applyInterpolationToModal(forGesturePoint: gesturePoint);
      
    } else if modalView.frame == .zero,
              let currentInterpolationStep = self.currentInterpolationStep {
      
      currentInterpolationStep.apply(toModalView: modalView);
    
    } else {
      self.applyInterpolationToModal(
        forPoint: modalView.frame.origin
      );
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
