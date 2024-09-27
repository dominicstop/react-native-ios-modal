//
//  UniqueIdentifierSynthesizing.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import Foundation
import DGSwiftUtilities

public protocol UniqueIdentifierSynthesizing: AnyObject {
  
  var synthesizedIntID: UInt64 { get };
  
  var synthesizedUUID: UUID { get };
};

// MARK: - UniqueIdentifierSynthesizing+Helpers
// --------------------------------------------

public extension UniqueIdentifierSynthesizing where Self: NSObject {

  var synthesizedStringID: String {
    "\(self.classNameTruncated)-\(self.synthesizedIntID)";
  };
  
  var synthesizedLongStringID: String {
    "\(self.classNameTruncated)-\(self.synthesizedUUID)";
  };
  
  var synthesizedVeryLongStringID: String {
    "\(self.classNameTruncated)-\(self.synthesizedIntID)-\(self.synthesizedUUID)";
  };
};


public extension UniqueIdentifierSynthesizing where Self: AnyObject {

  fileprivate var className: String {
    return String(describing: type(of: self));
  };

  fileprivate var classNameTruncated: String {
    let fullClassName = self.className;
    let classNameComponents = fullClassName.components(separatedBy: ".");
    
    guard let className = classNameComponents.last else {
      return fullClassName;
    };
    
    return className;
  };

  var synthesizedStringID: String {
    "\(self.classNameTruncated)-\(self.synthesizedIntID)";
  };
  
  var synthesizedLongStringID: String {
    "\(self.classNameTruncated)-\(self.synthesizedUUID)";
  };
  
  var synthesizedVeryLongStringID: String {
    "\(self.classNameTruncated)-\(self.synthesizedIntID)-\(self.synthesizedUUID)";
  };
};

// MARK: - ObjectUniquelyIdentifiable+Default
// ------------------------------------------

fileprivate enum PropertyKeys: String {
  case atomicCounter;
  case synthesizedIntID;
  case synthesizedUUID;
};

extension UniqueIdentifierSynthesizing where Self: ValueInjectable {
  
  fileprivate var atomicCounter: AtomicCounter {
    self.getInjectedValue(forKey: PropertyKeys.atomicCounter) {
      .init();
    };
  };
  
  public var synthesizedIntID: UInt64 {
    self.getInjectedValue(forKey: PropertyKeys.synthesizedIntID) {
      self.atomicCounter.incrementAndGet();
    };
  };
  
  public var synthesizedUUID: UUID {
    self.getInjectedValue(forKey: PropertyKeys.synthesizedUUID) {
      .init();
    };
  };
};
