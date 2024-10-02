//
//  RNIModalSheetDecorationController.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/3/24.
//

import UIKit
import DGSwiftUtilities
import react_native_ios_utilities

#if !RCT_NEW_ARCH_ENABLED
import React
#endif

/// Holds/wraps a `RNIBaseView` instance (i.e. `RNIContentViewParentDelegate`)
///
open class RNIModalSheetDecorationController: UIViewController {

  public var shouldTriggerDefaultCleanup = true;
  
  public weak var rootReactView: RNIContentViewParentDelegate?;
  
  public var positionConfig: AlignmentPositionConfig = .default;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var contentView: RNIContentViewDelegate? {
    self.rootReactView?.contentDelegate;
  };
  
  // MARK: - View Controller Lifecycle
  // ---------------------------------

  public override func viewDidLoad() {
    guard let rootReactView = self.rootReactView else {
      return;
    };
    
    #if DEBUG && false
    self.log();
    #endif

    // MARK: Setup Constraints
    #if !RCT_NEW_ARCH_ENABLED
    rootReactView.removeAllAncestorConstraints();
    #endif
    
    rootReactView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(rootReactView);
    
    NSLayoutConstraint.activate([
      rootReactView.leadingAnchor.constraint(
        equalTo: rootReactView.leadingAnchor
      ),
      rootReactView.trailingAnchor.constraint(
        equalTo: rootReactView.leadingAnchor
      ),
      rootReactView.bottomAnchor.constraint(
        equalTo: rootReactView.bottomAnchor
      ),
      rootReactView.topAnchor.constraint(
        equalTo: rootReactView.topAnchor
      ),
    ]);
  };

  public override func viewDidLayoutSubviews() {
    guard let rootReactView = self.rootReactView else {
      return;
    };
    
    #if DEBUG && false
    self.log();
    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
      self.log();
    };
    #endif
  };
  
  open override func didMove(toParent parent: UIViewController?) {
    guard let parent = parent else {
      return;
    };
    
    let constraints = self.positionConfig.createConstraints(
      forView: self.view,
      attachingTo: parent.view,
      enclosingView: parent.view
    );
    
    self.view.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint.activate([
      self.view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor),
      self.view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor),
      self.view.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor),
      self.view.heightAnchor.constraint(equalToConstant: 100),
    ]);
  }
  
  // MARK: Methods
  // --------------
  
  #if DEBUG
  func log(funcString: String = #function){
    print(
      "RNIModalSheetDecorationController.\(funcString)",
      "\n - positionConfig:", self.positionConfig,
      
      "\n - window.size:",
        self.view.window?.bounds.size.debugDescription ?? "N/A",
        
      "\n - view.size:", self.view.bounds.size,
      
      "\n - view.globalFrame:",
        self.view.globalFrame?.debugDescription ?? "N/A",
        
      "\n - view.layer.frame:",
        self.view.layer.presentation()?.frame.debugDescription ?? "N/A",
        
      "\n - superview.size:",
        self.view.superview?.bounds.size.debugDescription ?? "N/A",
      
      "\n - superview.globalFrame:",
        self.view.superview?.globalFrame?.debugDescription ?? "N/A",
        
      "\n - rootReactView.size:",
        self.rootReactView?.bounds.size.debugDescription ?? "N/A",
        
      "\n - rootReactView.cachedLayoutMetrics.contentFrame:",
        self.rootReactView?.cachedLayoutMetrics?.contentFrame.debugDescription ?? "N/A",
        
      "\n - rootReactView.globalFrame:",
        self.rootReactView?.globalFrame?.debugDescription ?? "N/A",
        
      "\n - rootReactView.layer.frame:",
        self.rootReactView?.layer.presentation()?.frame.debugDescription ?? "N/A",
        
      "\n - rootReactView.intrinsicContentSize:",
        self.rootReactView?.intrinsicContentSize.debugDescription ?? "N/A",
        
      "\n - contentDelegate.bounds.size:",
        self.rootReactView?.contentDelegate.bounds.size.debugDescription ?? "N/A",
        
      "\n - contentDelegate.globalFrame:",
        self.rootReactView?.contentDelegate.globalFrame?.debugDescription ?? "N/A",
        
      "\n - contentDelegate.layer.frame:",
        self.rootReactView?.contentDelegate.layer.presentation()?.frame.debugDescription ?? "N/A",
        
      "\n"
    );
  };
  #endif
};

extension RNIModalSheetDecorationController: RNIViewLifecycle {
  
  public func notifyOnRequestForCleanup(sender: RNIContentViewParentDelegate) {
    guard self.shouldTriggerDefaultCleanup,
          self.view.window != nil
    else {
      return;
    };
    
    if self.presentingViewController != nil {
      self.dismiss(animated: true);
      
    } else if self.parent != nil {
      self.willMove(toParent: nil);
      self.view.removeFromSuperview();
      self.removeFromParent();
      
    } else {
      self.view.removeFromSuperview();
    };
  };
};
