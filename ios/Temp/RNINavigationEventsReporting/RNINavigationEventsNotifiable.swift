//
//  RNIContextMenu.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 2/1/22.
//

import UIKit

internal protocol RNINavigationEventsNotifiable: NSObject {
  
  func notifyViewControllerDidPop(sender: RNINavigationEventsReportingViewController);
  
};
