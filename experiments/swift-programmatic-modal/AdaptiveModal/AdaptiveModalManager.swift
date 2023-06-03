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
  
  weak var modalBackgroundView: UIView?;
  weak var modalBackgroundVisualEffectView: UIVisualEffectView?;
  weak var backgroundVisualEffectView: UIVisualEffectView?;
  
  var displayLinkStartTimestamp: CFTimeInterval?;
  
  var gestureOffset: CGPoint?;
  var gestureVelocity: CGPoint?;
  var gestureInitialPoint: CGPoint?;
  var gesturePoint: CGPoint?;
  
  var prevModalFrame: CGRect = .zero;
  
  var backgroundVisualEffectAnimator: AdaptiveModalPropertyAnimator?;
  var modalBackgroundVisualEffectAnimator: AdaptiveModalPropertyAnimator?;
  
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
  
  var isAnimating: Bool {
     self.animator != nil || (self.animator?.isRunning ?? false);
  };
  
  var displayLinkEndTimestamp: CFTimeInterval? {
    guard let animator = self.animator,
          let displayLinkStartTimestamp = self.displayLinkStartTimestamp
    else { return nil };
    
    return displayLinkStartTimestamp + animator.duration;
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
  
    let gestureInitialCoord =
      gestureInitialPoint[keyPath: self.modalConfig.inputValueKeyForPoint];
      
    let gestureFinalCoord =
      gestureFinalPoint[keyPath: self.modalConfig.inputValueKeyForPoint];
      
    let gestureVelocityCoord =
      gestureVelocity[keyPath: self.modalConfig.inputValueKeyForPoint];
    
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
      $0.percent
    };
  };
  
  var interpolationRangeMaxInput: CGFloat? {
    guard let targetView = self.targetView else { return nil };
    return targetView.frame[keyPath: self.modalConfig.maxInputRangeKeyForRect];
  };
  
  // MARK: - Init
  // ------------
  
  init(
    modalConfig: AdaptiveModalConfig,
    modalView: UIView,
    targetView: UIView,
    modalBackgroundView: UIView? = nil,
    modalBackgroundVisualEffectView: UIVisualEffectView? = nil,
    backgroundVisualEffectView: UIVisualEffectView? = nil,
    currentSizeProvider: @escaping () -> CGSize
  ) {
    self.modalConfig = modalConfig;
    
    self.modalView = modalView;
    self.targetView = targetView;
    
    self.modalBackgroundView = modalBackgroundView;
    self.backgroundVisualEffectView = backgroundVisualEffectView;
    self.modalBackgroundVisualEffectView = modalBackgroundVisualEffectView;
    
    self.currentSizeProvider = currentSizeProvider;
    
    modalBackgroundView?.backgroundColor = .systemBackground;
    modalView.backgroundColor = .clear;
  };
  
  deinit {
    self.clearAnimators();
  };
  

  // MARK: - Functions - Interpolation-Related
  // -----------------------------------------
  
  func getInterpolationStepRange(
   forInputPercentValue inputPercentValue: CGFloat
  ) -> (
    rangeStart: AdaptiveModalInterpolationPoint,
    rangeEnd: AdaptiveModalInterpolationPoint
  )? {
    guard let interpolationSteps = self.interpolationSteps,
          let minStep = interpolationSteps.first,
          let maxStep = interpolationSteps.last
    else { return nil };
    
    let lastIndex = interpolationSteps.count - 1;
    
    let minStepValue = minStep.percent;
    let maxStepValue = maxStep.percent;
    
    if inputPercentValue <= minStepValue {
      return (
        rangeStart: minStep,
        rangeEnd: interpolationSteps[1]
      );
    };
    
    if inputPercentValue >= maxStepValue {
      return (
        rangeStart: interpolationSteps[lastIndex - 1],
        rangeEnd: maxStep
      );
    };
    
    let firstMatch = interpolationSteps.enumerated().first {
      guard let nextItem = interpolationSteps[safeIndex: $0.offset + 1]
      else { return false };
      
      let percentCurrent = $0.element.percent;
      let percentNext    = nextItem.percent;
      
      /// `inputPercentValue` is between the range of `percentCurrent`
      /// and `percentNext`
      ///
      return inputPercentValue >= percentCurrent &&
             inputPercentValue <= percentNext;
    };
    
    guard let rangeStart = firstMatch?.element,
          let rangeStartIndex = firstMatch?.offset,
          let rangeEnd = interpolationSteps[safeIndex: rangeStartIndex + 1]
    else { return nil };
    
    return (rangeStart, rangeEnd);
  };
  
  func interpolateModalRect(
    forInputPercentValue inputPercentValue: CGFloat,
    rangeInput: [CGFloat]? = nil,
    rangeOutput: [AdaptiveModalInterpolationPoint]? = nil
  ) -> CGRect? {
  
    guard let interpolationSteps      = rangeOutput ?? self.interpolationStepsSorted,
          let interpolationRangeInput = rangeInput  ?? self.interpolationRangeInput
    else { return nil };

    let clampConfig = modalConfig.interpolationClampingConfig;

    let nextHeight = Self.interpolate(
      inputValue: inputPercentValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.computedRect.height
      },
      shouldClampMin: clampConfig.shouldClampModalLastHeight,
      shouldClampMax: clampConfig.shouldClampModalInitHeight
    );
    
    let nextWidth = Self.interpolate(
      inputValue: inputPercentValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.computedRect.width
      },
      shouldClampMin: clampConfig.shouldClampModalLastWidth,
      shouldClampMax: clampConfig.shouldClampModalInitWidth
    );
    
    let nextX = Self.interpolate(
      inputValue: inputPercentValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.computedRect.minX
      },
      shouldClampMin: clampConfig.shouldClampModalLastX,
      shouldClampMax: clampConfig.shouldClampModalInitX
    );
    
    let nextY = Self.interpolate(
      inputValue: inputPercentValue,
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
  
  func interpolateModalBackgroundOpacity(
    forInputPercentValue inputPercentValue: CGFloat,
    rangeInput: [CGFloat]? = nil,
    rangeOutput: [AdaptiveModalInterpolationPoint]? = nil
  ) -> CGFloat? {
  
    guard let interpolationSteps      = rangeOutput ?? self.interpolationStepsSorted,
          let interpolationRangeInput = rangeInput  ?? self.interpolationRangeInput
    else { return nil };

    return Self.interpolate(
      inputValue: inputPercentValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.modalBackgroundOpacity
      }
    );
  };
  
  func interpolateModalBorderRadius(
    forInputPercentValue inputPercentValue: CGFloat,
    modalBounds: CGRect,
    rangeInput: [CGFloat]? = nil,
    rangeOutput: [AdaptiveModalInterpolationPoint]? = nil
  ) -> CGFloat? {
  
    guard let interpolationSteps      = rangeOutput ?? self.interpolationStepsSorted,
          let interpolationRangeInput = rangeInput  ?? self.interpolationRangeInput
    else { return nil };
    
    let modalCornerRadius = Self.interpolate(
      inputValue: inputPercentValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.modalCornerRadius
      }
    );
    
    guard let modalCornerRadius = modalCornerRadius else { return nil };
    return modalCornerRadius;
  };

  func applyInterpolationToBackgroundVisualEffect(
    forInputPercentValue inputPercentValue: CGFloat
  ) {
  
    let animator: AdaptiveModalPropertyAnimator? = {
      let interpolationRange = self.getInterpolationStepRange(
        forInputPercentValue: inputPercentValue
      );
      
      guard let interpolationRange = interpolationRange else { return nil };
      let animator = self.backgroundVisualEffectAnimator;
      
      let animatorDidRangeChange = animator?.didRangeChange(
        interpolationRangeStart: interpolationRange.rangeStart,
        interpolationRangeEnd: interpolationRange.rangeEnd
      );
    
      if let animator = animator, !animatorDidRangeChange! {
        return animator;
      };
      
      animator?.clear();
      
      guard let visualEffectView = self.backgroundVisualEffectView
      else { return nil };
      
      visualEffectView.effect = nil;
      
      return AdaptiveModalPropertyAnimator(
        interpolationRangeStart: interpolationRange.rangeStart,
        interpolationRangeEnd: interpolationRange.rangeEnd,
        forComponent: visualEffectView,
        interpolationOutputKey: \.backgroundVisualEffectIntensity
      ) {
        $0.effect = $1.backgroundVisualEffect;
      };
    }();
    
    guard let animator = animator else { return };
    self.backgroundVisualEffectAnimator = animator;
    
    animator.setFractionComplete(forInputPercentValue: inputPercentValue);
  };
  
  func applyInterpolationToModalBackgroundVisualEffect(
    forInputPercentValue inputPercentValue: CGFloat
  ) {
  
    let animator: AdaptiveModalPropertyAnimator? = {
      let interpolationRange = self.getInterpolationStepRange(
        forInputPercentValue: inputPercentValue
      );
      
      guard let interpolationRange = interpolationRange else { return nil };
      let animator = self.modalBackgroundVisualEffectAnimator;
      
      let animatorRangeDidChange = animator?.didRangeChange(
        interpolationRangeStart: interpolationRange.rangeStart,
        interpolationRangeEnd: interpolationRange.rangeEnd
      );
    
      if let animator = animator, !animatorRangeDidChange! {
        return animator;
      };
      
      animator?.clear();
      
      guard let visualEffectView = self.modalBackgroundVisualEffectView
      else { return nil };
      
      visualEffectView.effect = nil;
      
      return AdaptiveModalPropertyAnimator(
        interpolationRangeStart: interpolationRange.rangeStart,
        interpolationRangeEnd: interpolationRange.rangeEnd,
        forComponent: visualEffectView,
        interpolationOutputKey: \.modalBackgroundVisualEffectIntensity
      ) {
        $0.effect = $1.modalBackgroundVisualEffect;
      };
    }();
    
    guard let animator = animator else { return };
    self.modalBackgroundVisualEffectAnimator = animator;
    
    animator.setFractionComplete(forInputPercentValue: inputPercentValue);
  };
  
  func applyInterpolationToModal(
    forInputPercentValue inputPercentValue: CGFloat
  ) {
    guard let modalView = self.modalView else { return };
    
    if let nextModalRect = self.interpolateModalRect(
      forInputPercentValue: inputPercentValue
    ) {
      self.modalFrame = nextModalRect;
    };
    
    if let nextModalRadius = self.interpolateModalBorderRadius(
      forInputPercentValue: inputPercentValue,
      modalBounds: modalView.bounds
    ) {
      modalView.layer.cornerRadius = nextModalRadius;
    };
    
    if let nextModalBackgroundOpacity = self.interpolateModalBackgroundOpacity(
         forInputPercentValue: inputPercentValue
       ),
       let modalBackgroundView = self.modalBackgroundView {
       
      modalBackgroundView.alpha = nextModalBackgroundOpacity;
    };
    
    self.applyInterpolationToBackgroundVisualEffect(
      forInputPercentValue: inputPercentValue
    );
    
    self.applyInterpolationToModalBackgroundVisualEffect(
      forInputPercentValue: inputPercentValue
    );
  };
  
  func applyInterpolationToModal(forPoint point: CGPoint){
    guard let interpolationRangeMaxInput = self.interpolationRangeMaxInput
    else { return };
    
    let inputValue = point[keyPath: self.modalConfig.inputValueKeyForPoint];
    
    let shouldInvertPercent: Bool = {
      switch modalConfig.snapDirection {
        case .bottomToTop, .rightToLeft: return true;
        default: return false;
      };
    }();
    
    let percent = inputValue / interpolationRangeMaxInput;
    
    let percentAdj = shouldInvertPercent
      ? Self.invertPercent(percent)
      : percent;
    
    self.applyInterpolationToModal(forInputPercentValue: percentAdj);
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
    self.backgroundVisualEffectAnimator?.clear();
    self.backgroundVisualEffectAnimator = nil;
    
    self.modalBackgroundVisualEffectAnimator?.clear();
    self.modalBackgroundVisualEffectAnimator = nil;
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
      interpolationPoint.apply(toModalBackgroundView: self.modalBackgroundView);
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
    
    let inputCoord = modalView.frame.origin[keyPath: self.modalConfig.inputValueKeyForPoint];
    
    let delta = interpolationSteps.map {
      abs($0.computedRect.origin[keyPath: self.modalConfig.inputValueKeyForPoint] - inputCoord);
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
          let modalViewPresentationLayer = modalView.layer.presentation(),
          let interpolationRangeMaxInput = self.interpolationRangeMaxInput
    else { return };
    
    if self.isSwiping {
      self.endDisplayLink();
    };
    
    if self.displayLinkStartTimestamp == nil {
      self.displayLinkStartTimestamp = displayLink.timestamp;
    };
    
    let prevModalFrame = self.prevModalFrame;
    let nextModalFrame = modalViewPresentationLayer.frame;

    guard prevModalFrame != nextModalFrame else { return };
    
    let inputCoord =
      nextModalFrame.origin[keyPath: self.modalConfig.inputValueKeyForPoint];
      
    let percent = inputCoord / interpolationRangeMaxInput;
    
    let percentAdj = self.modalConfig.shouldInvertPercent
      ? Self.invertPercent(percent)
      : percent;
    
    
    self.applyInterpolationToBackgroundVisualEffect(
      forInputPercentValue: percentAdj
    );
    
    self.applyInterpolationToModalBackgroundVisualEffect(
      forInputPercentValue: percentAdj
    );
    
    self.prevModalFrame = nextModalFrame;
  };
  
  // MARK: - User-Invoked Functions
  // ------------------------------
  
  func computeSnapPoints(forTargetView nextTargetView: UIView? = nil) {
    if nextTargetView != nil {
      self.targetView = nextTargetView;
    };
  
    guard let targetView = nextTargetView ?? self.targetView
    else { return };
    
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
        
    
      case .changed:
        self.applyInterpolationToModal(forGesturePoint: gesturePoint);
        
      case .cancelled, .ended:
        guard self.enableSnapping else {
          self.clearGestureValues();
          return;
        };
        
        let gestureFinalPoint = self.gestureFinalPoint ?? gesturePoint;
        
        let gestureFinalCoord =
          gestureFinalPoint[keyPath: self.modalConfig.inputValueKeyForPoint];
        
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
    guard let modalView = self.modalView,
          !self.isAnimating
    else { return };
        
    if let gesturePoint = self.gesturePoint {
      self.applyInterpolationToModal(forGesturePoint: gesturePoint);
    
    } else if let currentInterpolationStep = self.currentInterpolationStep,
           currentInterpolationStep.computedRect != modalView.frame {
      
      self.applyInterpolationToModal(
        forInputPercentValue: currentInterpolationStep.percent
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
