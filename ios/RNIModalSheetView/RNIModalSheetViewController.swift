//
//  RNIModalSheetViewController.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/26/24.
//

import UIKit
import DGSwiftUtilities
import react_native_ios_utilities

#if !RCT_NEW_ARCH_ENABLED
import React
#endif


open class RNIModalSheetViewController: ModalSheetViewControllerLifecycleNotifier {

  public var shouldTriggerDefaultCleanup = true;
  
  public weak var mainSheetContentParent: RNIContentViewParentDelegate?;
  private(set) public weak var mainSheetContent: RNIWrapperViewContent?;
  
  public var mainSheetContentController: RNIContentViewController?;
  public var bottomOverlayController: RNIModalSheetBottomAttachedOverlayController?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  // TODO: TEMP!
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
    super.viewDidLoad();
  
    self.setupMainContent();
    //self.setupBottomOverlayIfNeeded();
  };
  
  public override func viewIsAppearing(_ animated: Bool) {
    self.setupBottomOverlayIfNeeded();
    super.viewIsAppearing(animated);
    self.setupEntranceAnimation();
  };
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated);
    self.setupExitAnimation();
  }
  
  // MARK: Methods
  // --------------
  
  func setupMainContent(){
    guard let mainSheetContentParent = self.mainSheetContentParent,
          let mainSheetContent = mainSheetContentParent.contentDelegate as? RNIWrapperViewContent
    else {
      return;
    };
    
    self.mainSheetContent = mainSheetContent;
    mainSheetContentParent.reactViewLifecycleDelegates.add(self);
    
    let contentVC = RNIContentViewController();
    contentVC.reactContentParentView = mainSheetContentParent;
    contentVC.contentSizingMode = .sizingFromNative;
    contentVC.contentPositioningMode = .stretch;
    
    self.addChild(contentVC);
    defer {
      contentVC.didMove(toParent: self);
    };
    
    // MARK: Setup Layout
    
    self.view.addSubview(contentVC.view);
    contentVC.view.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      contentVC.view.leadingAnchor.constraint(
        equalTo: self.view.leadingAnchor
      ),
      contentVC.view.trailingAnchor.constraint(
        equalTo: self.view.trailingAnchor
      ),
      contentVC.view.topAnchor.constraint(
        equalTo: self.view.topAnchor
      ),
      contentVC.view.bottomAnchor.constraint(
        equalTo: self.view.bottomAnchor
      ),
    ]);
  };
  
  func setupBottomOverlayIfNeeded(){
    guard let bottomOverlayController = self.bottomOverlayController,
          let targetView = self.closestSheetDropShadowView?.superview
    else {
      return;
    };

    // let the child setup constraints + add itself as it's subview...
    // but, is this okay?
    //
    // wouldn't it be better if the logic for layout be handled in the child
    // vc's `didMove` lifecycle method?
    //
    bottomOverlayController.attachView(
      anchoredToBottomEdgesOf: targetView,
      withSheetContainerView: self.view
    );
    
    targetView.bringSubviewToFront(bottomOverlayController.view);
    
    self.addChild(bottomOverlayController);
    bottomOverlayController.didMove(toParent: parent);
  };
  
  func setupEntranceAnimation(){
    guard let transitionCoordinator = self.transitionCoordinator else {
      return;
    };
    
    
    if let bottomOverlayController = self.bottomOverlayController {
      let animationBlocks = bottomOverlayController.createEntranceAnimationBlocks();
      
      animationBlocks.start();
      transitionCoordinator.animate { context in
        animationBlocks.end();
      };
    };
  };
  
  func setupExitAnimation(){
    guard let transitionCoordinator = self.transitionCoordinator else {
      return;
    };
    
    if let bottomOverlayController = self.bottomOverlayController {
      let animationBlocks = bottomOverlayController.createExitAnimationBlocks();
      
      animationBlocks.start();
      transitionCoordinator.animate { context in
        animationBlocks.end();
      };
    };
  };
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
