//
//  RNIRemoteURLImageLoadingConfig.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 10/2/22.
//

import UIKit



/// Maps to: `ImageRemoteURLLoadingConfig`
internal struct RNIRemoteURLImageLoadingConfig: RNIImageLoadingConfigurable {
  
  // MARK: Embedded Types
  // --------------------
  
  /// Maps to: `ImageRemoteURLFallbackBehavior`
  internal enum FallbackBehavior: String {
    case afterFinalAttempt;
    case whileNotLoaded;
    case onLoadError;
  };
  
  // MARK: Properties
  // ----------------
  
  internal let shouldCache: Bool?;
  internal let shouldLazyLoad: Bool?;
  
  internal let maxRetryAttempts: Int?;
  internal let shouldImmediatelyRetryLoading: Bool?;
  internal let fallbackBehavior: FallbackBehavior?;
  
  // MARK: Init
  // ----------
  
  internal init(dict: NSDictionary) {
    self.shouldCache = dict["shouldCache"] as? Bool;
    self.shouldLazyLoad = dict["shouldLazyLoad"] as? Bool;
    
    self.maxRetryAttempts = dict["maxRetryAttempts"] as? Int;
    self.shouldImmediatelyRetryLoading = dict["shouldImmediatelyRetryLoading"] as? Bool;
    
    self.fallbackBehavior = {
      guard let string = dict["fallbackBehavior"] as? String
      else { return nil };
      
      return FallbackBehavior(rawValue: string);
    }();
  };
};
