//
//  RNIModalFocusState.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/8/23.
//

import Foundation


public enum RNIModalFocusState: String {
  case INITIAL;
  
  case FOCUSING
  case FOCUSED;
  
  case BLURRING;
  case BLURRED;
  
  // MARK: - Properties - Computed
  // -----------------------------
  
  public var isInitialized: Bool {
    self != .INITIAL
  };
  
  public var isFocused: Bool {
    self == .FOCUSED;
  };
  
  public var isBlurred: Bool {
    self == .BLURRED || self == .INITIAL;
  };
  
  public var isFocusing: Bool {
    self == .FOCUSING;
  };
  
  public var isBlurring: Bool {
    self == .BLURRING;
  };
  
  public var isTransitioning: Bool {
    self.isBlurring || self.isFocusing;
  };
  
  public var isBlurredOrBlurring: Bool {
    self.isBlurred || self.isBlurring;
  };
  
  public var isFocusedOrFocusing: Bool {
    self.isFocused || self.isFocusing;
  };
};

public struct RNIModalFocusStateMachine {
  
  // MARK: - Properties
  // ------------------
  
  private(set) public var state: RNIModalFocusState = .INITIAL;
  private(set) public var statePrev: RNIModalFocusState = .INITIAL;
  
  // MARK: - Functions
  // ------------------
  
  public mutating func set(state nextState: RNIModalFocusState){
    let prevState = self.state;
    
    // early exit if no change
    guard prevState != nextState else {
      #if DEBUG
      print(
          "Error - RNIModalFocusStateMachine.set"
        + " - arg nextState: \(nextState)"
        + " - prevState: \(prevState)"
        + " - No changes, ignoring..."
      );
      #endif
      return;
    };
    
    if prevState.isInitialized && !nextState.isInitialized {
      /// Going from "initialized state" (e.g. `FOCUSED`, `FOCUSING`, etc), to
      /// an "uninitialized state" (i.e. `INITIAL`) is not allowed
      return;
      
    } else {
      self.state = nextState;
      self.statePrev = prevState;
    };
  };
};
