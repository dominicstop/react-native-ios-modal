//
//  RNIModalPresentationState.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/7/23.
//

import Foundation


public enum RNIModalPresentationState: String {
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
  
  // MARK: - Computed Properties
  // ---------------------------
  
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
  
  public var isNotSpecific: Bool {
    switch self {
      case .PRESENTING_UNKNOWN,
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
  
  public var isPresented: Bool {
    self == .PRESENTED;
  };
  
  public var isDismissed: Bool {
    self == .DISMISSED;
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
    self.state == .PRESENTED;
  };
  
  public var wasDismissViaGestureCancelled: Bool {
    self.statePrev.isDismissViaGestureCancelling
  };
  
  // MARK: - Functions
  // -----------------
  
  public mutating func set(state nextState: RNIModalPresentationState){
    let prevState = self.state;
    self.statePrev = prevState;
    
    if prevState.isDismissingViaGesture && nextState.isPresenting {
      self.state = .DISMISS_GESTURE_CANCELLING;
      self.onDismissWillCancel?();
      
    } else if prevState.isDismissViaGestureCancelling && nextState.isPresented {
      self.state = nextState;
      self.onDismissDidCancel?();
      
    } else if !prevState.isNotSpecific && nextState.isNotSpecific {
      /// Do not over-write specific/"known state", with non-specific/"unknown
      /// state", e.g.
      ///
      /// * ✅: `PRESENTING_UNKNOWN` -> `PRESENTING_PROGRAMMATIC`
      /// * ❌: `DISMISSING_GESTURE` -> `DISMISSING_UNKNOWN`
      return;
              
    } else {
      self.state = nextState;
    };
  };
};
