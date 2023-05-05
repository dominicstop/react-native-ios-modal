//
//  RNIPresentedViewControllerCache.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 5/1/23.
//

import Foundation

let RNIPresentedVCListCache = RNIPresentedViewControllerCache.shared;

class RNIPresentedViewControllerCache {
  class Cache {
    weak var targetWindow: UIWindow? = nil;
    
    var cacheRequestCount = 0 {
      willSet {
        guard newValue <= 0 else { return };
        self._cache = nil;
      }
    }
    
    // note: this retains the vc instances...
    private var _cache: [UIViewController]?;
    
    var cache: [UIViewController]? {
      get {
        guard self.cacheRequestCount > 0 else { return nil };
        return self._cache;
      }
      set {
        self._cache = newValue;
        self.targetWindow = nil;
      }
    };
  };

  static let shared = RNIPresentedViewControllerCache();
  
  var map: Dictionary<String, Cache> = [:];
  
  func beginCaching(forWindow window: UIWindow?) -> () -> Void {
    guard let window = window else { return {} };
    let windowID = window.synthesizedStringID;
    
    let cache: Cache = {
      if let cache = self.map[windowID] {
        return cache;
      };
      
      let newCache = Cache();
      newCache.targetWindow = window;
      newCache.cache = RNIUtilities.getPresentedViewControllers(for: window);
      
      self.map[windowID] = newCache;
      return newCache;
    }();
    
    cache.cacheRequestCount += 1;
    
    return {
      cache.cacheRequestCount -= 1;
      
      guard cache.cacheRequestCount <= 0 else { return };
      self.map.removeValue(forKey: windowID);
    };
  };
  
  func getPresentedViewControllers(
    forWindow window: UIWindow?
  ) -> [UIViewController] {
    return RNIUtilities.getPresentedViewControllers(for: window);
    guard let windowID = window?.synthesizedStringID,
          let cacheContainer = self.map[windowID],
          let vcItemsCached = cacheContainer.cache
    else {
      return RNIUtilities.getPresentedViewControllers(for: window);
    };
    
    return vcItemsCached;
  };
};
