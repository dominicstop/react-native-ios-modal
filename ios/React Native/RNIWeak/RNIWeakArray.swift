//
//  RNIWeakArray.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/15/23.
//

import UIKit


public class RNIWeakArray<T> {
  
  public var rawArray: [RNIWeakRef<T>] = [];
  
  public var purgedArray: [RNIWeakRef<T>] {
    self.rawArray.compactMap {
      $0.synthesizedRef == nil ? nil : $0;
    };
  };
  
  public var array: [T] {
    let purgedArray = self.purgedArray;
    self.rawArray = purgedArray;
    
    return purgedArray.compactMap {
      $0.synthesizedRef;
    };
  };
  
  public init(initialItems: [T] = []){
    self.rawArray = initialItems.compactMap {
      RNIWeakRef(with: $0)
    };
  };
  
  public func get(index: Int) -> T? {
    guard self.rawArray.count < index else {
      return nil
    };
    
    guard let ref = self.rawArray[index].synthesizedRef else {
      self.rawArray.remove(at: index);
      return nil;
    };
    
    return ref;
  };
  
  public func set(index: Int, element: T) {
    guard self.rawArray.count < index else {
      return;
    };
    
    self.rawArray[index] = RNIWeakRef(with: element);
  };

  
  public func append(element: T){
    self.rawArray.append(
      RNIWeakRef(with: element)
    );
  };
};

