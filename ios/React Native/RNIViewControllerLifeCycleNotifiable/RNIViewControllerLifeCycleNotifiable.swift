//
//  RNIViewControllerLifeCycleNotifiable.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/1/23.
//

import UIKit

public protocol RNIViewControllerLifeCycleNotifiable: AnyObject {
  
  func viewDidLoad(sender: UIViewController);
  
  func viewDidLayoutSubviews(sender: UIViewController);
  
  func viewWillAppear(sender: UIViewController, animated: Bool);
  
  func viewDidAppear(sender: UIViewController, animated: Bool);
  
  /// `Note:2023-04-01-14-39-23`
  ///
  /// * `UIViewController.isBeingDismissed` or
  ///   `UIViewController.isMovingFromParent` are `true` during
  ///   `viewWillDisappear`, whenever a modal is about to be dismissed.
  ///
  func viewWillDisappear(sender: UIViewController, animated: Bool);
  
  func viewDidDisappear(sender: UIViewController, animated: Bool);
  
  func willMove(sender: UIViewController, toParent parent: UIViewController?);
  
  func didMove(sender: UIViewController, toParent parent: UIViewController?);
  
};

