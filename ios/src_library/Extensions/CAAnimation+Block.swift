//
//  CAAnimation+Block.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 5/1/23.
//

import Foundation


public class CAAnimationBlockDelegate: NSObject, CAAnimationDelegate {

  public typealias StartBlock = (CAAnimation) -> ();
  public typealias EndBlock = (CAAnimation, Bool) -> ();

  var onStartBlock: StartBlock?
  var onEndBlock: EndBlock?

  public func animationDidStart(_ anim: CAAnimation) {
    self.onStartBlock?(anim);
  };

  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    self.onEndBlock?(anim, flag);
  };
};

public extension CAAnimation {
  
  private var multicastDelegate: CAAnimationMulticastDelegate {
    guard let delegate = self.delegate else {
      return CAAnimationMulticastDelegate();
    };
    
    guard let multicastDelegate = delegate as? CAAnimationMulticastDelegate else {
      let multicastDelegate = CAAnimationMulticastDelegate();
      multicastDelegate.emitter.add(delegate);
      
      self.speed = 0;
      
      self.delegate = multicastDelegate;
      return multicastDelegate;
    };
    
    return multicastDelegate;
  };

  func startBlock(_ callback: @escaping CAAnimationBlockDelegate.StartBlock) {
    let blockDelegate = CAAnimationBlockDelegate();
    self.multicastDelegate.emitter.add(blockDelegate);
    
    blockDelegate.onStartBlock = callback;
  };

  func endBlock(_ callback: @escaping CAAnimationBlockDelegate.EndBlock) {
    let blockDelegate = CAAnimationBlockDelegate();
    self.multicastDelegate.emitter.add(blockDelegate);
    
    blockDelegate.onEndBlock = callback;
  };
};
