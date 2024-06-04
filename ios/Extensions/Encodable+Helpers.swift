//
//  Encodable+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 5/2/23.
//

import UIKit


public extension Encodable {

  var asJsonData: Data? {
    let encoder = JSONEncoder();
    encoder.outputFormatting = .prettyPrinted;
    encoder.dateEncodingStrategy = .iso8601;
    
    return try? encoder.encode(self);
  };
  
  var asDictionary : [String: Any]? {
    guard let jsonData = self.asJsonData,
          let json = try? JSONSerialization.jsonObject(
            with: jsonData,
            options: []
          )
    else { return nil };
    
    return json as? [String: Any];
  };
};
