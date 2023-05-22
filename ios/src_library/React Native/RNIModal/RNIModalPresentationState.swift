//
//  RNIModalPresentationState.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/7/23.
//

import UIKit


public enum RNIModalPresentationState: String, CaseIterable {
  
  // MARK: - Enum Cases
  // ------------------
  
  case INITIAL;
  
  case PRESENTING_PROGRAMMATIC;
  case PRESENTING_UNKNOWN;

  case PRESENTED;
  case PRESENTED_UNKNOWN;
  
  case DISMISSING_GESTURE;
  case DISMISSING_PROGRAMMATIC;
  case DISMISSING_UNKNOWN;
  
  case DISMISS_GESTURE_CANCELLING;
  
  case DISMISSED;
  
  // MARK: - Computed Properties - Private
  // -------------------------------------
  
  fileprivate var step: Int {
    switch self {
      case .INITIAL:
        return 0;
      
      case .PRESENTING_PROGRAMMATIC: fallthrough;
      case .PRESENTING_UNKNOWN     :
        return 1;

      case .PRESENTED        : fallthrough
      case .PRESENTED_UNKNOWN:
        return 2;
      
      case .DISMISSING_GESTURE     : fallthrough;
      case .DISMISSING_PROGRAMMATIC: fallthrough;
      case .DISMISSING_UNKNOWN     :
        return 3;
      
      case .DISMISS_GESTURE_CANCELLING:
        return 4;
      
      case .DISMISSED:
        return 5;
    };
  };
  
  // MARK: - Computed Properties - Public
  // ------------------------------------
  
  public var isDismissing: Bool {
    switch self {
      case .DISMISSING_UNKNOWN,
           .DISMISSING_GESTURE,
           .DISMISSING_PROGRAMMATIC:
        return true;
        
      default:
        return false;
    };
  };
  
  public var isDismissingKnown: Bool {
    self.isDismissing && self != .DISMISSING_UNKNOWN;
  };
  
  public var isPresenting: Bool {
    switch self {
      case .PRESENTING_PROGRAMMATIC,
           .PRESENTING_UNKNOWN,
           .DISMISS_GESTURE_CANCELLING:
        return true;
        
      default:
        return false;
    };
  };
  
  public var isPresented: Bool {
    switch self {
      case .PRESENTED,
           .PRESENTED_UNKNOWN:
        return true;
        
      default:
        return false;
    };
  };
  
  public var isNotSpecific: Bool {
    switch self {
      case .PRESENTED_UNKNOWN,
           .PRESENTING_UNKNOWN,
           .DISMISSING_UNKNOWN:
        return true;
        
      default:
        return false;
    };
  };
  
  // MARK: - Computed Properties - Alias
  // -----------------------------------
  
  public var isDismissViaGestureCancelling: Bool {
    self == .DISMISS_GESTURE_CANCELLING;
  };
  
  public var isDismissingViaGesture: Bool {
    self == .DISMISSING_GESTURE
  };
  
  public var isDismissed: Bool {
    self == .DISMISSED || self == .INITIAL;
  };
  
  // MARK: - Computed Properties - Composite
  // ---------------------------------------
  
  public var isDismissedOrDismissing: Bool {
    self.isDismissed || self.isDismissing;
  };
  
  public var isPresentedOrPresenting: Bool {
    self.isPresented || self.isPresenting;
  };
};

public struct RNIModalPresentationStateMachine: RNIDictionaryRepresentable {
  
  // MARK: - Properties
  // ------------------
  
  private(set) public var state: RNIModalPresentationState = .INITIAL;
  private(set) public var statePrev: RNIModalPresentationState = .INITIAL;
  
  // MARK: - Properties - Completion Handlers
  // ----------------------------------------
  
  public var onDismissWillCancel: (() -> Void)?;
  public var onDismissDidCancel: (() -> Void)?;
  
  // MARK: - Properties
  // ------------------
  
  private var _isInitialPresent: Bool? = nil;
  private var _wasCancelledDismiss: Bool = false;
  
  public var wasCancelledPresent: Bool = false;
  public var wasCancelledDismissViaGesture: Bool = false;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var isInitialPresent: Bool {
    self._isInitialPresent ?? true;
  };
  
  public var isPresented: Bool {
    self.state.isPresented
  };
  
  public var wasCancelledDismiss: Bool {
    self._wasCancelledDismiss || self.wasCancelledDismissViaGesture;
  };
  
  public var didChange: Bool {
    self.statePrev != self.state;
  };
  
  // MARK: RNIDictionaryRepresentable
  // --------------------------------
  
  public var asDictionary: [String : Any] {[
    "state": self.state,
    "statePrev": self.statePrev,
    "isInitialPresent": self.isInitialPresent,
    "isPresented": self.isPresented,
    "isDismissed": self.state.isDismissed,
    "wasCancelledDismiss": self.wasCancelledDismiss,
    "wasCancelledPresent": self.wasCancelledPresent,
    "wasCancelledDismissViaGesture": self.wasCancelledDismissViaGesture,
  ]};
  
  // MARK: - Functions
  // -----------------
  
  init(
    onDismissWillCancel: ( () -> Void)? = nil,
    onDismissDidCancel: ( () -> Void)? = nil
  ) {
    self.onDismissWillCancel = onDismissWillCancel;
    self.onDismissDidCancel = onDismissDidCancel;
  }
  
  public mutating func set(state nextState: RNIModalPresentationState){
    let prevState = self.state;
    
    guard prevState != nextState else {
      // early exit if no change
      return
    };
    
    let isBecomingUnknown = !prevState.isNotSpecific && nextState.isNotSpecific;
    let isSameStep = prevState.step == nextState.step;
    
    /// Do not over-write specific/"known state", with non-specific/"unknown
    /// state", e.g.
    ///
    /// * ✅: `PRESENTING_UNKNOWN` -> `PRESENTING_PROGRAMMATIC`
    /// * ❌: `DISMISSING_GESTURE` -> `DISMISSING_UNKNOWN`
    ///
    if isSameStep {
      if !isBecomingUnknown {
        self.state = nextState;
      };
      
      #if DEBUG
      print(
          "Warning - RNIModalPresentationStateMachine.set"
        + " - prevState: \(prevState)"
        + " - nextState: \(nextState)"
      );
      #endif
      return;
    };
    
    self.statePrev = prevState;
    
    if prevState.isDismissingViaGesture && nextState.isPresenting {
      self.wasCancelledDismissViaGesture = true;
      self.state = .DISMISS_GESTURE_CANCELLING;
      self.onDismissWillCancel?();
      
    } else if prevState.isDismissViaGestureCancelling && nextState.isPresented {
      self.state = nextState;
      self.onDismissDidCancel?();
      
    } else  {
      self.state = nextState;
    };
    
    self.updateProperties();
    self.resetIfNeeded();
    
    #if DEBUG
    print(
        "Log - RNIModalPresentationStateMachine.set"
      + " - statePrev: \(self.statePrev)"
      + " - nextState: \(self.state)"
      + " - isInitialPresent: \(self.isInitialPresent)"
      + " - wasCancelledPresent: \(self.wasCancelledPresent)"
      + " - wasCancelledDismiss: \(self.wasCancelledDismiss)"
      + " - wasCancelledDismissViaGesture: \(self.wasCancelledDismissViaGesture)"
    );
    #endif
  };
  
  private mutating func updateProperties(){
    let nextState = self.state;
    let prevState = self.statePrev;
    
    if nextState.isPresenting && self._isInitialPresent == nil {
      self._isInitialPresent = true;
      
    } else if nextState.isPresenting && self._isInitialPresent == true {
      self._isInitialPresent = false;
    };
    
    if prevState.isPresenting && nextState.isDismissedOrDismissing {
      self.wasCancelledPresent = true;
      
    } else if prevState.isDismissing && nextState.isPresentedOrPresenting {
      self._wasCancelledDismiss = true;
    };
  };
  
  private mutating func resetIfNeeded(){
    if self.state.isPresented {
      self.wasCancelledPresent = false;
      
    } else if self.state == .DISMISSED {
      // reset
      self.wasCancelledDismissViaGesture = false;
      self.wasCancelledPresent = false;
      self._isInitialPresent = nil;
      self._wasCancelledDismiss = false;
    };
  };
};
