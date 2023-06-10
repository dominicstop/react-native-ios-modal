//
//  AdaptiveModalManager.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/24/23.
//

import UIKit

class AdaptiveModalManager: NSObject {

  // MARK: -  Properties - Config-Related
  // ------------------------------------
  
  var modalConfig: AdaptiveModalConfig;
  
  var enableSnapping = true;
  
  var shouldSnapToOvershootSnapPoint = false;
  var shouldSnapToInitialSnapPoint = false;
  
  // MARK: -  Properties - Layout-Related
  // ------------------------------------
  
  weak var modalViewController: UIViewController?;
  weak var targetViewController: UIViewController?;
  
  weak var targetView: UIView?;
  weak var modalView: UIView?;
  
  lazy var dummyModalView = UIView();
  lazy var modalWrapperView = UIView();
  
  var prevModalFrame: CGRect = .zero;
  
  var modalBackgroundView: UIView?;
  var modalBackgroundVisualEffectView: UIVisualEffectView?;
  
  var backgroundDimmingView: UIView?;
  var backgroundVisualEffectView: UIVisualEffectView?;
  
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
  
  var layoutValueContext: RNILayoutValueContext {
    if let targetVC = self.targetViewController {
      return .init(fromTargetViewController: targetVC) ?? .default;
    };
    
    if let targetView = self.targetView {
      return .init(fromTargetView: targetView) ?? .default;
    };
    
    return .default;
  };
  
  // MARK: -  Properties - Interpolation Points
  // ------------------------------------------
  
 /// The computed frames of the modal based on the snap points
  private(set) var rawInterpolationSteps: [AdaptiveModalInterpolationPoint]!;
  
  var prevInterpolationIndex = 0;
  var nextInterpolationIndex: Int?;
  
  var currentInterpolationIndex = 1 {
    didSet {
      self.prevInterpolationIndex = oldValue;
    }
  };
  
  var currentInterpolationStep: AdaptiveModalInterpolationPoint {
    self.interpolationSteps[self.currentInterpolationIndex];
  };
  
  // sorted based on the modal direction
  var interpolationSteps: [AdaptiveModalInterpolationPoint]! {
    self.modalConfig.sortInterpolationSteps(self.rawInterpolationSteps);
  };
  
  var interpolationRangeInput: [CGFloat]! {
    self.interpolationSteps.map {
      $0.percent
    };
  };
  
  var interpolationRangeMaxInput: CGFloat? {
    guard let targetView = self.targetView else { return nil };
    return targetView.frame[keyPath: self.modalConfig.maxInputRangeKeyForRect];
  };
  
  // MARK: -  Properties - Animation-Related
  // ---------------------------------------
  
  var modalAnimator: UIViewPropertyAnimator?;

  var backgroundVisualEffectAnimator: AdaptiveModalRangePropertyAnimator?;
  var modalBackgroundVisualEffectAnimator: AdaptiveModalRangePropertyAnimator?;
  
  var displayLink: CADisplayLink?;
  var displayLinkStartTimestamp: CFTimeInterval?;
  
  var displayLinkEndTimestamp: CFTimeInterval? {
    guard let animator = self.modalAnimator,
          let displayLinkStartTimestamp = self.displayLinkStartTimestamp
    else { return nil };
    
    return displayLinkStartTimestamp + animator.duration;
  };
  
  // MARK: -  Properties - Gesture-Related
  // -------------------------------------
  
  var gestureOffset: CGPoint?;
  var gestureVelocity: CGPoint?;
  var gestureInitialPoint: CGPoint?;
  var gesturePoint: CGPoint?;
  
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
    
    let nextX = AdaptiveModalUtilities.computeFinalPosition(
      position: gesturePoint.x,
      initialVelocity: gestureVelocityClamped.x
    );
    
    let nextY = AdaptiveModalUtilities.computeFinalPosition(
      position: gesturePoint.y,
      initialVelocity: gestureVelocityClamped.y
    );
    
    return CGPoint(x: nextX, y: nextY);
  };
  
  // MARK: -  Properties
  // -------------------
  
  weak var eventDelegate: AdaptiveModalEventNotifiable?;

  // MARK: - Computed Properties
  // ---------------------------
  
  var isSwiping: Bool {
    self.gestureInitialPoint != nil
  };
  
  var isAnimating: Bool {
     self.modalAnimator != nil || (self.modalAnimator?.isRunning ?? false);
  };
  
  var currentSnapPointIndex: Int {
    self.currentInterpolationStep.snapPointIndex
  };
  
  var currentSnapPointConfig: AdaptiveModalSnapPointConfig {
    self.modalConfig.snapPoints[
      self.currentInterpolationStep.snapPointIndex
    ];
  };

  // MARK: - Init
  // ------------
  
  init(
    modalConfig: AdaptiveModalConfig,
    modalView: UIView,
    targetView: UIView,
    currentSizeProvider: (() -> CGSize)? = nil
  ) {
    self.modalConfig = modalConfig;
    
    self.modalView = modalView;
    self.targetView = targetView;

    super.init();
    
    self.computeSnapPoints();
    
    self.setupInitViews();
    self.setupDummyModalView();
    self.setupGestureHandler();
    
    self.setupAddViews();
    self.setupViewConstraints();
  };
  
  init(modalConfig: AdaptiveModalConfig) {
    self.modalConfig = modalConfig;
    
    super.init();
    
    self.computeSnapPoints();
    self.setupViewControllers();
    self.setupInitViews();
    self.setupDummyModalView();
  };
  
  deinit {
    self.clearAnimators();
  };
  
  // MARK: - Functions - Setup
  // -------------------------
  
  func setupViewControllers() {
    modalViewController?.modalPresentationStyle = .custom;
    modalViewController?.transitioningDelegate = self;
  };
  
  func setupInitViews(){
    self.modalBackgroundView = UIView();
    self.modalBackgroundVisualEffectView = UIVisualEffectView();
    
    self.backgroundDimmingView = UIView();
    self.backgroundVisualEffectView = UIVisualEffectView();
  };
  
  func setupGestureHandler(){
    guard let modalView = self.modalView else { return };
  
    modalView.addGestureRecognizer(
      UIPanGestureRecognizer(
        target: self,
        action: #selector(self.onDragPanGesture(_:))
      )
    );
  };
  
  private func setupDummyModalView(){
    guard let targetView = self.targetView else { return };
    let dummyModalView = self.dummyModalView;
    
    dummyModalView.backgroundColor = .clear;
    dummyModalView.alpha = 0.1;
    dummyModalView.isUserInteractionEnabled = false;
    
    targetView.addSubview(dummyModalView);
  };
  
  private func setupAddViews(){
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

  // MARK: - Functions - Interpolation-Related Helpers
  // -------------------------------------------------
  
  func interpolate(
    inputValue: CGFloat,
    rangeInput: [CGFloat]? = nil,
    rangeOutput: [AdaptiveModalInterpolationPoint]? = nil,
    rangeOutputKey: KeyPath<AdaptiveModalInterpolationPoint, CGFloat>,
    shouldClampMin: Bool = false,
    shouldClampMax: Bool = false
  ) -> CGFloat? {
  
    guard let interpolationSteps      = rangeOutput ?? self.interpolationSteps,
          let interpolationRangeInput = rangeInput  ?? self.interpolationRangeInput
    else { return nil };
  
    return AdaptiveModalUtilities.interpolate(
      inputValue: inputValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0[keyPath: rangeOutputKey];
      },
      shouldClampMin: shouldClampMin,
      shouldClampMax: shouldClampMax
    );
  };
  
  func interpolateColor(
    inputValue: CGFloat,
    rangeInput: [CGFloat]? = nil,
    rangeOutput: [AdaptiveModalInterpolationPoint]? = nil,
    rangeOutputKey: KeyPath<AdaptiveModalInterpolationPoint, UIColor>,
    shouldClampMin: Bool = false,
    shouldClampMax: Bool = false
  ) -> UIColor? {
  
    guard let interpolationSteps      = rangeOutput ?? self.interpolationSteps,
          let interpolationRangeInput = rangeInput  ?? self.interpolationRangeInput
    else { return nil };
  
    return AdaptiveModalUtilities.interpolateColor(
      inputValue: inputValue,
      rangeInput: interpolationRangeInput,
      rangeOutput: interpolationSteps.map {
        $0[keyPath: rangeOutputKey];
      },
      shouldClampMin: shouldClampMin,
      shouldClampMax: shouldClampMax
    );
  };
  
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
  
  // MARK: - Functions - Value Interpolators
  // ---------------------------------------
  
  func interpolateModalRect(
    forInputPercentValue inputPercentValue: CGFloat
  ) -> CGRect? {
  
    let clampConfig = modalConfig.interpolationClampingConfig;

    let nextHeight = self.interpolate(
      inputValue: inputPercentValue,
      rangeOutputKey: \.computedRect.height,
      shouldClampMin: clampConfig.shouldClampModalLastHeight,
      shouldClampMax: clampConfig.shouldClampModalInitHeight
    );
    
    let nextWidth = self.interpolate(
      inputValue: inputPercentValue,
      rangeOutputKey: \.computedRect.width,
      shouldClampMin: clampConfig.shouldClampModalLastWidth,
      shouldClampMax: clampConfig.shouldClampModalInitWidth
    );
    
    let nextX = self.interpolate(
      inputValue: inputPercentValue,
      rangeOutputKey: \.computedRect.origin.x,
      shouldClampMin: clampConfig.shouldClampModalLastX,
      shouldClampMax: clampConfig.shouldClampModalInitX
    );
    
    let nextY = self.interpolate(
      inputValue: inputPercentValue,
      rangeOutputKey: \.computedRect.origin.y,
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
    forInputPercentValue inputPercentValue: CGFloat
  ) -> CGAffineTransform? {

    let clampConfig = modalConfig.interpolationClampingConfig;

    let nextModalRotation = self.interpolate(
      inputValue: inputPercentValue,
      rangeOutputKey: \.modalRotation,
      shouldClampMin: clampConfig.shouldClampModalInitRotation,
      shouldClampMax: clampConfig.shouldClampModalLastRotation
    );
    
    let nextScaleX = self.interpolate(
      inputValue: inputPercentValue,
      rangeOutputKey: \.modalScaleX,
      shouldClampMin: clampConfig.shouldClampModalLastScaleX,
      shouldClampMax: clampConfig.shouldClampModalLastScaleX
    );
    
    let nextScaleY = self.interpolate(
      inputValue: inputPercentValue,
      rangeOutputKey: \.modalScaleY,
      shouldClampMin: clampConfig.shouldClampModalLastScaleY,
      shouldClampMax: clampConfig.shouldClampModalLastScaleY
    );
    
    let nextTranslateX = self.interpolate(
      inputValue: inputPercentValue,
      rangeOutputKey: \.modalTranslateX,
      shouldClampMin: clampConfig.shouldClampModalInitTranslateX,
      shouldClampMax: clampConfig.shouldClampModalLastTranslateX
    );
    
    let nextTranslateY = self.interpolate(
      inputValue: inputPercentValue,
      rangeOutputKey: \.modalTranslateY,
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

  func interpolateModalBorderRadius(
    forInputPercentValue inputPercentValue: CGFloat
  ) -> CGFloat? {
  
    return self.interpolate(
      inputValue: inputPercentValue,
      rangeOutputKey: \.modalCornerRadius
    );
  };
  
  // MARK: - Functions - Property Interpolators
  // ------------------------------------------
  
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
  
  // MARK: - Functions - Apply Interpolators
  // ----------------------------------------
  
  func applyInterpolationToModal(
    forInputPercentValue inputPercentValue: CGFloat
  ) {
    guard let modalView = self.modalView else { return };
    
    self.modalFrame = self.interpolateModalRect(
      forInputPercentValue: inputPercentValue
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: modalView,
      forPropertyKey: \.transform,
      withValue:  self.interpolateModalTransform(
        forInputPercentValue: inputPercentValue
      )
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: modalView,
      forPropertyKey: \.alpha,
      withValue:  self.interpolate(
        inputValue: inputPercentValue,
        rangeOutputKey: \.modalOpacity
      )
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: modalView,
      forPropertyKey: \.layer.cornerRadius,
      withValue:  self.interpolateModalBorderRadius(
        forInputPercentValue: inputPercentValue
      )
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: self.modalBackgroundView,
      forPropertyKey: \.backgroundColor,
      withValue:  self.interpolateColor(
        inputValue: inputPercentValue,
        rangeOutputKey: \.modalBackgroundColor
      )
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: self.modalBackgroundView,
      forPropertyKey: \.alpha,
      withValue:  self.interpolate(
        inputValue: inputPercentValue,
        rangeOutputKey: \.modalBackgroundOpacity
      )
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: self.modalBackgroundVisualEffectView,
      forPropertyKey: \.alpha,
      withValue:  self.interpolate(
        inputValue: inputPercentValue,
        rangeOutputKey: \.modalBackgroundVisualEffectOpacity
      )
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: self.backgroundDimmingView,
      forPropertyKey: \.backgroundColor,
      withValue:  self.interpolateColor(
        inputValue: inputPercentValue,
        rangeOutputKey: \.backgroundColor
      )
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: self.backgroundDimmingView,
      forPropertyKey: \.alpha,
      withValue:  self.interpolate(
        inputValue: inputPercentValue,
        rangeOutputKey: \.backgroundOpacity
      )
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: self.backgroundVisualEffectView,
      forPropertyKey: \.alpha,
      withValue:  self.interpolate(
        inputValue: inputPercentValue,
        rangeOutputKey: \.backgroundVisualEffectOpacity
      )
    );
    
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
      ? AdaptiveModalUtilities.invertPercent(percent)
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
    
    self.modalAnimator = animator;
    
    animator.addAnimations {
      interpolationPoint.apply(toModalView: modalView);
      interpolationPoint.apply(toModalWrapperView: self.modalWrapperView);
      
      interpolationPoint.apply(toDummyModalView: self.dummyModalView);
      interpolationPoint.apply(toModalBackgroundView: self.modalBackgroundView);
      interpolationPoint.apply(toBackgroundView: self.backgroundDimmingView);
      
      interpolationPoint.apply(toModalBackgroundEffectView: self.modalBackgroundVisualEffectView);
      interpolationPoint.apply(toBackgroundVisualEffectView: self.backgroundVisualEffectView);
    };
    
    if let completion = completion {
      animator.addCompletion(completion);
    };
    
    animator.addCompletion { _ in
      self.modalAnimator = nil;
    };

    animator.startAnimation();
  };
  
  func getClosestSnapPoint(forCoord coord: CGFloat? = nil) -> (
    interpolationIndex: Int,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    interpolationPoint: AdaptiveModalInterpolationPoint,
    snapDistance: CGFloat
  ) {
    let inputRect = self.modalFrame!;
    
    let inputCoord = coord ??
      inputRect.origin[keyPath: self.modalConfig.inputValueKeyForPoint];
    
    let delta = self.interpolationSteps.map {
      abs($0.computedRect.origin[keyPath: self.modalConfig.inputValueKeyForPoint] - inputCoord);
    };
    
    let deltaSorted = delta.enumerated().sorted {
      $0.element < $1.element
    };
    
    let closestSnapPoint = deltaSorted.first!;
    let closestInterpolationIndex = closestSnapPoint.offset;
    
    let interpolationPoint = interpolationSteps[closestInterpolationIndex];
    let snapPointIndex = interpolationPoint.snapPointIndex;
    
    return (
      interpolationIndex: closestInterpolationIndex,
      snapPointConfig: self.modalConfig.snapPoints[snapPointIndex],
      interpolationPoint: interpolationPoint,
      snapDistance: closestSnapPoint.element
    );
  };
  
  func getClosestSnapPoint(
    forRect currentRect: CGRect
  ) -> (
    interpolationIndex: Int,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    interpolationPoint: AdaptiveModalInterpolationPoint,
    snapDistance: CGFloat
  ) {
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
    
    let closestInterpolationPointIndex = deltaAvgSorted.first!.offset;
      
    let closestInterpolationPoint =
      interpolationSteps[closestInterpolationPointIndex];
    
    return (
      interpolationIndex: closestInterpolationPointIndex,
      snapPointConfig: self.modalConfig.snapPoints[closestInterpolationPointIndex],
      interpolationPoint: closestInterpolationPoint,
      snapDistance: deltaAvg[closestInterpolationPointIndex]
    );
  };
  
  func adjustInterpolationIndex(for nextIndex: Int) -> Int {
    if nextIndex == 0 {
      return self.shouldSnapToInitialSnapPoint
        ? nextIndex
        : 1;
    };
    
    let lastIndex = self.interpolationSteps.count - 1;
    
    if nextIndex == lastIndex {
      return self.shouldSnapToOvershootSnapPoint
        ? nextIndex
        : lastIndex - 1;
    };
    
    return nextIndex;
  };
  
  @objc func onDragPanGesture(_ sender: UIPanGestureRecognizer) {
    let gesturePoint = sender.location(in: self.targetView);
    self.gesturePoint = gesturePoint;
    
    let gestureVelocity = sender.velocity(in: self.targetView);
    self.gestureVelocity = gestureVelocity;
    
    switch sender.state {
      case .began:
        self.gestureInitialPoint = gesturePoint;
    
      case .changed:
        self.modalAnimator?.stopAnimation(true);
        
        self.applyInterpolationToModal(forGesturePoint: gesturePoint);
        self.onModalWillSnap();
        
      case .cancelled, .ended:
        guard self.enableSnapping else {
          self.clearGestureValues();
          return;
        };
        
        let gestureFinalPoint = self.gestureFinalPoint ?? gesturePoint;
        
        self.snapToClosestSnapPoint(forPoint: gestureFinalPoint) {
          self.endDisplayLink();
          self.onModalDidSnap();
        };
        
        self.clearGestureValues();
        self.startDisplayLink();
        
      default:
        break;
    };
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
      ? AdaptiveModalUtilities.invertPercent(percent)
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
  
  func set(
    viewControllerToPresent: UIViewController,
    presentingViewController: UIViewController
  ) {
    self.modalViewController = viewControllerToPresent;
    self.targetViewController = presentingViewController;
    
    self.modalView = viewControllerToPresent.view;
    self.targetView = presentingViewController.view;
    
    self.setupViewControllers();
    self.setupDummyModalView();
    self.setupInitViews();
    self.setupGestureHandler();
    
    self.setupAddViews();
    self.setupViewConstraints();
    
    self.computeSnapPoints();
    self.updateModal();
  };
  
  func computeSnapPoints(
    usingLayoutValueContext context: RNILayoutValueContext? = nil
  ) {
    let context = context ?? self.layoutValueContext;
    
    self.rawInterpolationSteps = .Element.compute(
      usingModalConfig: self.modalConfig,
      layoutValueContext: context
    );
  };
  
  func updateModal(){
    guard !self.isAnimating else { return };
        
    if let gesturePoint = self.gesturePoint {
      self.applyInterpolationToModal(forGesturePoint: gesturePoint);
    
    } else if self.currentInterpolationStep.computedRect != self.modalFrame {
      self.applyInterpolationToModal(
        forInputPercentValue: currentInterpolationStep.percent
      );
    };
  };
  
  func snapToClosestSnapPoint(
    forPoint point: CGPoint,
    duration: CGFloat? = nil,
    completion: (() -> Void)? = nil
  ) {
    let coord = point[keyPath: self.modalConfig.inputValueKeyForPoint];
    let closestSnapPoint = self.getClosestSnapPoint(forCoord: coord);
    
    let nextInterpolationIndex =
      self.adjustInterpolationIndex(for: closestSnapPoint.interpolationIndex);
    
    let nextInterpolationPoint =
      self.interpolationSteps[nextInterpolationIndex];
 
    let prevFrame = self.modalFrame;
    let nextFrame = nextInterpolationPoint.computedRect;
    
    guard prevFrame != nextFrame else { return };
    
    self.nextInterpolationIndex = nextInterpolationIndex;
    
    let defaultDuration: CGFloat? = {
      guard self.gestureVelocity == nil,
            let targetView = self.targetView
      else { return nil };
      
      let interpolatedValue = AdaptiveModalUtilities.interpolate(
        inputValue: closestSnapPoint.snapDistance,
        rangeInput: [0, targetView.frame.height],
        rangeOutput: [0.2, 0.7]
      );
      
      return interpolatedValue;
    }();
    
    self.animateModal(
      to: nextInterpolationPoint,
      duration: duration ?? defaultDuration
    ) { _ in
      self.currentInterpolationIndex = nextInterpolationIndex;
      self.nextInterpolationIndex = nil;
      
      completion?();
    };
  };
  
  func snapToClosestSnapPoint(){
    let closestSnapPoint = self.getClosestSnapPoint(forRect: self.modalFrame);
    
    let nextInterpolationIndex =
      self.adjustInterpolationIndex(for: closestSnapPoint.interpolationIndex);
    
    let nextInterpolationPoint =
      self.interpolationSteps[nextInterpolationIndex];
    
    let prevFrame = self.modalFrame;
    let nextFrame = nextInterpolationPoint.computedRect;
    
    guard prevFrame != nextFrame else { return };
    
    self.animateModal(
      to: nextInterpolationPoint
    );
  };
  
  // MARK: - Event Functions
  // -----------------------
  
  func onModalWillSnap(){
    let interpolationSteps = self.interpolationSteps!;
    let prevIndex = self.currentInterpolationIndex;
    
    let nextIndex: Int = {
      guard let nextIndex = self.nextInterpolationIndex else {
        let closestSnapPoint = self.getClosestSnapPoint();
        return closestSnapPoint.interpolationPoint.snapPointIndex;
      };
      
      return nextIndex;
    }();
    
    let nextPoint = self.interpolationSteps[nextIndex];
    
    guard prevIndex != nextIndex else { return };
    
    self.eventDelegate?.notifyOnModalWillSnap(
      prevSnapPointIndex: interpolationSteps[prevIndex].snapPointIndex,
      nextSnapPointIndex: interpolationSteps[nextIndex].snapPointIndex,
      snapPointConfig: self.modalConfig.snapPoints[nextPoint.snapPointIndex],
      interpolationPoint: nextPoint
    );
  };
  
  func onModalDidSnap(){
    self.eventDelegate?.notifyOnModalDidSnap(
      prevSnapPointIndex:
        interpolationSteps[self.prevInterpolationIndex].snapPointIndex,
        
      currentSnapPointIndex:
        interpolationSteps[self.currentInterpolationIndex].snapPointIndex,
        
      snapPointConfig: self.currentSnapPointConfig,
      interpolationPoint: self.currentInterpolationStep
    );
  };
};
