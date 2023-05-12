//
//  RNIBaseError+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 5/12/23.
//

import Foundation

extension RNIBaseError {

  public var errorMessage: String {
    var message = "message: \(self.message ?? "N/A")";
    
    #if DEBUG
    message += " - debugMessage: \(self.debugMessage ?? "N/A")";
    #endif
    
    if let fileID = self.fileID {
      message += "- fileID: \(fileID)";
    };
    
    if let functionName = self.functionName {
      message += "- functionName: \(functionName)";
    };
    
    if let lineNumber = self.lineNumber {
      message += "- lineNumber: \(lineNumber)";
    };
    
    return message;
  };
  
  public init(
    code: ErrorCode,
    message: String? = nil,
    debugMessage: String? = nil,
    debugData: Dictionary<String, Any>? = nil,
    fileID: String? = #fileID,
    functionName: String? = #function,
    lineNumber: Int? = #line
  ) {
    self.init(
      code: code,
      message: message,
      debugMessage: debugMessage
    );
    
    self.fileID = fileID;
    self.functionName = functionName;
    self.lineNumber = lineNumber;
  };

  public mutating func setDebugValues(
    fileID: String = #fileID,
    functionName: String = #function,
    lineNumber: Int = #line
  ) {
    self.fileID = fileID;
    self.functionName = functionName;
    self.lineNumber = lineNumber;
  };
  
  public mutating func addDebugData(_ nextDebugData: Dictionary<String, Any>){
    guard let prevDebugData = self.debugData else {
      self.debugData = nextDebugData;
      return;
    };
    
    self.debugData = prevDebugData.merging(nextDebugData) { (_, new) in new };
  };
};

extension RNIBaseError where Self: RNIDictionarySynthesizable {

  public var asNSError: NSError? {
    
    let errorCode = self.code.errorCode ??
      RNIGenericErrorCode.unspecified.errorCode;
      
    guard let errorCode = errorCode else { return nil };
    
    return NSError(
      domain: Self.domain,
      code: errorCode,
      userInfo: self.synthesizedJSDictionary
    );
  };
  
  public func invokePromiseRejectBlock(
    _ block: @escaping RCTPromiseRejectBlock
  ) {
    block(
      /* code    */ self.code.description,
      /* message */ self.errorMessage,
      /* error   */ self.asNSError
    );
  };
};
