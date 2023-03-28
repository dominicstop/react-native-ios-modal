//
//  RNIImageRequireMaker.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 10/4/22.
//

import Foundation


public class RNIImageRequireMaker {
  static private var imageCache: [String: UIImage] = [:];
  
  public let uri: String;
  public let imageLoadingConfig: RNIImageLoadingConfig;
  
  public let rawConfig: NSDictionary;
  
  public lazy var image: UIImage? = {
    let shouldCache = self.imageLoadingConfig._shouldCache;
    
    if shouldCache,
       let cachedImage = Self.imageCache[self.uri] {
      
      // A - Use cached image
      return cachedImage;
    };
    
    // B - No cached image
    let image = RCTConvert.uiImage(self.rawConfig);
    
    if shouldCache {
      Self.imageCache[self.uri] = image;
    };
    
    return image;
  }();
  
  public init?(
    dict: NSDictionary,
    imageLoadingConfig loadingConfigDict: NSDictionary?
  ){
    guard let uriString = dict["uri"] as? String
    else { return nil };
    
    self.uri = uriString;
    self.rawConfig = dict;
    
    self.imageLoadingConfig =
      RNIImageLoadingConfig(dict: loadingConfigDict ?? [:]);
    
    self.preloadImageIfNeeded();
  };
  
  private func preloadImageIfNeeded(){
    guard !self.imageLoadingConfig._shouldLazyLoad
    else { return };
    
    // trigger loading of image
    _ = self.image;
  };
};

// MARK: - RNIImageLoadingConfig - Defaults
// ----------------------------------------

fileprivate extension RNIImageLoadingConfig {
  var _shouldLazyLoad: Bool {
    self.shouldLazyLoad ?? false;
  };
  
  var _shouldCache: Bool {
    self.shouldCache ?? false;
  };
};
