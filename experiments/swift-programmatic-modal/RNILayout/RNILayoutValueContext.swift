//
//  RNILayoutValueContext.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/9/23.
//

import UIKit

public struct RNILayoutValueContext {
  static let `default`: Self = .init(
    targetRect: .zero,
    windowSize: nil,
    currentSize: nil,
    safeAreaInsets: nil
  );

  let targetRect: CGRect;

  let windowSize: CGSize?;
  let currentSize: CGSize?;
  
  let safeAreaInsets: UIEdgeInsets?;
  
  var targetSize: CGSize {
    self.targetRect.size;
  };
  
  var screenSize: CGSize {
    UIScreen.main.bounds.size;
  };
};

extension RNILayoutValueContext {
  init(
    derivedFrom prev: Self,
    targetRect: CGRect? = nil,
    windowSize: CGSize? = nil,
    currentSize: CGSize? = nil,
    safeAreaInsets: UIEdgeInsets? = nil
  ) {
    
    self.targetRect  = targetRect  ?? prev.targetRect;
  
    self.windowSize  = windowSize  ?? prev.windowSize;
    self.currentSize = currentSize ?? prev.currentSize;
    
    self.safeAreaInsets = safeAreaInsets ?? prev.safeAreaInsets;
  };
  
  init?(
    fromTargetViewController targetVC: UIViewController,
    currentSize: CGSize? = nil
  ) {
    guard let targetView = targetVC.view else { return nil };
  
    self.targetRect = targetView.frame;
    self.windowSize = targetView.window?.bounds.size;
    
    self.safeAreaInsets = targetView.window?.safeAreaInsets;
    
    self.currentSize = currentSize;
  };
  
  init?(
    fromTargetView targetView: UIView,
    currentSize: CGSize? = nil
  ) {
    self.targetRect = targetView.frame;
    self.windowSize = targetView.window?.bounds.size;
    
    self.safeAreaInsets = targetView.window?.safeAreaInsets;
    
    self.currentSize = currentSize;
  };
};
