//
//  RNIModalViewController.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

class RNIModalViewController: UIViewController {
  
  // MARK: - Properties
  // ------------------
  
  var prevViewFrame: CGRect?;
  var boundsDidChangeBlock: ((CGRect) -> Void)?;
  
  weak var modalViewRef: RNIModalView?;
  
  var isBGTransparent: Bool = true {
    didSet {
      guard oldValue != self.isBGTransparent else { return };
      self.updateBackgroundTransparency();
      self.updateBackgroundBlur();
    }
  };
  
  var isBGBlurred: Bool = true {
    didSet {
      guard oldValue != self.isBGBlurred else { return };
      self.updateBackgroundBlur();
    }
  };
  
  // MARK: - Properties - Computed
  // -----------------------------
  
  var modalID: String? {
    self.modalViewRef?.modalID as? String
  };
  
  // MARK: - Properties - Views
  // --------------------------
  
  var blurEffectView: UIVisualEffectView? = nil;

  var blurEffectStyle: UIBlurEffect.Style? {
    didSet {
      let didChange = oldValue != blurEffectStyle;
      let isPresented = self.presentingViewController != nil;
    
      guard didChange && isPresented,
            let blurEffectStyle = self.blurEffectStyle else { return };
      
      #if DEBUG
      print("RNIModalViewController, didSet blurEffectStyle: \(blurEffectStyle.stringDescription())");
      #endif
      
      self.updateBackgroundBlur();
    }
  };
  
  var reactView: UIView? {
    didSet {
      
      let didChange =
        oldValue?.reactTag != self.reactView?.reactTag;
      
      let shouldRemoveOldView =
        oldValue != nil && didChange;
      
      if shouldRemoveOldView,
         let oldView = oldValue {
        
        oldView.removeFromSuperview();
      };
      
      if didChange,
         let newView = self.reactView {
        
        self.view.addSubview(newView);
      };
    }
  };
  
  // MARK: - View Controller Lifecycle
  // ---------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    #if DEBUG
    print("RNIModalViewController - viewDidLoad");
    #endif
    
    // setup vc's view
    self.view = {
      let view = UIView();
      view.autoresizingMask = [.flexibleHeight, .flexibleWidth];
      return view;
    }();
    
    self.updateBackgroundTransparency();
    self.updateBackgroundBlur();
    
    self.boundsDidChangeBlock?(self.view.bounds)
  };
  
  override func viewDidLayoutSubviews(){
    super.viewDidLayoutSubviews();
    
    let didChangeViewFrame: Bool = {
      guard let lastViewFrame = self.prevViewFrame else { return true };
      return !lastViewFrame.equalTo(self.view.frame);
    }();
    
    if didChangeViewFrame,
       let boundsDidChangeBlock = self.boundsDidChangeBlock {
      
      boundsDidChangeBlock(self.view.bounds);
      self.prevViewFrame = self.view.frame;
      
      #if DEBUG
      print("RNIModalViewController - viewDidLayoutSubviews - boundsDidChangeBlock");
      #endif
    };
  };
  
  // MARK: - Private Functions
  // -------------------------
  
  private func updateBackgroundTransparency(){
    self.view.backgroundColor = {
      if self.isBGTransparent {
        return .none;
      };
      
      guard #available(iOS 13, *) else { return .white };
      return .systemBackground;
    }();
    
    #if DEBUG
    print(
        "RNIModalViewController - updateBackgroundTransparency"
      + " - set backgroundColor: \(self.isBGTransparent)"
    );
    #endif
  };
  
  private func initBackgroundBlur(){
    guard let blurEffectStyle = self.blurEffectStyle else { return };
    
    let blurEffect = UIBlurEffect(style: blurEffectStyle);
    
    let blurEffectView = UIVisualEffectView(effect: blurEffect);
    self.blurEffectView = blurEffectView;
    
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
    
    self.view.insertSubview(blurEffectView, at: 0);
    
    #if DEBUG
    print(
        "RNIModalViewController - initBackgroundBlur"
        + " - set blurEffectStyle: \(blurEffect)"
    );
    #endif
  };
  
  private func removeBackgroundBlur(){
    self.blurEffectView?.removeFromSuperview();
    self.blurEffectView = nil;
  };
  
  private func updateBackgroundBlur(){
    guard self.isViewLoaded,
          let blurEffectStyle = self.blurEffectStyle
    else { return };
    
    /// bg is transparent, and blur is enabled
    let shouldUpdateBackgroundBlur =
      self.isBGTransparent && self.isBGBlurred ;
    
    /// bg is not transparent or blurred
    let shouldRemoveBackgroundBlur =
      !self.isBGTransparent || !self.isBGBlurred;
    
    let shouldInitBackgroundBlur =
      self.blurEffectView == nil && shouldUpdateBackgroundBlur;
    
    // 01 - Init background blur first if needed
    if shouldInitBackgroundBlur {
      self.initBackgroundBlur();
    };
    
    if shouldUpdateBackgroundBlur,
       let blurEffectView = self.blurEffectView {
      
      // 02-A - Update background blur
      blurEffectView.effect = UIBlurEffect(style: blurEffectStyle);
      
      #if DEBUG
      print(
          "RNIModalViewController - updateBackgroundBlur"
        + " - Set blur effect: \(blurEffectStyle)"
      );
      #endif

    } else if shouldRemoveBackgroundBlur {
      // 02-B - background is not transparent or blurred so remove
      // background blur
      self.removeBackgroundBlur();
    };
  };
};
