//
//  RNIViewMetadata.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/27/23.
//

import Foundation


public final class RNIViewMetadata: RNIDictionarySynthesizable {

  public let tag: Int;
  
  public let reactTag: NSNumber?;
  public let nativeID: String?;
  
  public let parentView: RNIViewMetadata?;
  public let subviews: [RNIViewMetadata]?;
  
  public required init(
    fromView view: UIView,
    setParentView: Bool = true,
    setSubViews: Bool = true
  ){
    self.tag = view.tag;
    
    self.reactTag = {
      guard let reactTag = view.reactTag else { return nil };
      return reactTag;
    }();
    
    self.nativeID = {
      guard let nativeID = view.nativeID else { return nil };
      return nativeID;
    }();
    
    self.parentView = {
      guard setParentView,
            let parentView = view.superview
      else { return nil };
      
      return Self.init(
        fromView: parentView,
        setParentView: false,
        setSubViews: false
      );
    }();
    
    self.subviews = {
      guard setSubViews else { return nil };
      
      return view.subviews.map {
        return Self.init(
          fromView: $0,
          setParentView: false,
          setSubViews: false
        );
      };
    }();
  };
};
