//
//  RNIJSComponentWillUnmountNotifiable.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 9/25/22.
//

import Foundation


///
/// When a class implements this protocol, it means that it receives a notification from JS-side whenever
/// the component's `componentWillUnmount` lifecycle is triggered.
internal protocol RNIJSComponentWillUnmountNotifiable {
  
  func notifyOnJSComponentWillUnmount();
  
};
