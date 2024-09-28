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

public extension UniqueIdentifierSynthesizing {
  
  var rawMemoryAddressAsString: String {
    String(describing: Unmanaged.passUnretained(self).toOpaque());
  };
};

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

fileprivate let atomicCounter: AtomicCounter = .init();

fileprivate enum PropertyKeys: String {
  case synthesizedIntID;
  case synthesizedUUID;
};

extension UniqueIdentifierSynthesizing where Self: ValueInjectable {
  
  public var synthesizedIntID: UInt64 {
    self.getInjectedValue(forKey: PropertyKeys.synthesizedIntID) {
      atomicCounter.incrementAndGet();
    };
  };
  
  public var synthesizedUUID: UUID {
    self.getInjectedValue(forKey: PropertyKeys.synthesizedUUID) {
      .init();
    };
  };
};
