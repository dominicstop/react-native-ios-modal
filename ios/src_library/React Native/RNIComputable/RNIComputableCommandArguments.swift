//
//  RNIComputableCommandArguments.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/27/23.
//

import Foundation

public class RNIComputableCommandArguments {
  public struct GetView: RNIDictionarySynthesizable {
  
    public let tag: Int?;
    public let reactTag: NSNumber?;
    public let nativeID: String?;
    
    public init(fromDict dict: NSDictionary) {
      self.tag = {
        guard let tag = dict["tag"] as? NSNumber else { return nil };
        return tag.intValue;
      }();
      
      self.reactTag = dict["reactTag"] as? NSNumber;
      self.nativeID = dict["nativeID"] as? String;
    }
  };
};
