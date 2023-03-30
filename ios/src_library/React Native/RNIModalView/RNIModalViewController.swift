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
  
  var prevBounds: CGRect?;
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
  
  var modalContentWrapper: RNIWrapperView? {
    self.modalViewRef?.modalContentWrapper;
  };
  
  // MARK: - Properties
  // ------------------
  
  var blurEffectView: UIVisualEffectView? = nil;

  var blurEffectStyle: UIBlurEffect.Style? {
    didSet {
      let didChange = oldValue != blurEffectStyle;
      let isPresented = self.presentingViewController != nil;
    
      guard didChange && isPresented,
            let blurEffectStyle = self.blurEffectStyle else { return };
      
      #if DEBUG
      print(
        "Log - RNIModalViewController.blurEffectStyle - didSet"
        + " - modalNativeID: '\(self.modalViewRef?.synthesizedStringID ?? "N/A")'"
        + " - oldValue: '\(oldValue!.description)'"
        + " - newValue: '\(blurEffectStyle.description)'"
      );
      #endif
      
      self.updateBackgroundBlur();
    }
  };
  
  // MARK: - View Controller Lifecycle
  // ---------------------------------
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    self.view = {
      let view = UIView();
      view.autoresizingMask = [.flexibleHeight, .flexibleWidth];
      
      return view;
    }();
    
    if let modalContentWrapper = self.modalContentWrapper {
      self.view.addSubview(modalContentWrapper);
      modalContentWrapper.notifyForBoundsChange(size: self.view.bounds.size);
    };
    
    self.updateBackgroundTransparency();
    self.updateBackgroundBlur();
  };
  
  override func viewDidLayoutSubviews(){
    super.viewDidLayoutSubviews();
    
    let didChangeBounds: Bool = {
      guard let prevBounds = self.prevBounds else { return true };
      return !prevBounds.equalTo(self.view.bounds);
    }();
    
    guard didChangeBounds,
          let modalContentWrapper = self.modalContentWrapper
    else { return };
    
    let nextBounds = self.view.bounds;
        
    #if DEBUG
    print(
        "Log - RNIModalViewController.viewDidLayoutSubviews"
      + " - modalNativeID: '\(self.modalViewRef?.synthesizedStringID ?? "N/A")'"
      + " - self.prevBounds: \(String(describing: self.prevBounds))"
      + " - nextBounds: \(nextBounds)"
    );
    #endif
    
    modalContentWrapper.notifyForBoundsChange(size: nextBounds.size);
    self.prevBounds = nextBounds;
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
        "Log - RNIModalViewController.updateBackgroundTransparency"
      + " - modalNativeID: '\(self.modalViewRef?.synthesizedStringID ?? "N/A")'"
      + " - self.isBGTransparent: \(self.isBGTransparent)"
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
        "Log - RNIModalViewController.initBackgroundBlur"
      + " - modalNativeID: '\(self.modalViewRef?.synthesizedStringID ?? "N/A")'"
      + " - self.blurEffectStyle: \(blurEffect)"
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
          "Log - RNIModalViewController.updateBackgroundBlur"
        + " - modalNativeID: '\(self.modalViewRef?.synthesizedStringID ?? "N/A")'"
        + " - blurEffectStyle: \(blurEffectStyle)"
      );
      #endif

    } else if shouldRemoveBackgroundBlur {
      // 02-B - background is not transparent or blurred so remove
      // background blur
      self.removeBackgroundBlur();
    };
  };
};
