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
  
  var isDismissing: Bool {
    switch self {
      case .DISMISSING_UNKNOWN,
           .DISMISSING_GESTURE,
           .DISMISSING_PROGRAMMATIC:
        return true;
        
      default:
        return false;
    };
  };
  
  var isDismissingKnown: Bool {
    self.isDismissing && self != .DISMISSING_UNKNOWN;
  };
  
  var isPresenting: Bool {
    switch self {
      case .PRESENTING_PROGRAMMATIC,
           .PRESENTING_UNKNOWN,
           .DISMISS_GESTURE_CANCELLING:
        return true;
        
      default:
        return false;
    };
  };
  
  var isNotSpecific: Bool {
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
  
  var isDismissViaGestureCancelling: Bool {
    self == .DISMISS_GESTURE_CANCELLING;
  };
  
  var isDismissingViaGesture: Bool {
    self == .DISMISSING_GESTURE
  };
  
  var isPresented: Bool {
    self == .PRESENTED;
  };
  
  var isDismissed: Bool {
    self == .DISMISSED;
  };
};

public struct RNIModalPresentationStateMachine {
  
  // MARK: - Properties
  // ------------------
  
  var state: RNIModalPresentationState = .INITIAL;
  var statePrev: RNIModalPresentationState = .INITIAL;
  
  // MARK: - Properties - Completion Handlers
  // ----------------------------------------
  
  var onDismissWillCancel: (() -> Void)?;
  var onDismissDidCancel: (() -> Void)?;
  
  // MARK: - Functions
  // -----------------
  
  mutating func set(state nextState: RNIModalPresentationState){
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
      /// * ✅: `PRESENTING_PROGRAMMATIC` -> `PRESENTING_UNKNOWN`
      /// * ❌: `DISMISSING_GESTURE` -> `DISMISSING_UNKNOWN`
      return;
              
    } else {
      self.state = nextState;
    };
  };
};
