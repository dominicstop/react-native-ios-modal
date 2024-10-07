//
//  ModalViewControllerEventsNotifiable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/30/24.
//

import UIKit


public protocol ModalViewControllerEventsNotifiable {
  
  func notifyOnModalWillPresent(
    sender: UIViewController,
    isAnimated: Bool
  );
  
  func notifyOnModalDidPresent(
    sender: UIViewController,
    isAnimated: Bool
  );
  
  func notifyOnModalWillDismiss(
    sender: UIViewController,
    isAnimated: Bool
  );
  
  func notifyOnModalDidDismiss(
    sender: UIViewController,
    isAnimated: Bool
  );
};

// MARK: - ModalViewControllerEventsNotifiable
// -------------------------------------------

public extension ModalViewControllerEventsNotifiable {
  
  func notifyOnModalWillPresent(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    // no-op
  };
  
  func notifyOnModalDidPresent(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    // no-op
  };
  
  func notifyOnModalWillDismiss(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    // no-op
  };
  
  func notifyOnModalDidDismiss(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    // no-op
  };
};
