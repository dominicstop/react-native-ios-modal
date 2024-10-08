//
//  ModalSheetState.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import Foundation


public enum ModalSheetState: String {

  case presenting;
  case dismissViaGestureCancelling;
  
  case presented;
  case dismissViaGestureCancelled;
  
  case draggingViaGesture;
  
  case dismissing;
  case dismissingViaGesture;
  case presentingViaGestureCanceling;
  
  case dismissed;
  case dismissedViaGesture;
  case presentingViaGestureCancelled;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var modalState: ModalState {
    switch self {
      case .presenting, .dismissViaGestureCancelling:
        return .presenting;
        
      case .presented, .dismissViaGestureCancelled:
        return .presented;
        
      case .dismissing, .dismissingViaGesture, .presentingViaGestureCanceling, .draggingViaGesture:
        return .dismissing;
        
      case .dismissed, .dismissedViaGesture, .presentingViaGestureCancelled:
        return .dismissed;
    };
  };
  
  public var isPresenting: Bool {
    self.modalState.isPresenting;
  };
  
  public var isPresented: Bool {
    self.modalState.isPresented;
  };
  
  public var isDismissing: Bool {
    self.modalState.isDismissing;
  };
  
  public var isDismissed: Bool {
    self.modalState.isDismissed;
  };
  
  public var isDraggingViaGesture: Bool {
    self == .draggingViaGesture;
  };
  
  public var isInPresentation: Bool {
       !self.isDraggingViaGesture
    && self.modalState.isInPresentation
  };
  
  public var isIdle: Bool {
    switch self {
      case .draggingViaGesture:
        return false;
        
      default:
        return self.modalState.isIdle;
    };
  };
  
  public var simplified: Self {
    self.modalState.modalSheetState;
  };
  
  public var isSpecific: Bool {
    self.simplified != self;
  };
  
  // MARK: - Functions
  // -----------------
  
  public func isSameStep(comparedTo otherState: Self) -> Bool {
    self.simplified == otherState.simplified;
  };
  
  public func isGeneric(comparedTo otherState: Self) -> Bool {
    guard self.isSameStep(comparedTo: otherState) else {
      return false;
    };
    
    switch(self, otherState){
      case (.draggingViaGesture, let otherState) where otherState.isInPresentation:
        return false;
        
      case (let currentState, .draggingViaGesture) where currentState.isInPresentation:
        return false;
      
      default:
        return !self.isSpecific && otherState.isSpecific
    };
  };
};
