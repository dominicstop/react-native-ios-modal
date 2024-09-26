//
//  SheetViewControllerEventsNotifiable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import UIKit


public protocol SheetViewControllerEventsNotifiable: AnyObject {
  
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
};

// MARK: - SheetViewControllerEventsNotifiable
// -------------------------------------------

public extension SheetViewControllerEventsNotifiable {
  
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
};
