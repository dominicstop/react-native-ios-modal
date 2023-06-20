//
//  RNILayoutKeyboardValues.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/21/23.
//

import UIKit

struct RNILayoutKeyboardValues {
  var frameBegin: CGRect;
  var frameEnd: CGRect;
  
  var animationDuration: CGFloat;
  var animationCurve: UIView.AnimationCurve;
  
  func computeKeyboardSize(relativeToView targetView: UIView) -> CGSize? {
    guard let window = targetView.window else { return nil };
    
    // Get keyboard height.
    let keyboardFrameInView = targetView.convert(
      self.frameEnd,
      from: window
    );
    
    let intersection = targetView.bounds.intersection(keyboardFrameInView);
    
    guard !intersection.isNull else { return nil };
    return intersection.size;
  };
};

extension RNILayoutKeyboardValues {
  init?(fromNotification notification: NSNotification) {
    guard let userInfo = notification.userInfo else { return nil };
    
    func extract<T>(key: String) throws -> T {
      guard let rawValue = userInfo[key],
            let value = rawValue as? T
      else { throw NSError() };
      
      return value;
    };
    
    func extractValue<T>(
      userInfoKey: String,
      valueKey: KeyPath<NSValue, T>
    ) throws -> T {
    
      guard let rawValue: NSValue = try? extract(key: userInfoKey)
      else { throw NSError() };
      
      return rawValue[keyPath: valueKey];
    };
    
    do {
      self.frameBegin = try extractValue(
        userInfoKey: UIResponder.keyboardFrameBeginUserInfoKey,
        valueKey: \.cgRectValue
      );
      
      self.frameEnd = try extractValue(
        userInfoKey: UIResponder.keyboardFrameEndUserInfoKey,
        valueKey: \.cgRectValue
      );
      
      self.animationDuration = try extract(
        key: UIResponder.keyboardAnimationDurationUserInfoKey
      );
      
      self.animationCurve = try {
        let curveValue: Int = try extract(
          key: UIResponder.keyboardAnimationCurveUserInfoKey
        );
      
        guard let curve = UIView.AnimationCurve(rawValue: curveValue) else {
          throw NSError();
        };
        
        return curve;
      }();
    
    } catch {
      return nil;
    };
  };
};
