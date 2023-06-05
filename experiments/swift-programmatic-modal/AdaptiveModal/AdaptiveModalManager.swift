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
  
  var enableSnapping = true;
  
  // MARK: -  Properties - Refs
  // --------------------------
  
  weak var eventDelegate: AdaptiveModalEventNotifiable?;

  lazy var dummyModalView = UIView();
  lazy var modalWrapperView = UIView();

  weak var targetView: UIView?;
  weak var modalView: UIView?;
  
  var animator: UIViewPropertyAnimator?;
  var displayLink: CADisplayLink?;
  
  weak var modalBackgroundView: UIView?;
  weak var modalBackgroundVisualEffectView: UIVisualEffectView?;
  weak var backgroundDimmingView: UIView?;
  weak var backgroundVisualEffectView: UIVisualEffectView?;
  
  var displayLinkStartTimestamp: CFTimeInterval?;
  
  var gestureOffset: CGPoint?;
  var gestureVelocity: CGPoint?;
  var gestureInitialPoint: CGPoint?;
  var gesturePoint: CGPoint?;
  
  var prevModalFrame: CGRect = .zero;
  
  var nextSnapPointIndex: Int?;
  
  var backgroundVisualEffectAnimator: AdaptiveModalRangePropertyAnimator?;
  var modalBackgroundVisualEffectAnimator: AdaptiveModalRangePropertyAnimator?;
  
  // MARK: -  Properties
  // -------------------
  
  var currentSizeProvider: () -> CGSize;
  
  var prevSnapPointIndex: Int?;
  var currentSnapPointIndex = 0 {
    didSet {
      self.prevSnapPointIndex = oldValue;
    }
  };
  
  /// The computed frames of the modal based on the snap points
  var interpolationSteps: [AdaptiveModalInterpolationPoint]?;
  
  var currentInterpolationIndex = 0;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var modalFrame: CGRect! {
    set {
      guard let newValue = newValue else { return };
      self.prevModalFrame = dummyModalView.frame;
      
      self.modalWrapperView.frame = newValue;
      self.dummyModalView.frame = newValue;
    }
    get {
      self.dummyModalView.frame;
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
    self.interpolationSteps?[self.currentInterpolationIndex];
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
    backgroundDimmingView: UIView? = nil,
    backgroundVisualEffectView: UIVisualEffectView? = nil,
    currentSizeProvider: @escaping () -> CGSize
  ) {
    self.modalConfig = modalConfig;
    
    self.modalView = modalView;
    self.targetView = targetView;
    
    self.modalBackgroundView = modalBackgroundView;
    self.modalBackgroundVisualEffectView = modalBackgroundVisualEffectView;
    
    self.backgroundVisualEffectView = backgroundVisualEffectView;
    self.backgroundDimmingView  = backgroundDimmingView;
    
    self.currentSizeProvider = currentSizeProvider;
    
    self.setupDummyModalView();
  };
  
  deinit {
    self.clearAnimators();
  };
  
  // MARK: - Functions - Setup
  // -------------------------
  
  private func setupDummyModalView(){
    guard let targetView = self.targetView else { return };
    let dummyModalView = self.dummyModalView;
    
    dummyModalView.backgroundColor = .clear;
    dummyModalView.alpha = 0.1;
    dummyModalView.isUserInteractionEnabled = false;
    
    targetView.addSubview(dummyModalView);
  };
  
  func setupAddViews(){
    guard let modalView = self.modalView,
          let targetView = self.targetView
    else { return };
    
    if let bgVisualEffectView = self.backgroundVisualEffectView {
      targetView.addSubview(bgVisualEffectView);
      
      bgVisualEffectView.clipsToBounds = true;
      bgVisualEffectView.backgroundColor = .clear;
    };
    
    if let bgDimmingView = self.backgroundDimmingView {
      targetView.addSubview(bgDimmingView);
      
      bgDimmingView.clipsToBounds = true;
      bgDimmingView.backgroundColor = .black;
      bgDimmingView.alpha = 0;
    };
    
    let modalWrapperView = self.modalWrapperView;
    targetView.addSubview(modalWrapperView);
    
    modalView.clipsToBounds = true;
    modalView.backgroundColor = .clear;
    modalWrapperView.addSubview(modalView);
    
    if let modalBackgroundView = self.modalBackgroundView {
      modalView.addSubview(modalBackgroundView);
      modalView.sendSubviewToBack(modalBackgroundView);
      
      modalBackgroundView.backgroundColor = .systemBackground;
      modalBackgroundView.isUserInteractionEnabled = false;
    };
    
    if let modalBGVisualEffectView = self.modalBackgroundVisualEffectView {
      modalView.addSubview(modalBGVisualEffectView);
      modalView.sendSubviewToBack(modalBGVisualEffectView);
      
      modalBGVisualEffectView.clipsToBounds = true;
      modalBGVisualEffectView.backgroundColor = .clear;
      modalBGVisualEffectView.isUserInteractionEnabled = false;
    };
  };
  
  func setupViewConstraints(){
    guard let modalView = self.modalView,
          let targetView = self.targetView
    else { return };
    
    if let bgVisualEffectView = self.backgroundVisualEffectView {
      bgVisualEffectView.translatesAutoresizingMaskIntoConstraints = false;
      
      NSLayoutConstraint.activate([
        bgVisualEffectView.topAnchor     .constraint(equalTo: targetView.topAnchor     ),
        bgVisualEffectView.bottomAnchor  .constraint(equalTo: targetView.bottomAnchor  ),
        bgVisualEffectView.leadingAnchor .constraint(equalTo: targetView.leadingAnchor ),
        bgVisualEffectView.trailingAnchor.constraint(equalTo: targetView.trailingAnchor),
      ]);
    };
    
    modalView.translatesAutoresizingMaskIntoConstraints = false;
      
    NSLayoutConstraint.activate([
      modalView.centerXAnchor.constraint(equalTo: self.modalWrapperView.centerXAnchor),
      modalView.centerYAnchor.constraint(equalTo: self.modalWrapperView.centerYAnchor),
      modalView.widthAnchor  .constraint(equalTo: self.modalWrapperView.widthAnchor  ),
      modalView.heightAnchor .constraint(equalTo: self.modalWrapperView.heightAnchor ),
    ]);
  
    if let bgDimmingView = self.backgroundDimmingView {
      bgDimmingView.translatesAutoresizingMaskIntoConstraints = false;
      
      NSLayoutConstraint.activate([
        bgDimmingView.topAnchor     .constraint(equalTo: targetView.topAnchor     ),
        bgDimmingView.bottomAnchor  .constraint(equalTo: targetView.bottomAnchor  ),
        bgDimmingView.leadingAnchor .constraint(equalTo: targetView.leadingAnchor ),
        bgDimmingView.trailingAnchor.constraint(equalTo: targetView.trailingAnchor),
      ]);
    };
    
    if let modalBGView = self.modalBackgroundView {
      modalBGView.translatesAutoresizingMaskIntoConstraints = false;
      
      NSLayoutConstraint.activate([
        modalBGView.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
        modalBGView.centerYAnchor.constraint(equalTo: modalView.centerYAnchor),
        modalBGView.widthAnchor  .constraint(equalTo: modalView.widthAnchor  ),
        modalBGView.heightAnchor .constraint(equalTo: modalView.heightAnchor ),
      ]);
    };
    
    if let modalBGVisualEffectView = self.modalBackgroundVisualEffectView {
      modalBGVisualEffectView.translatesAutoresizingMaskIntoConstraints = false;
      
      NSLayoutConstraint.activate([
        modalBGVisualEffectView.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
        modalBGVisualEffectView.centerYAnchor.constraint(equalTo: modalView.centerYAnchor),
        modalBGVisualEffectView.widthAnchor  .constraint(equalTo: modalView.widthAnchor  ),
        modalBGVisualEffectView.heightAnchor .constraint(equalTo: modalView.heightAnchor ),
      ]);
    };
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
  
  func interpolateModalTransform(
    forInputPercentValue inputPercentValue: CGFloat,
    rangeInput: [CGFloat]? = nil,
    rangeOutput: [AdaptiveModalInterpolationPoint]? = nil
  ) -> CGAffineTransform? {
  
    guard let interpolationSteps      = rangeOutput ?? self.interpolationStepsSorted,
          let interpolationRangeInput = rangeInput  ?? self.interpolationRangeInput
    else { return nil };

    let clampConfig = modalConfig.interpolationClampingConfig;

    let nextModalRotation = Self.interpolate(
      inputValue: inputPercentValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.modalRotation
      },
      shouldClampMin: clampConfig.shouldClampModalInitRotation,
      shouldClampMax: clampConfig.shouldClampModalLastRotation
    );
    
    let nextScaleX = Self.interpolate(
      inputValue: inputPercentValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.modalScaleX;
      },
      shouldClampMin: clampConfig.shouldClampModalLastScaleX,
      shouldClampMax: clampConfig.shouldClampModalLastScaleX
    );
    
    let nextScaleY = Self.interpolate(
      inputValue: inputPercentValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.modalScaleY
      },
      shouldClampMin: clampConfig.shouldClampModalLastScaleY,
      shouldClampMax: clampConfig.shouldClampModalLastScaleY
    );
    
    let nextTranslateX = Self.interpolate(
      inputValue: inputPercentValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.modalTranslateX
      },
      shouldClampMin: clampConfig.shouldClampModalInitTranslateX,
      shouldClampMax: clampConfig.shouldClampModalLastTranslateX
    );
    
    let nextTranslateY = Self.interpolate(
      inputValue: inputPercentValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0.modalTranslateY
      },
      shouldClampMin: clampConfig.shouldClampModalInitTranslateY,
      shouldClampMax: clampConfig.shouldClampModalLastTranslateY
    );
    
    let nextTransform: CGAffineTransform = {
      var transforms: [CGAffineTransform] = [];
      
      if let rotation = nextModalRotation {
        transforms.append(
          .init(rotationAngle: rotation)
        );
      };
      
      if let nextScaleX = nextScaleX,
         let nextScaleY = nextScaleY {
         
        transforms.append(
          .init(scaleX: nextScaleX, y: nextScaleY)
        );
      };
      
      if let nextTranslateX = nextTranslateX,
         let nextTranslateY = nextTranslateY {
         
        transforms.append(
          .init(translationX: nextTranslateX, y: nextTranslateY)
        );
      };
      
      return transforms.reduce(.identity) {
        $0.concatenating($1);
      };
    }();
 
    return nextTransform;
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
  
  func interpolateBackgroundOpacity(
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
        $0.backgroundOpacity
      }
    );
  };
  
  func applyInterpolationToModalBackgroundVisualEffect(
    forInputPercentValue inputPercentValue: CGFloat
  ) {
  
    let animator: AdaptiveModalRangePropertyAnimator? = {
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
      
      return AdaptiveModalRangePropertyAnimator(
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

  func applyInterpolationToBackgroundVisualEffect(
    forInputPercentValue inputPercentValue: CGFloat
  ) {
  
    let animator: AdaptiveModalRangePropertyAnimator? = {
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
      
      return AdaptiveModalRangePropertyAnimator(
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
  
  func applyInterpolationToModal(
    forInputPercentValue inputPercentValue: CGFloat
  ) {
    guard let modalView = self.modalView else { return };
    
    if let nextModalRect = self.interpolateModalRect(
      forInputPercentValue: inputPercentValue
    ) {
      self.modalFrame = nextModalRect;
    };
    
    if let nextModalTransform = self.interpolateModalTransform(
      forInputPercentValue: inputPercentValue
    ) {
      modalView.transform = nextModalTransform;
    };
    
    if let nextModalRadius = self.interpolateModalBorderRadius(
      forInputPercentValue: inputPercentValue,
      modalBounds: modalView.bounds
    ) {
      modalView.layer.cornerRadius = nextModalRadius;
    };
    
    if let modalBgView = self.modalBackgroundView,
       let nextModalBgOpacity = self.interpolateModalBackgroundOpacity(
         forInputPercentValue: inputPercentValue
       ) {
       
      modalBgView.alpha = nextModalBgOpacity;
    };
    
    if let bgDimmingView = self.backgroundDimmingView,
       let nextBgOpacity = self.interpolateBackgroundOpacity(
         forInputPercentValue: inputPercentValue
       ) {
      
      bgDimmingView.alpha = nextBgOpacity;
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
    guard let gestureInitialPoint = self.gestureInitialPoint
    else { return };
    
    let modalRect = self.modalFrame!;

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
  
  private func clearGestureValues(){
    self.gestureOffset = nil;
    self.gestureInitialPoint = nil;
    self.gestureVelocity = nil;
    self.gesturePoint = nil;
  };
  
  private func clearAnimators(){
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
      interpolationPoint.apply(toModalWrapperView: self.modalWrapperView);
      
      interpolationPoint.apply(toDummyModalView: self.dummyModalView);
      interpolationPoint.apply(toModalBackgroundView: self.modalBackgroundView);
      interpolationPoint.apply(toBackgroundView: self.backgroundDimmingView);
    };
    
    if let completion = completion {
      animator.addCompletion(completion);
    };
    
    animator.addCompletion { _ in
      self.animator = nil;
    };

    animator.startAnimation();
  };
  
  func getClosestSnapPoint(forCoord coord: CGFloat? = nil) -> (
    interpolationIndex: Int,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    interpolationPoint: AdaptiveModalInterpolationPoint
  )? {
    guard let interpolationSteps = self.interpolationSteps
    else { return nil };
    
    let inputRect = self.modalFrame!;
    
    let inputCoord = coord ??
      inputRect.origin[keyPath: self.modalConfig.inputValueKeyForPoint];
    
    let delta = interpolationSteps.map {
      abs($0.computedRect.origin[keyPath: self.modalConfig.inputValueKeyForPoint] - inputCoord);
    };
    
    let deltaSorted = delta.enumerated().sorted {
      $0.element < $1.element
    };
    
    let closestSnapPoint = deltaSorted.first!;
    
    let closestInterpolationIndex = min(
      closestSnapPoint.offset,
      self.modalConfig.snapPointLastIndex
    );
    
    let interpolationPoint = interpolationSteps[closestInterpolationIndex];
    let snapPointIndex = interpolationPoint.snapPointIndex;
    
    return (
      interpolationIndex: closestInterpolationIndex,
      snapPointConfig: self.modalConfig.snapPoints[snapPointIndex],
      interpolationPoint: interpolationPoint
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
    guard let dummyModalViewPresentationLayer =
            self.dummyModalView.layer.presentation(),
          let interpolationRangeMaxInput = self.interpolationRangeMaxInput
    else { return };
    
    if self.isSwiping {
      self.endDisplayLink();
    };
    
    if self.displayLinkStartTimestamp == nil {
      self.displayLinkStartTimestamp = displayLink.timestamp;
    };
    
    let prevModalFrame = self.prevModalFrame;
    let nextModalFrame = dummyModalViewPresentationLayer.frame;

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
        self.animator?.stopAnimation(true);
        
        self.applyInterpolationToModal(forGesturePoint: gesturePoint);
        self.onModalWillSnap();
        
      case .cancelled, .ended:
        guard self.enableSnapping else {
          self.clearGestureValues();
          return;
        };
        
        let gestureFinalPoint = self.gestureFinalPoint ?? gesturePoint;
        
        let gestureFinalCoord =
          gestureFinalPoint[keyPath: self.modalConfig.inputValueKeyForPoint];
        
        let closestSnapPoint =
          self.getClosestSnapPoint(forCoord: gestureFinalCoord);
        
        guard let closestSnapPoint = closestSnapPoint else {
          self.clearGestureValues();
          return;
        };
        
        self.animateModal(to: closestSnapPoint.interpolationPoint) { _ in
          self.currentInterpolationIndex =
            closestSnapPoint.interpolationIndex;
        
          self.currentSnapPointIndex =
            closestSnapPoint.interpolationPoint.snapPointIndex;
          
          self.endDisplayLink();
          self.onModalDidSnap();
        };
        
        self.startDisplayLink();
        self.clearGestureValues();
        
      default:
        break;
    };
  };
  
  func updateModal(){
    guard !self.isAnimating else { return };
        
    if let gesturePoint = self.gesturePoint {
      self.applyInterpolationToModal(forGesturePoint: gesturePoint);
    
    } else if let currentInterpolationStep = self.currentInterpolationStep,
           currentInterpolationStep.computedRect != self.modalFrame {
      
      self.applyInterpolationToModal(
        forInputPercentValue: currentInterpolationStep.percent
      );
    };
  };
  
  func snapToClosestSnapPoint(){
    guard let targetView = self.targetView,
          let closestSnapPoint =
            self.getClosestSnapPoint(forRect: self.modalFrame)
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
  
  // MARK: - Event Functions
  // -----------------------
  
  func onModalWillSnap(){
    guard let closestSnapPoint = self.getClosestSnapPoint()
    else { return };
    
    let prevIndex = self.nextSnapPointIndex;
    let nextIndex = closestSnapPoint.interpolationPoint.snapPointIndex;
    
    guard prevIndex != nextIndex else { return };
    self.nextSnapPointIndex = nextIndex;
    
    self.eventDelegate?.notifyOnModalWillSnap(
      prevSnapPointIndex: prevIndex,
      nextSnapPointIndex: nextIndex,
      snapPointConfig: closestSnapPoint.snapPointConfig,
      interpolationPoint: closestSnapPoint.interpolationPoint
    );
  };
  
  func onModalDidSnap(){
    self.eventDelegate?.notifyOnModalDidSnap(
      prevSnapPointIndex: self.prevSnapPointIndex,
      currentSnapPointIndex: self.currentSnapPointIndex,
      snapPointConfig: self.currentSnapPointConfig,
      interpolationPoint: self.currentInterpolationStep!
    );
    
    self.nextSnapPointIndex = nil;
  };
};
