//
//  AdaptiveModalManager.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/24/23.
//

import UIKit

class AdaptiveModalManager: NSObject {

  enum PresentationState {
    case presenting, dismissing, none;
  };

  // MARK: -  Properties - Config-Related
  // ------------------------------------
  
  var modalConfig: AdaptiveModalConfig;
  
  var enableSnapping = true;
  var enableOverShooting = true;
  
  var shouldSnapToUnderShootSnapPoint = true;
  var shouldSnapToOvershootSnapPoint = false;
  
  var shouldDismissModalOnSnapToUnderShootSnapPoint = true;
  var shouldDismissModalOnSnapToOverShootSnapPoint = false;
  
  // MARK: -  Properties - Layout-Related
  // ------------------------------------
  
  weak var modalViewController: UIViewController?;
  weak var targetViewController: UIViewController?;
  
  weak var targetView: UIView?;
  weak var modalView: UIView?;
  
  lazy var dummyModalView = UIView();
  lazy var modalWrapperView = UIView();
  lazy var modalWrapperTransformView = UIView();
  lazy var modalWrapperShadowView = UIView();
  
  var prevModalFrame: CGRect = .zero;
  
  var modalBackgroundView: UIView?;
  var modalBackgroundVisualEffectView: UIVisualEffectView?;
  
  var backgroundDimmingView: UIView?;
  var backgroundVisualEffectView: UIVisualEffectView?;
  
  private var modalFrame: CGRect! {
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
  
  private var layoutValueContext: RNILayoutValueContext {
    if let targetVC = self.targetViewController {
      return .init(fromTargetViewController: targetVC) ?? .default;
    };
    
    if let targetView = self.targetView {
      return .init(fromTargetView: targetView) ?? .default;
    };
    
    return .default;
  };
  
  // MARK: -  Properties - Config Interpolation Points
  // -------------------------------------------------
  
  /// The computed frames of the modal based on the snap points
  private(set) var configInterpolationSteps: [AdaptiveModalInterpolationPoint]!;
  
  var currentConfigInterpolationStep: AdaptiveModalInterpolationPoint {
    self.interpolationSteps[self.currentInterpolationIndex];
  };
  
  private var configInterpolationRangeInput: [CGFloat]! {
    self.interpolationSteps.map { $0.percent };
  };
  
  var prevConfigInterpolationIndex = 0;
  var nextConfigInterpolationIndex: Int?;
  
  var currentConfigInterpolationIndex = 0 {
    didSet {
      self.prevConfigInterpolationIndex = oldValue;
    }
  };
  
  // MARK: -  Properties - Override Interpolation Points
  // ---------------------------------------------------
  
  private(set) var isOverridingSnapPoints = false;
  
  var prevOverrideInterpolationIndex = 0;
  var nextOverrideInterpolationIndex: Int?;
  
  var currentOverrideInterpolationIndex = 0 {
    didSet {
      self.prevOverrideInterpolationIndex = oldValue;
    }
  };
  
  var overrideSnapPoints: [AdaptiveModalSnapPointConfig]?;
  var overrideInterpolationPoints: [AdaptiveModalInterpolationPoint]?;
  
  private var shouldUseOverrideSnapPoints: Bool {
       self.isOverridingSnapPoints
    && self.overrideSnapPoints          != nil
    && self.overrideInterpolationPoints != nil
  };
  
  private var shouldClearOverrideSnapPoints: Bool {
    self.shouldUseOverrideSnapPoints &&
    self.currentOverrideInterpolationIndex < overrideInterpolationPoints!.count - 2;
  };
  
  // MARK: -  Properties - Interpolation Points
  // ------------------------------------------
  
  var prevInterpolationIndex: Int {
    get {
      self.shouldSnapToOvershootSnapPoint
        ? self.prevOverrideInterpolationIndex
        : self.prevConfigInterpolationIndex;
    }
    set {
      if self.shouldSnapToOvershootSnapPoint {
        self.prevOverrideInterpolationIndex = newValue;
        
      } else {
        self.prevConfigInterpolationIndex = newValue;
      };
    }
  };
  
  var nextInterpolationIndex: Int? {
    get {
      self.shouldSnapToOvershootSnapPoint
        ? self.nextOverrideInterpolationIndex
        : self.nextConfigInterpolationIndex;
    }
    set {
      if self.shouldSnapToOvershootSnapPoint {
        self.nextOverrideInterpolationIndex = newValue;
        
      } else {
        self.nextConfigInterpolationIndex = newValue;
      };
    }
  };
  
  var currentInterpolationIndex: Int {
    get {
      self.shouldSnapToOvershootSnapPoint
        ? self.currentOverrideInterpolationIndex
        : self.currentConfigInterpolationIndex;
    }
    set {
      if self.shouldSnapToOvershootSnapPoint {
        self.currentOverrideInterpolationIndex = newValue;
        
      } else {
        self.currentConfigInterpolationIndex = newValue;
      };
    }
  };
  
  var interpolationSteps: [AdaptiveModalInterpolationPoint]! {
    get {
      self.shouldUseOverrideSnapPoints
        ? self.overrideInterpolationPoints
        : self.configInterpolationSteps
    }
    set {
      if self.shouldSnapToOvershootSnapPoint {
        self.overrideInterpolationPoints = newValue;
        
      } else {
        self.configInterpolationSteps = newValue;
      };
    }
  };
  
  var currentInterpolationStep: AdaptiveModalInterpolationPoint {
    self.interpolationSteps[self.currentInterpolationIndex];
  };
  
  private var interpolationRangeInput: [CGFloat]! {
    self.interpolationSteps.map { $0.percent };
  };
  
  private var interpolationRangeMaxInput: CGFloat? {
    guard let targetView = self.targetView else { return nil };
    return targetView.frame[keyPath: self.modalConfig.maxInputRangeKeyForRect];
  };
  
  var currentSnapPointConfig: AdaptiveModalSnapPointConfig {
    self.modalConfig.snapPoints[
      self.currentInterpolationStep.snapPointIndex
    ];
  };
  
  // MARK: -  Properties - Animation-Related
  // ---------------------------------------
  
  private var modalAnimator: UIViewPropertyAnimator?;

  private var backgroundVisualEffectAnimator: AdaptiveModalRangePropertyAnimator?;
  private var modalBackgroundVisualEffectAnimator: AdaptiveModalRangePropertyAnimator?;
  
  private var displayLink: CADisplayLink?;
  private var displayLinkStartTimestamp: CFTimeInterval?;
  
  private var displayLinkEndTimestamp: CFTimeInterval? {
    guard let animator = self.modalAnimator,
          let displayLinkStartTimestamp = self.displayLinkStartTimestamp
    else { return nil };
    
    return displayLinkStartTimestamp + animator.duration;
  };
  
  private var rangeAnimators: [AdaptiveModalRangePropertyAnimator?] {[
    self.backgroundVisualEffectAnimator,
    self.modalBackgroundVisualEffectAnimator
  ]};
  
  // MARK: -  Properties - Gesture-Related
  // -------------------------------------
  
  private var gestureOffset: CGPoint?;
  private var gestureVelocity: CGPoint?;
  private var gestureInitialPoint: CGPoint?;
  private var gesturePoint: CGPoint?;
  
  private var gestureInitialVelocity: CGVector {
    guard let gestureInitialPoint = self.gestureInitialPoint,
          let gestureFinalPoint   = self.gesturePoint,
          let gestureVelocity     = self.gestureVelocity
    else {
      return .zero;
    };
  
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
  private var gestureFinalPoint: CGPoint? {
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
  
  private var computedGestureOffset: CGPoint? {
    guard let gestureInitialPoint = self.gestureInitialPoint,
          let modalRect = self.modalFrame
    else { return nil };
    
    if let gestureOffset = self.gestureOffset {
      return gestureOffset;
    };
    
    let xOffset: CGFloat = {
      switch self.modalConfig.snapDirection {
        case .bottomToTop, .rightToLeft:
          return gestureInitialPoint.x - modalRect.minX;
          
        case .topToBottom, .leftToRight:
          return modalRect.maxX - gestureInitialPoint.x;
      };
    }();
    
    let yOffset: CGFloat = {
      switch self.modalConfig.snapDirection {
        case .bottomToTop, .rightToLeft:
          return gestureInitialPoint.y - modalRect.minY;
          
        case .topToBottom, .leftToRight:
          return modalRect.maxY - gestureInitialPoint.y;
      };
    }();
  
    let offset = CGPoint(x: xOffset, y: yOffset);
    self.gestureOffset = offset;
    
    return offset;
  };
  
  // MARK: -  Properties
  // -------------------
  
  private var didTriggerSetup = false;
  var presentationState: PresentationState = .none;
  
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

  // MARK: - Init
  // ------------
  
  init(modalConfig: AdaptiveModalConfig) {
    self.modalConfig = modalConfig;
    
    super.init();
    self.computeSnapPoints();
  };
  
  deinit {
    self.clearAnimators();
  };
  
  // MARK: - Functions - Setup
  // -------------------------
  
  func setupViewControllers() {
    guard let modalVC = self.modalViewController else { return };
  
    modalVC.modalPresentationStyle = .overCurrentContext;
    modalVC.transitioningDelegate = self;
  };
  
  func setupInitViews() {
    self.modalBackgroundView = UIView();
    self.modalBackgroundVisualEffectView = UIVisualEffectView();
    
    self.backgroundDimmingView = UIView();
    self.backgroundVisualEffectView = UIVisualEffectView();
  };
  
  func setupGestureHandler() {
    guard let modalView = self.modalView else { return };
    
    modalView.gestureRecognizers?.removeAll();
  
    modalView.addGestureRecognizer(
      UIPanGestureRecognizer(
        target: self,
        action: #selector(self.onDragPanGesture(_:))
      )
    );
  };
  
  func setupDummyModalView() {
    guard let targetView = self.targetView else { return };
    let dummyModalView = self.dummyModalView;
    
    dummyModalView.backgroundColor = .clear;
    dummyModalView.alpha = 0.1;
    dummyModalView.isUserInteractionEnabled = false;
    
    targetView.addSubview(dummyModalView);
  };

  func setupAddViews() {
    guard let modalView = self.modalView,
          let targetView = self.targetView
    else { return };
    
    if let bgVisualEffectView = self.backgroundVisualEffectView {
      targetView.addSubview(bgVisualEffectView);
      
      bgVisualEffectView.clipsToBounds = true;
      bgVisualEffectView.backgroundColor = .clear;
      bgVisualEffectView.isUserInteractionEnabled = false;
    };
    
    if let bgDimmingView = self.backgroundDimmingView {
      targetView.addSubview(bgDimmingView);
      
      bgDimmingView.clipsToBounds = true;
      bgDimmingView.backgroundColor = .black;
      bgDimmingView.alpha = 0;
    };
    
    let wrapperViews = [
      self.modalWrapperView,
      self.modalWrapperTransformView,
      self.modalWrapperShadowView,
      modalView,
    ];
    
    wrapperViews.enumerated().forEach {
      guard let prev = wrapperViews[safeIndex: $0.offset - 1] else {
        targetView.addSubview($0.element);
        return;
      };
      
      prev.addSubview($0.element);
    };
    
    modalView.clipsToBounds = true;
    modalView.backgroundColor = .clear;
    
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
  
  func setupViewConstraints() {
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
    
    let wrapperViews = [
      self.modalWrapperTransformView,
      self.modalWrapperShadowView,
      modalView,
    ];
    
    wrapperViews.forEach {
      guard let parentView = $0.superview else { return };
      $0.translatesAutoresizingMaskIntoConstraints = false;
      
      NSLayoutConstraint.activate([
        $0.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
        $0.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
        $0.widthAnchor  .constraint(equalTo: parentView.widthAnchor  ),
        $0.heightAnchor .constraint(equalTo: parentView.heightAnchor ),
      ]);
    };
    
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
  
  private func interpolate(
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
  
  private func interpolateColor(
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
  
  private func getInterpolationStepRange(
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
  
  private func interpolateModalRect(
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
  
  private func interpolateModalTransform(
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
  
  private func interpolateModalShadowOffset(
    forInputPercentValue inputPercentValue: CGFloat
  ) -> CGSize? {

    let nextWidth = self.interpolate(
      inputValue: inputPercentValue,
      rangeOutputKey: \.modalShadowOffset.width
    );
    
    let nextHeight = self.interpolate(
      inputValue: inputPercentValue,
      rangeOutputKey: \.modalShadowOffset.height
    );
    
    guard let nextWidth = nextWidth,
          let nextHeight = nextHeight
    else { return nil };

    return CGSize(width: nextWidth, height: nextHeight);
  };

  private func interpolateModalBorderRadius(
    forInputPercentValue inputPercentValue: CGFloat
  ) -> CGFloat? {
  
    return self.interpolate(
      inputValue: inputPercentValue,
      rangeOutputKey: \.modalCornerRadius
    );
  };
  
  // MARK: - Functions - Property Interpolators
  // ------------------------------------------
  
  private func applyInterpolationToModalBackgroundVisualEffect(
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
    
    animator.setFractionComplete(
      forInputPercentValue: inputPercentValue.clamped(min: 0, max: 1)
    );
  };

  private func applyInterpolationToBackgroundVisualEffect(
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
    
    animator.setFractionComplete(
      forInputPercentValue: inputPercentValue.clamped(min: 0, max: 1)
    );
  };
  
  // MARK: - Functions - Apply Interpolators
  // ----------------------------------------
  
  private func applyInterpolationToModal(
    forInputPercentValue inputPercentValue: CGFloat
  ) {
    guard let modalView = self.modalView else { return };
    
    self.modalFrame = self.interpolateModalRect(
      forInputPercentValue: inputPercentValue
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: self.modalWrapperTransformView,
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
      forObject: self.modalWrapperShadowView,
      forPropertyKey: \.layer.borderWidth,
      withValue:  self.interpolate(
        inputValue: inputPercentValue,
        rangeOutputKey: \.modalBorderWidth
      )
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: self.modalWrapperShadowView,
      forPropertyKey: \.layer.borderColor,
      withValue: {
        let color = self.interpolateColor(
          inputValue: inputPercentValue,
          rangeOutputKey: \.modalBorderColor
        );
        
        return color?.cgColor;
      }()
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: self.modalWrapperShadowView,
      forPropertyKey: \.layer.shadowColor,
      withValue:  {
        let color = self.interpolateColor(
          inputValue: inputPercentValue,
          rangeOutputKey: \.modalShadowColor
        );
        
        return color?.cgColor;
      }()
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: self.modalWrapperShadowView,
      forPropertyKey: \.layer.shadowOffset,
      withValue:  self.interpolateModalShadowOffset(
        forInputPercentValue: inputPercentValue
      )
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: self.modalWrapperShadowView,
      forPropertyKey: \.layer.shadowOpacity,
      withValue: {
        let value = self.interpolate(
          inputValue: inputPercentValue,
          rangeOutputKey: \.modalShadowOpacity
        );
        
        guard let value = value else { return nil };
        return Float(value);
      }()
    );
    
    AdaptiveModalUtilities.unwrapAndSetProperty(
      forObject: self.modalWrapperShadowView,
      forPropertyKey: \.layer.shadowRadius,
      withValue:  self.interpolate(
        inputValue: inputPercentValue,
        rangeOutputKey: \.modalShadowRadius
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
  
  private func applyInterpolationToModal(forPoint point: CGPoint) {
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
    
    let percentClamped: CGFloat = {
      guard !self.enableOverShooting else { return percent };
      
      let secondToLastIndex = self.modalConfig.overshootSnapPointIndex - 1;
      let maxPercent = self.interpolationRangeInput[secondToLastIndex];
      
      return percent.clamped(max: maxPercent);
    }();
    
    let percentAdj = shouldInvertPercent
      ? AdaptiveModalUtilities.invertPercent(percentClamped)
      : percentClamped;
      
    self.applyInterpolationToModal(forInputPercentValue: percentAdj);
  };
  
  private func applyInterpolationToModal(forGesturePoint gesturePoint: CGPoint) {
    let gesturePointWithOffset =
      self.applyGestureOffsets(forGesturePoint: gesturePoint);
  
    self.applyInterpolationToModal(forPoint: gesturePointWithOffset);
  };
  
  // MARK: - Functions - Cleanup-Related
  // -----------------------------------
  
  private func clearGestureValues() {
    self.gestureOffset = nil;
    self.gestureInitialPoint = nil;
    self.gestureVelocity = nil;
    self.gesturePoint = nil;
  };
  
  private func clearAnimators() {
    self.backgroundVisualEffectAnimator?.clear();
    self.backgroundVisualEffectAnimator = nil;
    
    self.modalBackgroundVisualEffectAnimator?.clear();
    self.modalBackgroundVisualEffectAnimator = nil;
    
    self.modalAnimator?.stopAnimation(true);
    self.modalAnimator = nil;
  };
  
  private func cleanupViews() {
    let viewsToCleanup: [UIView?] = [
      self.dummyModalView,
      self.modalWrapperView,
      // self.modalWrapperTransformView,
      // self.nodalView,
      self.modalWrapperShadowView,
      self.modalBackgroundView,
      self.modalBackgroundVisualEffectView,
      self.backgroundDimmingView,
      self.backgroundVisualEffectView
    ];
    
    viewsToCleanup.forEach {
      guard let view = $0 else { return };
      
      view.removeAllAncestorConstraints();
      view.removeFromSuperview();
    };
    
    self.modalView = nil;
    self.targetView = nil;
    
    self.modalBackgroundView = nil;
    self.modalBackgroundVisualEffectView = nil;
    self.backgroundDimmingView = nil;
    self.backgroundVisualEffectView = nil;
    
    self.didTriggerSetup = false;
  };
  
  private func cleanupSnapPointOverride(){
    self.isOverridingSnapPoints = false;
    self.overrideSnapPoints = nil;
    self.overrideInterpolationPoints = nil;
    
    self.prevOverrideInterpolationIndex = 0;
    self.nextOverrideInterpolationIndex = nil;
    self.currentOverrideInterpolationIndex = 0;
  };
 
  private func cleanup() {
    self.clearGestureValues();
    self.clearAnimators();
    self.cleanupViews();
    self.cleanupSnapPointOverride();
    
    self.currentInterpolationIndex = 0;
  };
  
  // MARK: - Functions - Helpers/Utilities
  // -------------------------------------
  
  private func adjustInterpolationIndex(for nextIndex: Int) -> Int {
    if nextIndex == 0 {
      return self.shouldSnapToUnderShootSnapPoint
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
  
  private func applyGestureOffsets(
    forGesturePoint gesturePoint: CGPoint
  ) -> CGPoint {
  
    guard let computedGestureOffset = self.computedGestureOffset
    else { return gesturePoint };
    
    switch self.modalConfig.snapDirection {
      case .bottomToTop, .rightToLeft: return CGPoint(
        x: gesturePoint.x - computedGestureOffset.x,
        y: gesturePoint.y - computedGestureOffset.y
      );
        
      case .topToBottom, .leftToRight: return CGPoint(
        x: gesturePoint.x + computedGestureOffset.x,
        y: gesturePoint.y + computedGestureOffset.y
      );
    };
  };
  
  func debug(prefix: String? = ""){
    print(
        "\n - AdaptiveModalManager.debug - \(prefix ?? "N/A")"
      + "\n - modalView: \(self.modalView?.debugDescription ?? "N/A")"
      + "\n - modalView frame: \(self.modalView?.frame.debugDescription ?? "N/A")"
      + "\n - modalView superview: \(self.modalView?.superview.debugDescription ?? "N/A")"
      + "\n - targetView: \(self.targetView?.debugDescription ?? "N/A")"
      + "\n - targetView frame: \(self.targetView?.frame.debugDescription ?? "N/A")"
      + "\n - targetView superview: \(self.targetView?.superview.debugDescription ?? "N/A")"
      + "\n - modalViewController: \(self.modalViewController?.debugDescription ?? "N/A")"
      + "\n - targetViewController: \(self.targetViewController?.debugDescription ?? "N/A")"
      + "\n - currentInterpolationIndex: \(self.currentInterpolationIndex)"
      + "\n - modalView gestureRecognizers: \(self.modalView?.gestureRecognizers.debugDescription ?? "N/A")"
      + "\n - interpolationSteps.computedRect: \(self.interpolationSteps.map({ $0.computedRect }))"
      + "\n - interpolationSteps.percent: \(self.interpolationSteps.map({ $0.percent }))"
      + "\n - interpolationSteps.backgroundVisualEffectIntensity: \(self.interpolationSteps.map({ $0.backgroundVisualEffectIntensity }))"
      + "\n - interpolationSteps.backgroundVisualEffect: \(self.interpolationSteps.map({ $0.backgroundVisualEffect }))"
      + "\n"
    );
  };
  
  // MARK: - Functions
  // -----------------
  
  private func computeSnapPoints(
    usingLayoutValueContext context: RNILayoutValueContext? = nil
  ) {
    let context = context ?? self.layoutValueContext;
    
    self.configInterpolationSteps = .Element.compute(
      usingModalConfig: self.modalConfig,
      layoutValueContext: context
    );
  };
  
  private func updateModal() {
    guard !self.isAnimating else { return };
        
    if let gesturePoint = self.gesturePoint {
      self.applyInterpolationToModal(forGesturePoint: gesturePoint);
    
    } else if self.currentInterpolationStep.computedRect != self.modalFrame {
      self.applyInterpolationToModal(
        forInputPercentValue: currentInterpolationStep.percent
      );
    };
  };
  
  private func getClosestSnapPoint(forCoord coord: CGFloat? = nil) -> (
    interpolationIndex: Int,
    snapPointConfig: AdaptiveModalSnapPointConfig,
    interpolationPoint: AdaptiveModalInterpolationPoint,
    snapDistance: CGFloat
  ) {
    let inputRect = self.modalFrame!;
    
    let inputCoord = coord ??
      inputRect[keyPath: self.modalConfig.inputValueKeyForRect];
    
    let delta = self.interpolationSteps.map {
      let coord =
        $0.computedRect[keyPath: self.modalConfig.inputValueKeyForRect];
      
      return abs(inputCoord - coord);
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
  
  private func getClosestSnapPoint(
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
  
  private func animateModal(
    to interpolationPoint: AdaptiveModalInterpolationPoint,
    completion: ((UIViewAnimatingPosition) -> Void)? = nil
  ) {
    guard let modalView = self.modalView else { return };
    
    let animator: UIViewPropertyAnimator = {
      let gestureInitialVelocity = self.gestureInitialVelocity;
      let snapAnimationConfig = self.modalConfig.snapAnimationConfig;
        
      let springTiming = UISpringTimingParameters(
        dampingRatio: snapAnimationConfig.springDampingRatio,
        initialVelocity: gestureInitialVelocity
      );

      return UIViewPropertyAnimator(
        duration: snapAnimationConfig.springAnimationSettlingTime,
        timingParameters: springTiming
      );
    }();
    
    self.modalAnimator?.stopAnimation(true);
    self.modalAnimator = animator;
    
    animator.addAnimations {
      interpolationPoint.apply(toModalView: modalView);
      
      interpolationPoint.apply(toModalWrapperView: self.modalWrapperView);
      interpolationPoint.apply(toModalWrapperTransformView: self.modalWrapperTransformView);
      interpolationPoint.apply(toModalWrapperShadowView: self.modalWrapperShadowView);
      
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
      self.endDisplayLink();
      self.modalAnimator = nil;
    };
  
    animator.startAnimation();
    self.startDisplayLink();
  };
  
  @objc private func onDragPanGesture(_ sender: UIPanGestureRecognizer) {
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
        self.notifyOnModalWillSnap();
        
      case .cancelled, .ended:
        guard self.enableSnapping else {
          self.clearGestureValues();
          return;
        };
        
        let gestureFinalPointRaw = self.gestureFinalPoint ?? gesturePoint;
        
        let gestureFinalPoint =
          self.applyGestureOffsets(forGesturePoint: gestureFinalPointRaw);
        
        self.snapToClosestSnapPoint(forPoint: gestureFinalPoint) {
          self.notifyOnModalDidSnap();
        };
        
        self.clearGestureValues();
        
      default:
        break;
    };
  };
  
  // MARK: - Functions - DisplayLink-Related
  // ---------------------------------------
    
  private func startDisplayLink() {
    let displayLink = CADisplayLink(
      target: self,
      selector: #selector(self.onDisplayLinkTick(displayLink:))
    );
    
    self.displayLink = displayLink;
    
    displayLink.preferredFrameRateRange =
      CAFrameRateRange(minimum: 60, maximum: 120);
    
    displayLink.add(to: .current, forMode: .common);
  };
  
  private func endDisplayLink() {
    self.displayLink?.invalidate();
  };
  
  @objc private func onDisplayLinkTick(displayLink: CADisplayLink) {
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
      nextModalFrame[keyPath: self.modalConfig.inputValueKeyForRect];
      
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
  
  // MARK: - Event Functions
  // -----------------------
  
  private func notifyOnModalWillSnap() {
    let interpolationSteps = self.interpolationSteps!;
    let prevIndex = self.currentInterpolationIndex;
    
    let nextIndexRaw: Int = {
      guard let nextIndex = self.nextInterpolationIndex else {
        let closestSnapPoint = self.getClosestSnapPoint();
        return closestSnapPoint.interpolationPoint.snapPointIndex;
      };
      
      return nextIndex;
    }();
    
    let nextIndex = self.adjustInterpolationIndex(for: nextIndexRaw);
    let nextPoint = self.interpolationSteps[nextIndex];
    
    guard prevIndex != nextIndex else { return };
    
    self.eventDelegate?.notifyOnModalWillSnap(
      prevSnapPointIndex: interpolationSteps[prevIndex].snapPointIndex,
      nextSnapPointIndex: interpolationSteps[nextIndex].snapPointIndex,
      snapPointConfig: self.modalConfig.snapPoints[nextPoint.snapPointIndex],
      interpolationPoint: nextPoint
    );
    
    let shouldDismissOnSnapToUnderShootSnapPoint =
      nextIndex == 0 && self.shouldDismissModalOnSnapToUnderShootSnapPoint;
      
    let shouldDismissOnSnapToOverShootSnapPoint =
      nextIndex == self.modalConfig.overshootSnapPointIndex &&
      self.shouldDismissModalOnSnapToOverShootSnapPoint;
    
    let shouldDismiss =
      shouldDismissOnSnapToUnderShootSnapPoint ||
      shouldDismissOnSnapToOverShootSnapPoint;
      
    let isPresenting = self.currentInterpolationIndex == 0 && nextIndex == 1;
      
    if shouldDismiss {
      self.notifyOnModalWillHide();
      
    } else if isPresenting {
      self.notifyOnModalWillShow();
    };
  };
  
  private func notifyOnModalDidSnap() {
    if self.shouldClearOverrideSnapPoints {
      self.cleanupSnapPointOverride();
    };
  
    self.eventDelegate?.notifyOnModalDidSnap(
      prevSnapPointIndex:
        self.interpolationSteps[self.prevInterpolationIndex].snapPointIndex,
        
      currentSnapPointIndex:
        self.interpolationSteps[self.currentInterpolationIndex].snapPointIndex,
        
      snapPointConfig: self.currentSnapPointConfig,
      interpolationPoint: self.currentInterpolationStep
    );
    
    let shouldDismissOnSnapToUnderShootSnapPoint =
      self.currentInterpolationIndex == 0 &&
      self.shouldDismissModalOnSnapToUnderShootSnapPoint;
      
    let shouldDismissOnSnapToOverShootSnapPoint =
      self.currentInterpolationIndex == self.modalConfig.overshootSnapPointIndex &&
      self.shouldDismissModalOnSnapToOverShootSnapPoint;
    
    let shouldDismiss =
      shouldDismissOnSnapToUnderShootSnapPoint ||
      shouldDismissOnSnapToOverShootSnapPoint;
      
    let wasPresented =
      self.currentInterpolationIndex == 1 &&
      self.prevInterpolationIndex == 0;
    
    if shouldDismiss {
      self.notifyOnModalDidHide();
      
    } else if wasPresented {
      self.notifyOnModalDidShow();
    };
  };
  
  private func notifyOnModalWillShow(){
    // wip
  };
  
  private func notifyOnModalDidShow(){
    // wip
    //UIView.animate(withDuration: 1){
    //  self.targetViewController?.view.transform = .init(scaleX: 0.5, y: 0.5);
    //};
  };
  
  private func notifyOnModalWillHide(){
    // wip
    //UIView.animate(withDuration: 1){
    //  self.targetViewController?.view.transform = .identity;
    //};
  };
  
  private func notifyOnModalDidHide(){
    self.cleanup();
    self.modalViewController?.dismiss(animated: false);
  };
  
  // MARK: - User-Invoked Functions
  // ------------------------------
  
  func prepareForPresentation(
    modalView: UIView? = nil,
    targetView: UIView? = nil,
    shouldForceReset: Bool = false
  ) {
    guard let modalView = modalView ?? self.modalView,
          let targetView = targetView ?? self.targetView
    else { return };
    
    let didViewsChange =
      modalView !== self.modalView || targetView !== self.targetView;
      
    let shouldReset =
      !self.didTriggerSetup || didViewsChange || shouldForceReset;
    
    if shouldReset {
      self.cleanup();
    };

    self.modalView = modalView;
    self.targetView = targetView;
  
    self.computeSnapPoints();
    
    if shouldReset {
      self.setupInitViews();
      self.setupDummyModalView();
      self.setupGestureHandler();
      
      self.setupAddViews();
      self.setupViewConstraints();
    };
    
    self.updateModal();
    self.didTriggerSetup = true;
  };
  
  func prepareForPresentation(
    viewControllerToPresent presentingVC: UIViewController,
    presentingViewController presentedVC: UIViewController
  ) {
    self.modalViewController = presentingVC;
    self.modalView = presentingVC.view;
    
    self.setupViewControllers();
  };
  
  func notifyDidLayoutSubviews() {
    self.computeSnapPoints();
    self.updateModal();
  };
  
  func snapTo(
    interpolationIndex nextIndex: Int,
    interpolationPoint: AdaptiveModalInterpolationPoint? = nil,
    completion: (() -> Void)? = nil
  ) {
    self.nextInterpolationIndex = nextIndex;
  
    let nextInterpolationPoint = interpolationPoint
      ?? self.interpolationSteps[nextIndex];
      
    self.notifyOnModalWillSnap();
  
    self.animateModal(to: nextInterpolationPoint) { _ in
      self.currentInterpolationIndex = nextIndex;
      self.nextInterpolationIndex = nil;
      
      self.notifyOnModalDidSnap();
      completion?();
    };
  };
  
  func snapToClosestSnapPoint(
    forPoint point: CGPoint,
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
   
    self.snapTo(
      interpolationIndex: nextInterpolationIndex,
      completion: completion
    );
  };
  
  func snapToClosestSnapPoint(completion: (() -> Void)? = nil) {
    let closestSnapPoint = self.getClosestSnapPoint(forRect: self.modalFrame);
    
    let nextInterpolationIndex =
      self.adjustInterpolationIndex(for: closestSnapPoint.interpolationIndex);
    
    let nextInterpolationPoint =
      self.interpolationSteps[nextInterpolationIndex];
    
    let prevFrame = self.modalFrame;
    let nextFrame = nextInterpolationPoint.computedRect;
    
    guard nextInterpolationIndex != self.currentInterpolationIndex,
          prevFrame != nextFrame
    else { return };
    
    self.snapTo(interpolationIndex: nextInterpolationIndex) {
      completion?();
    };
  };
  
  func snapToCurrentIndex(completion: (() -> Void)? = nil) {
    self.snapTo(
      interpolationIndex: self.currentInterpolationIndex,
      completion: completion
    );
  };
  
  func showModal(completion: (() -> Void)? = nil) {
    let nextIndex = self.modalConfig.initialSnapPointIndex;
    self.snapTo(interpolationIndex: nextIndex, completion: completion);
  };
  
  func hideModal(
    useInBetweenSnapPoints: Bool = false,
    completion: (() -> Void)? = nil
  ){
  
    let nextIndex = 0;
    
    if useInBetweenSnapPoints {
      self.snapTo(interpolationIndex: nextIndex, completion: completion);
    
    } else {
      let currentSnapPointConfig = self.currentSnapPointConfig;
      let currentInterpolationStep = self.currentInterpolationStep;
  
      let undershootSnapPointConfig = AdaptiveModalSnapPointConfig(
        fromSnapPointPreset: self.modalConfig.undershootSnapPoint,
        fromBaseLayoutConfig: currentSnapPointConfig.snapPoint
      );
      
      var undershootInterpolationPoint = AdaptiveModalInterpolationPoint(
        usingModalConfig: self.modalConfig,
        snapPointIndex: nextIndex,
        layoutValueContext: self.layoutValueContext,
        snapPointConfig: undershootSnapPointConfig
      );
      
      undershootInterpolationPoint.modalCornerRadius =
        currentInterpolationStep.modalCornerRadius;
      
      self.snapTo(
        interpolationIndex: nextIndex,
        interpolationPoint: undershootInterpolationPoint,
        completion: completion
      );
    };
  };
  
  public func presentModal(
    viewControllerToPresent modalVC: UIViewController,
    presentingViewController targetVC: UIViewController,
    animated: Bool = true,
    completion: (() -> Void)? = nil
  ) {
    self.prepareForPresentation(
      viewControllerToPresent: modalVC,
      presentingViewController: targetVC
    );
    
    targetVC.present(
      modalVC,
      animated: animated,
      completion: completion
    );
  };
  
  public func snapTo(
    snapPointConfig overrideSnapPointConfig: AdaptiveModalSnapPointConfig,
    overshootSnapPointPreset: AdaptiveModalSnapPointPreset? = nil,
    fallbackSnapPointKey: AdaptiveModalSnapPointConfig.SnapPointKey? = nil,
    animated: Bool = true,
    completion: (() -> Void)? = nil
  ) {
    self.cleanupSnapPointOverride();
    
    let prevInterpolationPoints: [AdaptiveModalInterpolationPoint] = {
      let overrideInterpolationPoint = AdaptiveModalInterpolationPoint(
        usingModalConfig: self.modalConfig,
        snapPointIndex: 1,
        layoutValueContext: self.layoutValueContext,
        snapPointConfig: overrideSnapPointConfig
      );
      
      let items = self.configInterpolationSteps.filter {
        $0.percent < overrideInterpolationPoint.percent;
      };
      
      guard items.count > 0 else {
        return [self.configInterpolationSteps.first!];
      };
      
      return items;
    }();
    
    let prevSnapPointConfigs = prevInterpolationPoints.map {
      self.modalConfig.snapPoints[$0.snapPointIndex];
    };
    
    let overshootSnapPointPreset = overshootSnapPointPreset
      ?? .getDefaultOvershootSnapPoint(forDirection: modalConfig.snapDirection);
      
    let overshootSnapPointConfig = AdaptiveModalSnapPointConfig(
      fromSnapPointPreset: overshootSnapPointPreset,
      fromBaseLayoutConfig: overrideSnapPointConfig.snapPoint
    );
  
    let snapPoints = prevSnapPointConfigs + [
      overrideSnapPointConfig,
      overshootSnapPointConfig,
    ];
    
    var interpolationPoints = prevInterpolationPoints.enumerated().map {
      var copy = $0.element;
      copy.snapPointIndex = $0.offset;
      
      return copy;
    };
    
    let nextInterpolationPoint = AdaptiveModalInterpolationPoint(
      usingModalConfig: self.modalConfig,
      snapPointIndex: interpolationPoints.count,
      layoutValueContext: self.layoutValueContext,
      snapPointConfig: overrideSnapPointConfig,
      prevInterpolationPoint: self.currentInterpolationStep
    );
    
    interpolationPoints.append(nextInterpolationPoint);
    
    let overshootSnapPoint = AdaptiveModalInterpolationPoint(
      usingModalConfig: self.modalConfig,
      snapPointIndex: interpolationPoints.count,
      layoutValueContext: self.layoutValueContext,
      snapPointConfig: overshootSnapPointConfig,
      prevInterpolationPoint: self.currentInterpolationStep
    );
    
    interpolationPoints.append(overshootSnapPoint);
    
    self.isOverridingSnapPoints = true;
    self.overrideSnapPoints = snapPoints;
    self.overrideInterpolationPoints = interpolationPoints;
    
    self.animateModal(to: nextInterpolationPoint) { _ in
      completion?();
    };
  };
};
