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
  RNIIdentifiable, RNIModalIdentifiable, RNIModalPresentationNotifying,
  RNIModalState, RNIModalPresentation {
  
  // MARK: - Properties - RNIIdentifiable
  // ------------------------------------
  
  public static var synthesizedIdPrefix: String = "modal-wrapper-";
  
  // MARK: - Properties
  // ------------------
  
  /// The view controller that this instance is wrapping/managing
  public var viewController: UIViewController;
  
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
  /// `UIViewController.presentingViewController`
  ///
  public weak var presentingViewController: UIViewController?;
  
  public var window: UIWindow? {
    self.viewController.view.window ??
      self.presentingViewController?.view.window
  };
  
  var focusDelegate: RNIModalFocusNotifiable? {
    return self.viewController as? RNIModalFocusNotifiable
  };
  
  // MARK: - Functions
  // -----------------
  
  public init(viewController: UIViewController){
    self.viewController = viewController;
    RNIModalManagerShared.register(modal: self);
  };
};

// MARK: - RNIModalRequestable
// ---------------------------

extension RNIModalViewControllerWrapper: RNIModalRequestable {
  
  public func requestModalToShow(
    sender: Any,
    animated: Bool,
    completion: @escaping () -> Void
  ) {
    // TBA - no-op
  };
  
  public func requestModalToHide(
    sender: Any,
    animated: Bool,
    completion: @escaping () -> Void
  ) {
    // TBA - no-op
  };
};

// MARK: - RNIModalFocusNotifiable
// -------------------------------

extension RNIModalViewControllerWrapper: RNIModalFocusNotifiable {
  public func onModalWillFocusNotification(sender: any RNIModal) {
    guard let focusDelegate = self.focusDelegate else { return };
    focusDelegate.onModalWillFocusNotification(sender: sender);
  };
  
  public func onModalDidFocusNotification(sender: any RNIModal) {
    guard let focusDelegate = self.focusDelegate else { return };
    focusDelegate.onModalDidFocusNotification(sender: sender);
  };
  
  public func onModalWillBlurNotification(sender: any RNIModal) {
    guard let focusDelegate = self.focusDelegate else { return };
    focusDelegate.onModalWillBlurNotification(sender: sender);
  };
  
  public func onModalDidBlurNotification(sender: any RNIModal) {
    guard let focusDelegate = self.focusDelegate else { return };
    focusDelegate.onModalDidBlurNotification(sender: sender);
  };
};


