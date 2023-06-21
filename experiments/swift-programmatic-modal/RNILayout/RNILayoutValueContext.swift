//
//  RNILayoutValueContext.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/9/23.
//

import UIKit

public struct RNILayoutValueContext {

  public static let `default`: Self = .init(
    targetRect: .zero,
    windowSize: nil,
    currentSize: nil,
    safeAreaInsets: nil,
    keyboardScreenRect: nil,
    keyboardRelativeSize: nil
  );

  public let targetRect: CGRect;

  public let windowSize: CGSize?;
  public let currentSize: CGSize?;
  
  public let safeAreaInsets: UIEdgeInsets?;
  
  public let keyboardScreenRect: CGRect?;
  public let keyboardRelativeSize: CGSize?;
  
  public var targetSize: CGSize {
    self.targetRect.size;
  };
  
  public var screenSize: CGSize {
    UIScreen.main.bounds.size;
  };
};

// MARK: - Init
// ------------

public extension RNILayoutValueContext {

  init(
    derivedFrom prev: Self,
    targetView: UIView? = nil,
    targetRect: CGRect? = nil,
    windowSize: CGSize? = nil,
    currentSize: CGSize? = nil,
    safeAreaInsets: UIEdgeInsets? = nil,
    keyboardValues: RNILayoutKeyboardValues? = nil
  ) {
    
    self.targetRect  = targetRect  ?? prev.targetRect;
    self.windowSize  = windowSize  ?? prev.windowSize;
    self.currentSize = currentSize ?? prev.currentSize;
    
    self.safeAreaInsets = safeAreaInsets ?? prev.safeAreaInsets;
    self.keyboardScreenRect = keyboardValues?.frameEnd ?? prev.keyboardScreenRect;
    
    self.keyboardRelativeSize = {
      guard let targetView = targetView,
            let keyboardValues = keyboardValues
      else {
        return prev.keyboardRelativeSize;
      };
      
      let keyboardSize = keyboardValues.computeKeyboardSize(
        relativeToView: targetView
      );
      
      return keyboardSize ?? prev.keyboardRelativeSize;
    }();
  };
  
  init?(
    fromTargetViewController targetVC: UIViewController,
    keyboardValues: RNILayoutKeyboardValues? = nil,
    currentSize: CGSize? = nil
  ) {
    guard let targetView = targetVC.view else { return nil };
  
    self.targetRect = targetView.frame;
    self.windowSize = targetView.window?.bounds.size;
    
    self.safeAreaInsets = targetView.window?.safeAreaInsets;
    self.currentSize = currentSize;
    
    self.keyboardScreenRect = keyboardValues?.frameEnd;
    
    self.keyboardRelativeSize =
      keyboardValues?.computeKeyboardSize(relativeToView: targetView);
  };
  
  init?(
    fromTargetView targetView: UIView,
    keyboardValues: RNILayoutKeyboardValues? = nil,
    currentSize: CGSize? = nil
  ) {
    self.targetRect = targetView.frame;
    self.windowSize = targetView.window?.bounds.size;
    
    self.safeAreaInsets = targetView.window?.safeAreaInsets;
    self.currentSize = currentSize;
    
    self.keyboardScreenRect = keyboardValues?.frameEnd;
    
    self.keyboardRelativeSize =
      keyboardValues?.computeKeyboardSize(relativeToView: targetView);
  };
};
