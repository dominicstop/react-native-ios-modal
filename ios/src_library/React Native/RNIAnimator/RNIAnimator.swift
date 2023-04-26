//
//  RNIAnimator.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/19/23.
//

import Foundation


public class RNIAnimator {
  
  // MARK: - Embedded Types
  // ----------------------
  
  typealias EasingFunction = (_ timing: CGFloat) -> CGFloat;
  
  public class EasingFunctions {
    
    static func lerp(
      valueStart: CGFloat,
      valueEnd: CGFloat,
      percent: CGFloat
    ) -> CGFloat {
      let valueDelta = valueEnd - valueStart;
      let valueProgress = valueDelta * percent
      return valueStart + valueProgress;
    };
    
    static func linear(_ time: CGFloat) -> CGFloat {
      return time;
    };
    
    static func easeIn(_ time: CGFloat) -> CGFloat {
      return time * time;
    };
  };
  
  public enum Easing: String {
    case linear;
    case easeIn;
    
    var easingFunction: EasingFunction {
      switch self {
        case .linear: return EasingFunctions.linear;
        case .easeIn: return EasingFunctions.easeIn;
      };
    };
  };
  
  // MARK: - Properties
  // ------------------
  
  private var displayLink: CADisplayLink?;
  
  public var easing: Easing = .linear;
  
  private(set) public var timeStart: CFTimeInterval = 0;
  private(set) public var timeEnd: CFTimeInterval = 0;
  
  private(set) public var timeCurrent: CFTimeInterval = 0;
  private(set) public var timeElapsed: CFTimeInterval = 0;
  
  private(set) public var progress: CGFloat = 0;
  private(set) public var duration: CFTimeInterval;
  
  public let animatedValuesSize: Int;
  
  private(set) public var animatedValuesStart: [CGFloat];
  private(set) public var animatedValuesEnd: [CGFloat];
  
  private(set) public var animatedValuesPrev: [CGFloat] = [];
  private(set) public var animatedValuesCurrent: [CGFloat] = [];
  
  public var allowAnimatedValueToRegress = true;
  
  // MARK: - Properties - Stored Functions
  // -------------------------------------
  
  private var applyPendingUpdates: (() -> Void)? = nil;
  
  public var onAnimatedValueChange: ((_ animatedValues: [CGFloat]) -> Void)?;
  public var onAnimationCompletion: (() -> Void)?;
  
  // MARK: - Properties - Computed
  // -----------------------------
  
  public var isFinished: Bool {
    self.animatedValuesCurrent.enumerated().allSatisfy {
      self.animatedValuesStart[$0.offset] < self.animatedValuesEnd[$0.offset]
        ? $0.element >= self.animatedValuesEnd[$0.offset]
        : $0.element <= self.animatedValuesEnd[$0.offset]
    };
  };
  
  public var isAnimating: Bool {
    self.displayLink != nil
  };
  
  // MARK: - Init
  // ------------
  
  public init?(
    durationSeconds: CFTimeInterval,
    animatedValuesStart: [CGFloat],
    animatedValuesEnd: [CGFloat],
    onAnimatedValueChange: ((_ animatedValues: [CGFloat]) -> Void)? = nil,
    onAnimationCompletion: (() -> Void)? = nil
  ) {
    guard animatedValuesStart.count == animatedValuesEnd.count else {
      return nil;
    };
    
    self.duration = durationSeconds;
    
    self.animatedValuesStart = animatedValuesStart;
    self.animatedValuesEnd = animatedValuesEnd;
    
    let arraySize = animatedValuesStart.count;
    self.animatedValuesSize = arraySize;
    
    self.animatedValuesCurrent = [CGFloat](repeating: 0, count: arraySize);
    self.animatedValuesPrev = [CGFloat](repeating: 0, count: arraySize);
    
    self.onAnimatedValueChange = onAnimatedValueChange;
    self.onAnimationCompletion = onAnimationCompletion;
  };
  
  // MARK: - Functions
  // -----------------
  
  @objc private func onDisplayLinkDidFire(_ displayLink: CADisplayLink){
    
    self.timeCurrent = CACurrentMediaTime();
    self.timeElapsed = self.timeCurrent - self.timeStart;
    
    self.progress = self.timeElapsed / self.duration;
    
    var didChange = false;
    
    for index in 0 ..< self.animatedValuesSize {
      
      let animatedValueNextRaw = Self.EasingFunctions.lerp(
        valueStart: self.animatedValuesStart[index],
        valueEnd: self.animatedValuesEnd[index],
        percent: self.easing.easingFunction(self.progress)
      );
      
      let animatedValuesStart = self.animatedValuesStart[index];
      let animatedValueEnd = self.animatedValuesEnd[index];
      
      // clamp
      let animatedValueNext: CGFloat = {
        // E.g. 50 -> 100
        if animatedValuesStart <= animatedValueEnd {
          return animatedValueNextRaw > animatedValueEnd
            ? animatedValueEnd
            : animatedValueNextRaw;
          
        } else {
          // E.g. 100 -> 50
          return animatedValueNextRaw < animatedValueEnd
            ? animatedValueEnd
            : animatedValueNextRaw;
        };
      }();
      
      let animatedValuePrev = self.animatedValuesPrev[index];
      let animatedValueCurrent = self.animatedValuesCurrent[index];
      
      let shouldUpdate = self.allowAnimatedValueToRegress
        ? true
        : animatedValueNext > animatedValueCurrent;
      
      guard shouldUpdate else { continue };
      
      self.animatedValuesPrev[index] = self.animatedValuesCurrent[index];
      self.animatedValuesCurrent[index] = animatedValueNext;
      
      if !didChange {
        didChange = animatedValuePrev != animatedValueNext;
      };
    };
    
    if didChange {
      self.onAnimatedValueChange?(self.animatedValuesCurrent);
    };
    
    if self.isFinished {
      self.stop();
      self.onAnimationCompletion?();
    };
    
    self.applyPendingUpdates?();
  };
  
  // MARK: - Functions - Public
  // --------------------------
  
  public func start(){
    self.stop();
  
    self.timeCurrent = CACurrentMediaTime();
    self.timeStart = self.timeCurrent;
    self.timeEnd = self.timeCurrent + self.duration;
    
    let displayLink = CADisplayLink(
      target: self,
      selector: #selector(Self.onDisplayLinkDidFire(_:))
    );
    
    displayLink.add(to: .current, forMode:.default);
    self.displayLink = displayLink;
  };
  
  public func stop() {
    self.displayLink?.invalidate();
    self.displayLink = nil;
  };
  
  public func update(
    animatedValuesEnd: [CGFloat],
    duration: CGFloat? = nil
  ){
    self.applyPendingUpdates = { [unowned self] in
      self.animatedValuesStart = self.animatedValuesCurrent;
      self.animatedValuesEnd = animatedValuesEnd;
      
      self.timeCurrent = CACurrentMediaTime();
      
      if let newDuration = duration {
        self.duration = newDuration;
        
      } else {
        let timeRemaining = self.duration - self.timeElapsed;
        self.duration = timeRemaining;
      };
      
      self.timeStart = self.timeCurrent;
      self.timeEnd = self.timeCurrent + self.duration;
    };
  };
};
