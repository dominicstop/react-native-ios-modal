//
//  RNIModal.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/16/23.
//

import Foundation

/// A collection of protocols that the "adoptee" needs to implement in order to
/// be considered a "modal".
///
public typealias RNIModal =
    RNIIdentifiable
  & RNIModalState
  & RNIModalRequestable
  & RNIModalFocusNotifiable
  & RNIModalFocusNotifying
  & RNIModalPresentation;

/// Contains modal-related properties for keeping track of the state of the
/// modal.
///
/// Specifies that the "adoptee/delegate" that conforms to this protocol must
/// have the specified modal-related properties for keeping track of state
///
/// The "implementor/delegator" updates these properties; The delegate
/// should treat the properties declared in this protocol as read-only.
///
public protocol RNIModalState: AnyObject {
  
  var modalIndexPrev: Int! { set get };
  
  var modalIndex: Int! { set get };
  
  var modalState: RNIModalPresentationStateMachine { set get };
  
  var isModalInFocus: Bool { set get };
  
};

/// Contains functions that are invoked to request modal-related actions.
///
/// The "implementer/delegator" notifies the "adoptee/delegate" of this protocol
/// of requests to perform "modal-related" actions.
///
public protocol RNIModalRequestable: AnyObject {
  
  func requestModalToShow(
    sender: any RNIModal,
    onRequestApprovedBlock: () -> Void,
    onRequestDeniedBlock: (_ reason: String) -> Void
  );
  
  func requestModalToHide(
    sender: any RNIModal,
    onRequestApprovedBlock: () -> Void,
    onRequestDeniedBlock: (_ reason: String) -> Void
  );
};

/// Contains functions that get called whenever a modal-related event occurs.
///
/// The "implementer/delegator" notifies the "adoptee/delegate" of this protocol
/// of modal focus/blur related events.
///
/// An interface for the "adoptee/delegate" to receive and handle incoming
/// modal "focus/blur"-related notifications.
///
public protocol RNIModalFocusNotifiable: AnyObject {
  func onModalWillFocusNotification(sender: any RNIModal);
  
  func onModalDidFocusNotification(sender: any RNIModal);
  
  func onModalWillBlurNotification(sender: any RNIModal);
  
  func onModalDidBlurNotification(sender: any RNIModal);
  
};

/// Specifies that the "adoptee/delegate" that conforms to this protocol must
/// notify a delegate of modal "focus/blur"-related events
///
public protocol RNIModalFocusNotifying: AnyObject {
  
  /// Notify the "shared modal manager" if the current modal instance is going
  /// to be shown or hidden.
  ///
  /// That focus notification will then be relayed to the other modal instances.
  ///
  var modalFocusDelegate: RNIModalFocusNotifiable! { get set };

};

/// Properties related to modal presentation.
///
/// Specifies that the "adoptee/delegate" that conforms to this protocol must
/// implement this so that the "delegator" understands how the delegate presents
/// the modal.
///
public protocol RNIModalPresentation: AnyObject {
  
  /// Returns the modal view controller that is to be presented
  var modalViewController: UIViewController? { get };
  
  /// Returns the view controller that presented the `modalViewController`
  /// instance.
  var presentingViewController: UIViewController? { get };
  
  /// The "main" window for this instance
  var window: UIWindow? { get };

};
