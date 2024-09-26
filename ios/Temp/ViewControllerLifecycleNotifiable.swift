//
//  ViewControllerLifecycleNotifiable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import UIKit


public protocol ViewControllerLifecycleNotifiable: AnyObject {
  
  func notifyOnViewDidLoad(sender: UIViewController);

  func notifyOnViewWillAppear(
    sender: UIViewController,
    isAnimated: Bool
  );
  
  func notifyOnViewIsAppearing(
    sender: UIViewController,
    isAnimated: Bool
  );
  
  func notifyOnViewDidAppear(
    sender: UIViewController,
    isAnimated: Bool
  );
  
  func notifyOnViewWillDisappear(
    sender: UIViewController,
    isAnimated: Bool
  );
  
  func notifyOnViewDidDisappear(
    sender: UIViewController,
    isAnimated: Bool
  );
  
  func notifyOnViewWillLayoutSubviews(
    sender: UIViewController
  );
  
  func notifyOnViewDidLayoutSubviews(
    sender: UIViewController
  );
};

// MARK: - ViewControllerLifecycleNotifiable+Default
// -------------------------------------------------

public extension ViewControllerLifecycleNotifiable {

  func notifyOnViewDidLoad(sender: UIViewController) {
    // no-op
  };

  func notifyOnViewWillAppear(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    // no-op
  };
  
  func notifyOnViewIsAppearing(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    // no-op
  };
  
  func notifyOnViewDidAppear(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    // no-op
  };
  
  func notifyOnViewWillDisappear(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    // no-op
  };
  
  func notifyOnViewDidDisappear(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    // no-op
  };
  
  func notifyOnViewWillLayoutSubviews(
    sender: UIViewController
  ) {
    // no-op
  };
  
  func notifyOnViewDidLayoutSubviews(
    sender: UIViewController
  ) {
    // no-op
  };
};
