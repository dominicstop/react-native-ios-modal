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
  
  func notifyOnSystemSheetPanGestureInvoked(
    sender: UIViewController,
    panGesture: UIPanGestureRecognizer,
    gesturePoint: CGPoint
  );
  
  func notifyOnScrollViewPanGestureInvoked(
    sender: UIViewController,
    panGesture: UIPanGestureRecognizer,
    scrollView: UIScrollView
  );
  
  func notifyOnSheetBeingDraggedByPanGesture(
    sender: UIViewController,
    panGesture: UIPanGestureRecognizer
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
  
  func notifyOnSystemSheetPanGestureInvoked(
    sender: UIViewController,
    panGesture: UIPanGestureRecognizer,
    gesturePoint: CGPoint
  ) {
    // no-op
  };
  
  func notifyOnScrollViewPanGestureInvoked(
    sender: UIViewController,
    panGesture: UIPanGestureRecognizer,
    scrollView: UIScrollView
  ) {
    // no-op
  };
  
  func notifyOnSheetBeingDraggedByPanGesture(
    sender: UIViewController,
    panGesture: UIPanGestureRecognizer
  ) {
    // no-op
  };
};
