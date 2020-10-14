//
//  RCTModalViewController.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

class RCTModalViewController: UIViewController {
  
  var lastViewFrame: CGRect?;
  var boundsDidChangeBlock: ((CGRect) -> Void)?;
  
  var modalID: NSString? = nil;
  weak var modalViewRef: RCTModalView?;
  
  var isBGTransparent: Bool = true {
    didSet {
      guard oldValue != self.isBGTransparent else { return };
      self.setBGTransparent();
      self.setBGBlur();
    }
  };
  
  var isBGBlurred: Bool = true {
    didSet {
      guard oldValue != self.isBGBlurred else { return };
      self.setBGBlur();
    }
  };
  
  var blurEffectView : UIView? = nil;
  var blurEffectStyle: UIBlurEffect.Style? {
    didSet {
      let didChange   = oldValue != blurEffectStyle;
      let isPresented = self.presentingViewController != nil;
    
      guard
        didChange && isPresented,
        let blurEffectStyle = self.blurEffectStyle else { return };
      
      #if DEBUG
      print("RCTModalViewController, didSet blurEffectStyle: \(blurEffectStyle.stringDescription())");
      #endif
      
      self.setBGBlur();
    }
  };
  
  var reactView: UIView? {
    didSet {
      guard let nextView = reactView else { return };
      
      if oldValue?.reactTag != nextView.reactTag {
        self.view.addSubview(nextView);
      };
    }
  };
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    #if DEBUG
    print("RCTModalViewController, viewDidLoad");
    #endif
    
    // setup vc's view
    self.view = {
      let view = UIView();
      view.autoresizingMask = [.flexibleHeight, .flexibleWidth];
      return view;
    }();
    
    self.setBGTransparent();
    self.setBGBlur();
    
    if let boundsDidChangeBlock = self.boundsDidChangeBlock {
      boundsDidChangeBlock(self.view.bounds);
    };
  };
  
  override func viewDidLayoutSubviews(){
    super.viewDidLayoutSubviews();
    
    guard let boundsDidChangeBlock = self.boundsDidChangeBlock else {
      #if DEBUG
      print("RCTModalViewController, viewDidLayoutSubviews: guard check failed");
      #endif
      return;
    };
    
    #if DEBUG
    print("RCTModalViewController, viewDidLayoutSubviews");
    #endif
    
    let didChangeViewFrame: Bool = !(
      lastViewFrame?.equalTo(self.view.frame) ?? false
    );
    
    if didChangeViewFrame {
      boundsDidChangeBlock(self.view.bounds);
      self.lastViewFrame = self.view.frame;
    };
  };
  
  // -----------------------
  // MARK: Private Functions
  // -----------------------
  
  private func setBGTransparent(){
    self.view.backgroundColor = {
      if self.isBGTransparent {
        return .none;
      };
      
      guard #available(iOS 13, *) else { return .white };
      return .systemBackground;
    }();
    
    #if DEBUG
    print(
        "RCTModalViewController, setBGTransparent"
      + " - set backgroundColor: \(self.isBGTransparent)"
    );
    #endif
  };
  
  private func setBGBlur(){
    guard self.isViewLoaded  else { return };
      
    if self.isBGBlurred && self.isBGTransparent {
      // 1) either blur or update the bg
      guard let blurEffectStyle = self.blurEffectStyle else { return };
      
      if let blurEffectView = self.blurEffectView as? UIVisualEffectView {
        // 1A) since blurEffectView has already been init/set, we are just
        // gonna update the existing UIBlurEffect
        blurEffectView.effect = UIBlurEffect(style: blurEffectStyle);
        
        #if DEBUG
        print("RCTModalViewController, setBGBlur: update blurEffectStyle");
        #endif
        
      } else {
        // 1B) we are gonna set the blurEffectStyle so init blurEffectView
        // if it hasn't been set yet
        self.blurEffectView = {
          let blurEffect     = UIBlurEffect(style: blurEffectStyle);
          let blurEffectView = UIVisualEffectView(effect: blurEffect);
          
          blurEffectView.frame = self.view.bounds
          blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
          
          self.view.insertSubview(blurEffectView, at: 0);
          return blurEffectView;
        }();
        
        #if DEBUG
        print("RCTModalViewController, setBGBlur: init. blurEffectView");
        #endif
      };
      
    } else {
      // 2) bg is not transparent or blurred so remove bg blur
      self.removeBlur();
    };
  };
  
  private func removeBlur(){
    self.blurEffectView?.removeFromSuperview();
    self.blurEffectView = nil;
  };
};
