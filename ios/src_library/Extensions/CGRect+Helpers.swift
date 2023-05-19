//
//  CGSize+Helpers.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/19/23.
//

import Foundation

extension CGRect {
    mutating func setPoint(
    minX: CGFloat? = nil,
    minY: CGFloat? = nil
  ){
    self.origin = CGPoint(
      x: minX ?? self.minX,
      y: minY ?? self.minY
    );
  };
  
  mutating func setPoint(
    midX: CGFloat? = nil,
    midY: CGFloat? = nil
  ){
    let newX: CGFloat = {
      guard let midX = midX else { return self.minX };
      return midX - (self.width / 2);
    }();
    
    let newY: CGFloat = {
      guard let midY = midY else { return self.minY };
      return midY - (self.height / 2);
    }();
    
    self.origin = CGPoint(x: newX, y: newY);
  };
  
  mutating func setPoint(
    maxX: CGFloat? = nil,
    maxY: CGFloat? = nil
  ){
    let newX: CGFloat = {
      guard let maxX = maxX else { return self.minX };
      return maxX - self.width;
    }();
    
    let newY: CGFloat = {
      guard let maxY = maxY else { return self.minY };
      return maxY - self.height;
    }();
    
    self.origin = CGPoint(x: newX, y: newY);
  };
};
