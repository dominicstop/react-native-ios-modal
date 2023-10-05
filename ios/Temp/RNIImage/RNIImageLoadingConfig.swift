//
//  RNIImageCacheAndLoadingConfig.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 9/27/22.
//

import UIKit


internal protocol RNIImageLoadingConfigurable {
  var shouldCache: Bool? { get };
  var shouldLazyLoad: Bool? { get };
};

// TODO: Per file defaults via extension
internal struct RNIImageLoadingConfig: RNIImageLoadingConfigurable {

  internal let shouldCache: Bool?;
  internal let shouldLazyLoad: Bool?;
  
  internal init(dict: NSDictionary) {
    self.shouldCache = dict["shouldCache"] as? Bool;
    self.shouldLazyLoad = dict["shouldLazyLoad"] as? Bool;
  };
};
