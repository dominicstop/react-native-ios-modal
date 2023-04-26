//
//  RNIModalViewControllerWrapper.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/13/23.
//

import Foundation

/// Wraps a `UIViewController` so it can be used w/ `RNIModalManager`
///
public class RNIModalViewControllerWrapper:
  RNIIdentifiable, RNIModalPresentationNotifying, RNIModalState,
  RNIModalPresentation {
  
  // MARK: - Properties - RNIIdentifiable
  // ------------------------------------
  
  public static var synthesizedIdPrefix: String = "modal-wrapper-";
  
  // MARK: - Properties - RNIModalPresentationNotifying
  // --------------------------------------------------
  
  public var modalPresentationNotificationDelegate: RNIModalPresentationNotifiable!
  
  // MARK: - Properties - RNIModalState
  // ----------------------------------
  
  public var modalIndexPrev: Int!
  public var modalIndex: Int!
  
  public lazy var modalPresentationState = RNIModalPresentationStateMachine();
  
  public var modalFocusState = RNIModalFocusStateMachine();
  
  // MARK: - Properties - RNIModalPresentation
  // -----------------------------------------
  
  /// The modal that is being presented, or to be presented (i.e.
  /// `UIViewController.presentedViewController`).
  ///
  public weak var modalViewController: UIViewController?;
  
  /// The view controller that presented the modal (i.e.
  /// `modalViewController` or `UIViewController.presentingViewController`)
  ///
  public weak var presentingViewController: UIViewController?;
  
  public var window: UIWindow? {
    self.presentingViewController?.view.window
  };
  
  // MARK: - Functions
  // -----------------
  
  public init(){
    RNIModalManagerShared.register(modal: self);
  };
};

// MARK: - RNIModalRequestable
// ---------------------------

extension RNIModalViewControllerWrapper: RNIModalRequestable {
  
  public func requestModalToShow(
    sender: any RNIModal,
    onRequestApprovedBlock: () -> Void,
    onRequestDeniedBlock: (String) -> Void
  ) {
    // TBA - no-op
  };
  
  public func requestModalToHide(
    sender: any RNIModal,
    onRequestApprovedBlock: () -> Void,
    onRequestDeniedBlock: (String) -> Void
  ) {
    // TBA - no-op
  };
};

// MARK: - RNIModalFocusNotifiable
// -------------------------------

extension RNIModalViewControllerWrapper: RNIModalFocusNotifiable {
  public func onModalWillFocusNotification(sender: any RNIModal) {
    guard let delegate = self.modalViewController as? RNIModalFocusNotifiable
    else { return };
    
    delegate.onModalWillFocusNotification(sender: sender);
  };
  
  public func onModalDidFocusNotification(sender: any RNIModal) {
    guard let delegate = self.modalViewController as? RNIModalFocusNotifiable
    else { return };
    
    delegate.onModalDidFocusNotification(sender: sender);
  }
  
  public func onModalWillBlurNotification(sender: any RNIModal) {
    guard let delegate = self.modalViewController as? RNIModalFocusNotifiable
    else { return };
    
    delegate.onModalWillBlurNotification(sender: sender);
  }
  
  public func onModalDidBlurNotification(sender: any RNIModal) {
    guard let delegate = self.modalViewController as? RNIModalFocusNotifiable
    else { return };
    
    delegate.onModalDidBlurNotification(sender: sender);
  }
};


