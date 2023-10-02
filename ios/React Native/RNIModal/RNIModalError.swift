//
//  RNIModalError.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 5/10/23.
//

import UIKit

public enum RNIModalErrorCode: String, RNIErrorCode {
  case modalAlreadyVisible,
       modalAlreadyHidden,
       dismissRejected;
};

public struct RNIModalError: RNIError {

  public typealias ErrorCode = RNIModalErrorCode;

  public static var domain = "react-native-ios-modal";
  
  public var code: RNIModalErrorCode;
  public var message: String?;
  
  public var debugMessage: String?;
  public var debugData: Dictionary<String, Any>?;
  
  public var fileID: String?;
  public var functionName: String?;
  public var lineNumber: Int?;
  
  public init(
    code: ErrorCode,
    message: String?,
    debugMessage: String?
  ) {
    self.code = code;
    self.message = message;
    self.debugMessage = debugMessage;
  };
};
