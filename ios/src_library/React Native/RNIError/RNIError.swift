//
//  RNINavigatorError.swift
//  react-native-ios-navigator
//
//  Created by Dominic Go on 9/11/21.
//

import Foundation


internal class RNIBaseError<E: RawRepresentable>: Error where E.RawValue == String  {
  
  internal var code: E;
  internal let domain: String;
  
  internal let message: String?;
  internal let debug: String?;
  
  internal init(
    code: E,
    domain: String,
    message: String? = nil,
    debug: String? = nil
  ) {
    self.code = code;
    self.domain = domain;
    self.message = message;
    self.debug = debug;
  };
  
  internal func createJSONString() -> String? {
    let encoder = JSONEncoder();
    
    guard let data = try? encoder.encode(self),
          let jsonString = String(data: data, encoding: .utf8)
    else { return nil };
    
    return jsonString;
  };
};

// ----------------
// MARK:- Encodable
// ----------------

extension RNIBaseError: Encodable {
  enum CodingKeys: String, CodingKey {
    case code, domain, message, debug;
  };
  
  internal func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self);
        
    try container.encode(self.code.rawValue, forKey: .code);
    try container.encode(self.domain, forKey: .domain);
    try container.encode(self.message, forKey: .message);
    try container.encode(self.debug, forKey: .debug);
  };
};
