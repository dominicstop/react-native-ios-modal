//
//  ModalSheetViewControllerEventsNotifiable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import UIKit


public protocol ModalSheetViewControllerEventsNotifiable: AnyObject {
  
  func notifyOnSheetDidAttemptToDismissViaGesture(
    sender: UIViewController,
    presentationController: UIPresentationController
  );
  
  func notifyOnSheetDidDismissViaGesture(
    sender: UIViewController,
    presentationController: UIPresentationController
  );
  
  func notifyOnSheetWillDismissViaGesture(
    sender: UIViewController,
    presentationController: UIPresentationController
  );
  
  func notifyOnSytemSheetPanGestureInvoked(
    sender: UIViewController,
    panGesture: UIPanGestureRecognizer,
    gesturePoint: CGPoint
  );
};

// MARK: - SheetViewControllerEventsNotifiable
// -------------------------------------------

public extension ModalSheetViewControllerEventsNotifiable {
  
  func notifyOnSheetDidAttemptToDismissViaGesture(
    sender: UIViewController,
    presentationController: UIPresentationController
  ) {
    // no-op
  };
  
  func notifyOnSheetDidDismissViaGesture(
    sender: UIViewController,
    presentationController: UIPresentationController
  ) {
    // no-op
  };
  
  func notifyOnSheetWillDismissViaGesture(
    sender: UIViewController,
    presentationController: UIPresentationController
  ) {
    // no-op
  };
  
  func notifyOnSytemSheetPanGestureInvoked(
    sender: UIViewController,
    panGesture: UIPanGestureRecognizer,
    gesturePoint: CGPoint
  ) {
    // no-op
  };
};
