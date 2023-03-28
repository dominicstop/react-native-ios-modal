//
//  RNIRemoteURLImageLoadingConfig.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 10/2/22.
//

import Foundation



/// Maps to: `ImageRemoteURLLoadingConfig`
public struct RNIRemoteURLImageLoadingConfig: RNIImageLoadingConfigurable {
  
  // MARK: Embedded Types
  // --------------------
  
  /// Maps to: `ImageRemoteURLFallbackBehavior`
  public enum FallbackBehavior: String {
    case afterFinalAttempt;
    case whileNotLoaded;
    case onLoadError;
  };
  
  // MARK: Properties
  // ----------------
  
  public let shouldCache: Bool?;
  public let shouldLazyLoad: Bool?;
  
  public let maxRetryAttempts: Int?;
  public let shouldImmediatelyRetryLoading: Bool?;
  public let fallbackBehavior: FallbackBehavior?;
  
  // MARK: Init
  // ----------
  
  public init(dict: NSDictionary) {
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
