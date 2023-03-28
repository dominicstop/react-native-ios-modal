//
//  RNIImageCacheAndLoadingConfig.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 9/27/22.
//

import Foundation


public protocol RNIImageLoadingConfigurable {
  var shouldCache: Bool? { get };
  var shouldLazyLoad: Bool? { get };
};

// TODO: Per file defaults via extension
public struct RNIImageLoadingConfig: RNIImageLoadingConfigurable {

  public let shouldCache: Bool?;
  public let shouldLazyLoad: Bool?;
  
  public init(dict: NSDictionary) {
    self.shouldCache = dict["shouldCache"] as? Bool;
    self.shouldLazyLoad = dict["shouldLazyLoad"] as? Bool;
  };
};
