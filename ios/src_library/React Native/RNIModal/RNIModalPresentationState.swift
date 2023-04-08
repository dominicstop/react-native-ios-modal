//
//  RNIModalPresentationState.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/7/23.
//

import Foundation


public enum RNIModalPresentationState: String, CaseIterable {
  
  // MARK: - Enum Cases
  // ------------------
  
  case INITIAL;
  
  case PRESENTING_PROGRAMMATIC;
  case PRESENTING_UNKNOWN;

  case PRESENTED_FOCUSING;
  case PRESENTED_FOCUSED;
  case PRESENTED_BLURRING;
  case PRESENTED_BLURRED;
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

      case .PRESENTED_FOCUSING: fallthrough;
      case .PRESENTED_FOCUSED : fallthrough;
      case .PRESENTED_BLURRING: fallthrough;
      case .PRESENTED_BLURRED : fallthrough;
      case .PRESENTED_UNKNOWN :
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
      case .PRESENTED_FOCUSING,
           .PRESENTED_FOCUSED,
           .PRESENTED_BLURRING,
           .PRESENTED_BLURRED,
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
    self == .DISMISSED;
  };
  
  public var isInFocus: Bool {
    self == .PRESENTED_FOCUSED;
  };
};

public struct RNIModalPresentationStateMachine {
  
  // MARK: - Properties
  // ------------------
  
  private(set) public var state: RNIModalPresentationState = .INITIAL;
  private(set) public var statePrev: RNIModalPresentationState = .INITIAL;
  
  // MARK: - Properties - Completion Handlers
  // ----------------------------------------
  
  public var onDismissWillCancel: (() -> Void)?;
  public var onDismissDidCancel: (() -> Void)?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var isPresented: Bool {
    self.state.isPresented
  };
  
  public var isInFocus: Bool {
    self.state.isInFocus
  };
  
  public var wasDismissViaGestureCancelled: Bool {
    self.statePrev.isDismissViaGestureCancelling
  };
  
  // MARK: - Functions
  // -----------------
  
  public mutating func set(state nextState: RNIModalPresentationState){
    let prevState = self.state;
    
    guard prevState != nextState else {
      // early exit if no change
      return
    };
    
    self.statePrev = prevState;
    
    let isBecomingUnknown = prevState.isNotSpecific && !nextState.isNotSpecific;
    let isSameStep = prevState.step == nextState.step;
    
    /// Do not over-write specific/"known state", with non-specific/"unknown
    /// state", e.g.
    ///
    /// * ✅: `PRESENTING_UNKNOWN` -> `PRESENTING_PROGRAMMATIC`
    /// * ❌: `DISMISSING_GESTURE` -> `DISMISSING_UNKNOWN`
    ///
    if isBecomingUnknown && isSameStep {
      #if DEBUG
      print(
          "Warning - RNIModalPresentationStateMachine.set"
        + " - arg nextState: \(nextState)"
      );
      #endif
      return;
    };
    
    if prevState.isDismissingViaGesture && nextState.isPresenting {
      self.state = .DISMISS_GESTURE_CANCELLING;
      self.onDismissWillCancel?();
      
    } else if prevState.isDismissViaGestureCancelling && nextState.isPresented {
      self.state = nextState;
      self.onDismissDidCancel?();
      
    } else {
      self.state = nextState;
    };
  };
};
