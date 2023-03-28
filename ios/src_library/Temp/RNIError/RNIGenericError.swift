//
//  RNIGenericError.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/21/22.
//

import Foundation


internal class RNIGenericError: RNIBaseError<RNIGenericErrorCode> {
  
  init(
    code: RNIGenericErrorCode,
    message: String? = nil,
    debug: String? = nil
  ) {
    super.init(
      code: code,
      domain: "react-native-ios-utilities",
      message: message,
      debug: debug
    );
  };
};
