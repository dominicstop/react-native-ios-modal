//
//  RNIModalViewController.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

public class RNIModalViewController: UIViewController {
  
  // MARK: - Properties
  // ------------------
  
  weak var modalViewRef: RNIModalView?;
  weak var lifecycleDelegate: RNIViewControllerLifeCycleNotifiable?;
  
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
  
  private(set) public var prevBounds: CGRect?;
  
  private var initialSize: CGSize?;

  // MARK: - Properties - Computed
  // -----------------------------
  
  var modalID: String? {
    self.modalViewRef?.modalID as? String
  };
  
  var modalContentWrapper: RNIWrapperView? {
    self.modalViewRef?.modalContentWrapper;
  };
  
  var computablePreferredContentSize: RNIComputableSize? {
    self.modalViewRef?.synthesizedModalContentPreferredContentSize;
  };
  
  var shouldUpdateContentSize: Bool {
    guard let computableSize = self.computablePreferredContentSize,
          case .current = computableSize.mode
    else { return true };
    
    return false;
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
        + " - modalNativeID: '\(self.modalViewRef?.modalNativeID ?? "N/A")'"
        + " - oldValue: '\(oldValue!.description)'"
        + " - newValue: '\(blurEffectStyle.description)'"
      );
      #endif
      
      self.updateBackgroundBlur();
    }
  };
  
  // MARK: - View Controller Lifecycle
  // ---------------------------------
  
  public override func viewDidLoad() {
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
    
    self.lifecycleDelegate?.viewDidLoad(sender: self);
  };
  
  public override func viewDidLayoutSubviews(){
    super.viewDidLayoutSubviews();
    
    let didChangeBounds: Bool = {
      guard let prevBounds = self.prevBounds else { return true };
      return !prevBounds.equalTo(self.view.bounds);
    }();
    
    guard didChangeBounds,
          let modalContentWrapper = self.modalContentWrapper
    else { return };
 
    let nextBounds = self.view.bounds;
    
    let prevBounds = self.prevBounds;
    self.prevBounds = nextBounds;
        
    #if DEBUG
    print(
        "Log - RNIModalViewController.viewDidLayoutSubviews"
      + " - modalNativeID: '\(self.modalViewRef?.modalNativeID ?? "N/A")'"
      + " - self.prevBounds: \(String(describing: prevBounds))"
      + " - nextBounds: \(nextBounds)"
    );
    #endif
    
    if self.shouldUpdateContentSize {
      modalContentWrapper.notifyForBoundsChange(size: nextBounds.size);
      modalContentWrapper.center = self.view.center;
    };

    self.lifecycleDelegate?.viewDidLayoutSubviews(sender: self);
  };
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    
    self.lifecycleDelegate?
      .viewWillAppear(sender: self, animated: animated);
      
    self.setPreferredContentSize();
      
    #if DEBUG
    print(
      "Log - RNIModalViewController.viewWillAppear"
      + " - arg animated: \(animated)"
      + " - self.modalNativeID: \(self.modalViewRef?.modalNativeID ?? "N/A")"
      + " - self.isBeingPresented: \(self.isBeingPresented)"
    );
    #endif
  };
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated);
    
    self.lifecycleDelegate?
      .viewDidAppear(sender: self, animated: animated);
    
    #if DEBUG
    print(
      "Log - RNIModalViewController.viewDidAppear"
      + " - arg animated: \(animated)"
      + " - self.modalNativeID: \(self.modalViewRef?.modalNativeID ?? "N/A")"
      + " - self.isBeingPresented: \(self.isBeingPresented)"
    );
    #endif
  };
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated);
    
    self.lifecycleDelegate?
      .viewWillDisappear(sender: self, animated: animated);

    #if DEBUG
    print(
        "Log - RNIModalViewController.viewWillDisappear"
      + " - arg animated: \(animated)"
      + " - self.modalNativeID: \(self.modalViewRef?.modalNativeID ?? "N/A")"
      + " - self.isBeingDismissed: \(self.isBeingDismissed)"
      + " - self.transitionCoordinator: \(String(describing: self.transitionCoordinator))"
      + " - self.transitioningDelegate: \(String(describing: self.transitioningDelegate))"
    );
    #endif
  };
  
  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated);
    
    self.lifecycleDelegate?
      .viewDidDisappear(sender: self, animated: animated);
    
    #if DEBUG
    print(
       "Log - RNIModalViewController.viewDidDisappear"
      + " - arg animated: \(animated)"
      + " - self.modalNativeID: \(self.modalViewRef?.modalNativeID ?? "N/A")"
      + " - self.isBeingDismissed: \(self.isBeingDismissed)"
    );
    #endif
  };

  public override func willMove(toParent parent: UIViewController?) {
    super.willMove(toParent: parent);
    
    self.lifecycleDelegate?.willMove(sender: self, toParent: parent);
    
    #if DEBUG
    print(
       "Log - RNIModalViewController.willMove"
      + " - arg parent == nil: \(parent == nil)"
      + " - self.modalNativeID: \(self.modalViewRef?.modalNativeID ?? "N/A")"
      + " - self.isMovingFromParent: \(self.isMovingFromParent)"
      + " - self.isMovingToParent: \(self.isMovingToParent)"
    );
    #endif
  };
  
  public override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent);
    
    self.lifecycleDelegate?.didMove(sender: self, toParent: parent);
    
    #if DEBUG
    print(
       "Log - RNIModalViewController.willMove"
      + " - arg parent == nil: \(parent == nil)"
      + " - self.modalNativeID: \(self.modalViewRef?.modalNativeID ?? "N/A")"
      + " - self.isMovingFromParent: \(self.isMovingFromParent)"
      + " - self.isMovingToParent: \(self.isMovingToParent)"
    );
    #endif
  };
  
  // MARK: - Functions
  // -----------------
  
  func setPreferredContentSize(withWindow window: UIWindow? = nil){
    guard let computableSize = self.computablePreferredContentSize
    else { return };
    
    if self.initialSize == nil || self.initialSize!.isZero {
      self.initialSize = self.view.bounds.size;
    };
    
    let targetSize: CGSize = {
      let viewSize = self.initialSize!;
      let screenSize = window?.bounds.size;
      
      let size = viewSize.isZero ? screenSize : viewSize;
      return size ?? viewSize;
    }();
      
    switch computableSize.mode {
      case .current:
        guard let modalContentWrapper = self.modalContentWrapper
        else { return };
        
        self.preferredContentSize = self.view.systemLayoutSizeFitting(
          modalContentWrapper.bounds.size
        );
        
      default:
        self.preferredContentSize = computableSize.computeWithOffsets(
          withTargetSize: targetSize, currentSize: .zero
        );
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
        "Log - RNIModalViewController.updateBackgroundTransparency"
      + " - modalNativeID: '\(self.modalViewRef?.modalNativeID ?? "N/A")'"
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
      + " - modalNativeID: '\(self.modalViewRef?.modalNativeID ?? "N/A")'"
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
        + " - modalNativeID: '\(self.modalViewRef?.modalNativeID ?? "N/A")'"
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
