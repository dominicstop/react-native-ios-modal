//
//  Encodable+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import Foundation
import DGSwiftUtilities


public extension Encodable {

  /// Encode into JSON and return `Data`
  func convertToJsonData() throws -> Data {
    let encoder = JSONEncoder();
    encoder.outputFormatting = .prettyPrinted;
    encoder.dateEncodingStrategy = .iso8601;
    
    return try encoder.encode(self);
  };
  
  func convertToJsonDictionary() throws -> [String: Any] {
    let jsonData = try self.convertToJsonData();
    
    let jsonObject = try JSONSerialization.jsonObject(
      with: jsonData,
      options: []
    );
    
    guard let jsonDict = jsonObject as? [String : Any] else {
      throw GenericError(
        errorCode: .typeCastFailed,
        description: "Unable to convert json object to dictionary"
      );
    };
    
    return jsonDict;
  };
};
