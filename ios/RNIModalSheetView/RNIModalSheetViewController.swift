//
//  RNIModalSheetViewController.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/26/24.
//

import UIKit
import react_native_ios_utilities

#if !RCT_NEW_ARCH_ENABLED
import React
#endif


open class RNIModalSheetViewController: UIViewController {

  public var shouldTriggerDefaultCleanup = true;
  
  public weak var mainSheetContentParent: RNIContentViewParentDelegate?;
  private(set) public weak var mainSheetContent: RNIWrapperViewContent?;
  
  public var positionConfigForMainSheetContent: AlignmentPositionConfig = .default;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var baseEventObject: [String: Any] {
    var eventDict: [String: Any] = [:];
    
    eventDict["modalViewControllerMetrics"] =
      self.modalMetrics.synthesizedDictionaryJSON;
    
    if let presentationControllerMetrics = self.presentationControllerMetrics {
      eventDict["presentationControllerMetrics"] =
        presentationControllerMetrics.synthesizedDictionaryJSON;
    };
    
    return eventDict;
  };
  
  // MARK: - View Controller Lifecycle
  // ---------------------------------

  public override func viewDidLoad() {
  
    guard let mainSheetContentParent = self.mainSheetContentParent,
          let mainSheetContent = mainSheetContentParent.contentDelegate as? RNIWrapperViewContent
    else {
      return;
    };
    
    self.mainSheetContent = mainSheetContent;
    mainSheetContentParent.reactViewLifecycleDelegates.add(self);
    
    // MARK: Setup Constraints
    #if !RCT_NEW_ARCH_ENABLED
    rootReactView.removeAllAncestorConstraints();
    #endif
    
    self.view.addSubview(mainSheetContentParent);
    mainSheetContentParent.translatesAutoresizingMaskIntoConstraints = false;
        
    let constraints = self.positionConfigForMainSheetContent.createConstraints(
      forView: mainSheetContentParent,
      attachingTo: self.view,
      enclosingView: self.view
    );
    
    NSLayoutConstraint.activate(constraints);
    
    // MARK: Set Initial Size
    let hasValidSize = !self.view.bounds.size.isZero;
    if hasValidSize {
      self.positionConfigForMainSheetContent.setIntrinsicContentSizeOverrideIfNeeded(
        forRootReactView: mainSheetContentParent,
        withSize: self.view.bounds.size
      );
    };
    
    let shouldSetSize =
         hasValidSize
      && self.positionConfigForMainSheetContent.isStretchingOnBothAxis;
      
    if shouldSetSize {
      self.positionConfigForMainSheetContent.applySize(
        toRootReactView: mainSheetContentParent,
        attachingTo: self.view
      );
    };
  };

  public override func viewDidLayoutSubviews() {
    guard let mainSheetContentParent = self.mainSheetContentParent else {
      return;
    };
    
    self.positionConfigForMainSheetContent.setIntrinsicContentSizeOverrideIfNeeded(
      forRootReactView: mainSheetContentParent,
      withSize: self.view.bounds.size
    );
    
    self.positionConfigForMainSheetContent.applySize(
      toRootReactView: mainSheetContentParent,
      attachingTo: self.view
    );
  };
  
  // MARK: Methods
  // --------------
};

extension RNIModalSheetViewController: RNIViewLifecycle {
  
  public func notifyOnRequestForCleanup(sender: RNIContentViewParentDelegate) {
    guard let mainSheetContentParent = self.mainSheetContentParent else {
      return;
    };
    
    mainSheetContentParent.detachReactTouchHandler();
    self.mainSheetContentParent?.removeFromSuperview();
    
    guard self.shouldTriggerDefaultCleanup,
          self.view.window != nil
    else {
      return;
    };
    
    if self.presentingViewController != nil {
      self.dismiss(animated: false);
      
    } else if self.parent != nil {
      self.willMove(toParent: nil);
      self.view.removeFromSuperview();
      self.removeFromParent();
      
    } else {
      self.view.removeFromSuperview();
    };
  };
};
