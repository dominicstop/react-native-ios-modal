//
//  RNINavigatorError.swift
//  react-native-ios-navigator
//
//  Created by Dominic Go on 9/11/21.
//

import Foundation

/// TODO - Move to `react-native-ios-utilities`
/// * Replace older impl. of `RNIError` with this version

public protocol RNIBaseError: Error where ErrorCode == any RNIErrorCode {
  
  associatedtype ErrorCode;
  
  static var domain: String { get };
  
  var code: ErrorCode { get };
  var message: String? { get };
  
  var debugMessage: String? { get };
  var debugData: Dictionary<String, Any>? { get set }
  
  var fileID      : String? { get set };
  var functionName: String? { get set };
  var lineNumber  : Int?    { get set };
  
  init(
    code: ErrorCode,
    message: String?,
    debugMessage: String?
  );
};
