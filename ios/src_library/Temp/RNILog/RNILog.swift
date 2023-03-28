//
//  RCTLog.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/27/20.
//

import Foundation

public class RNILog {
  public static func error(_ message: String, _ file: String=#file, _ line: UInt=#line) {
    _RNILog.error(message, file: file, line: line);
  };

  public static func warn(_ message: String, _ file: String=#file, _ line: UInt=#line) {
    _RNILog.warn(message, file: file, line: line);
  };

  public static func info(_ message: String, _ file: String=#file, _ line: UInt=#line) {
    _RNILog.info(message, file: file, line: line);
  };

  public static func log(_ message: String, _ file: String=#file, _ line: UInt=#line) {
    _RNILog.log(message, file: file, line: line);
  };

  public static func trace(_ message: String, _ file: String=#file, _ line: UInt=#line) {
    _RNILog.trace(message, file: file, line: line);
  };
};


