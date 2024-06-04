//
//  RNIModalFocusState.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/8/23.
//

import UIKit


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

public struct RNIModalFocusStateMachine: RNIDictionaryRepresentable {
  
  // MARK: - Properties
  // ------------------
  
  private(set) public var state: RNIModalFocusState = .INITIAL;
  private(set) public var statePrev: RNIModalFocusState = .INITIAL;
  
  public var wasBlurCancelled: Bool = false;
  public var wasFocusCancelled: Bool = false;
  
  public var didChange: Bool {
    self.statePrev != self.state;
  };
  
  // MARK: - RNIDictionaryRepresentable
  // ----------------------------------
  
  public var asDictionary: [String : Any] {[
    "state": self.state,
    "statePrev": self.statePrev,
    "isFocused": self.state.isFocused,
    "isBlurred": self.state.isBlurred,
    "isTransitioning": self.state.isTransitioning,
    "wasBlurCancelled": self.wasBlurCancelled,
    "wasFocusCancelled": self.wasFocusCancelled,
  ]};
  
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
    
    if prevState.isBlurring && nextState.isFocusing {
      self.wasBlurCancelled = true;
      
    } else if prevState.isFocusing && nextState.isBlurring {
      self.wasFocusCancelled = true;
    };
    
    #if DEBUG
    print(
        "Log - RNIModalFocusState.set"
      + " - prevState: \(prevState)"
      + " - nextState: \(nextState)"
      + " - self.wasBlurCancelled: \(self.wasBlurCancelled)"
      + " - self.wasFocusCancelled: \(self.wasFocusCancelled)"
    );
    #endif
    
    self.resetIfNeeded();
  };
  
  mutating func resetIfNeeded(){
    if self.state.isBlurred {
      self.wasBlurCancelled = false;
    };
    
    if self.state.isFocused {
      self.wasFocusCancelled = false;
    };
  };
};
