//
//  Collection+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/10/23.
//

import UIKit

extension Collection {
  
  public var secondToLast: Element? {
    self[safeIndex: self.index(self.indices.endIndex, offsetBy: -2)];
  };

  public func isOutOfBounds(forIndex index: Index) -> Bool {
    return index < self.indices.startIndex || index > self.indices.endIndex;
  };
  
  /// Returns the element at the specified index if it is within bounds,
  /// otherwise nil.
  public subscript(safeIndex index: Index) -> Element? {
    return self.isOutOfBounds(forIndex: index) ? nil : self[index];
  };
};

extension MutableCollection {
  subscript(safeIndex index: Index) -> Element? {
    get {
      return self.isOutOfBounds(forIndex: index) ? nil : self[index];
    }
    
    set {
      guard let newValue = newValue,
            !self.isOutOfBounds(forIndex: index)
      else { return };
      
      self[index] = newValue;
    }
  };
};
