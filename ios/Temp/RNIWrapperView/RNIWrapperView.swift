//
//  RNIWrapperView.swift
//  IosNavigatorExample
//
//  Created by Dominic Go on 2/1/21.
//

import UIKit
import React

/// Holds react views that have been detached, and are no longer managed by RN.
internal class RNIWrapperView: UIView {
  
  internal static var detachedViews = NSMapTable<NSNumber, RNIWrapperView>.init(
    keyOptions: .copyIn,
    valueOptions: .weakMemory
  );
  
  // MARK: - Properties
  // ------------------
  
  internal private(set) var bridge: RCTBridge!;
  
  internal weak var delegate: RNIWrapperViewEventsNotifiable?;
  
  /// When `shouldAutoDetachSubviews` is enabled, all the child views that were removed from
  /// its parent  will be stored here.
  ///
  /// This is only usually used when `isDummyView` is enabled.
  internal var reactViews: [UIView] = [];
  
  internal var touchHandlers: Dictionary<NSNumber, RCTTouchHandler> = [:];
  
  // MARK: - Properties - Flags
  // --------------------------
  
  /// Whether or not `cleanup` was triggered.
  internal private(set) var didTriggerCleanup = false;
  
  /// Set this property to `true` before moving this view somewhere else (i.e.
  /// before calling `removeFromSuperView`).
  ///
  /// Setting this property to `true` will prevent triggering `cleanup` when removing this view
  /// from it's  parent view...
  ///
  /// After you've finished moving this view, set this back to `false`.
  internal var isMovingToParent = false;
  
  internal var shouldDelayAutoCleanupOnJSUnmount = true;
  
  // MARK: - RN Exported Props - Config - Lifecycle Related
  // ------------------------------------------------------
  
  /// When this prop is set to `true`, the JS component will trigger
  /// `shouldNotifyComponentWillUnmount` during `componentWillUnmount`.
  @objc internal private(set) var shouldNotifyComponentWillUnmount: Bool = false;
    
  /// This property determines whether `cleanup` should be called when
  /// `shouldNotifyComponentWillUnmount` is called. Defaults to: `true`.
  ///
  /// When `shouldNotifyComponentWillUnmount` prop is true, the JS component
  /// will notify it's corresponding native view that it'll be unmounted (i.e.
  /// via calling the `shouldNotifyComponentWillUnmount` method).
  ///
  /// * When a react view is "detached" (i.e. when `removeFromSuperView` is called),
  ///   the react view is on it's own (the view will leak since it won't be removed
  ///   when the corresponding view comp. un-mounts).
  ///
  /// * To get around this, the js comp. notifies the native view that it's
  ///   going to be unmount in `componentWillUnmount` react lifecycle.
  ///
  /// * This also fixes the issue where the js comp. has already been unmounted,
  ///   but it's corresponding native view is still being used.
  ///
  @objc internal private(set) var shouldAutoCleanupOnJSUnmount = false;
      
  /// Determines whether `cleanup` is called when this view is removed from the
  /// view hierarchy (i.e. when the window ref. becomes nil).
  @objc internal private(set) var shouldAutoCleanupOnWindowNil = false;
  
  /// Determines whether `layoutSubviews` will automatically trigger
  /// `notifyForBoundsChange`. Defaults to `true`.
  ///
  /// * If the layout size is determined from the react/js side, set this to `false`.
  ///
  /// * Otherwise if the layout size is determined from the native side (e.g. via
  ///   the view controller, etc.) then set this to `true`.
  @objc internal private(set) var shouldAutoSetSizeOnLayout = false;
  
  // MARK: - RN Exported Props - Config - "Dummy View"-Related
  // ---------------------------------------------------------
  
  /// When set to `true`, the view itself is not the one that's being used for content, as such its a
  /// "dummy" view (i.e. its not going to be displayed or used).
  ///
  /// In this mode, it's child views are the ones that are being used for content, and the parent view will
  /// usually get removed from the view hierarchy.
  @objc internal private(set) var isDummyView = false;
  
  /// When enabled, the child views will be automatically removed from it's parent, and will be stored in
  /// the `reactViews` property.
  ///
  /// This is usually enabled together with `isDummyView`.
  @objc internal private(set) var shouldAutoDetachSubviews = false;
  
  // MARK: - RN Exported Props - Config - Touch Handlers
  // ---------------------------------------------------
  
  /// If you are planning on removing the parent view (i.e. this view instance) from the view hierarchy via
  /// calling `removeFromSuperview`, and you still want it to receive touch events , then set this
  /// property to `true`.
  ///
  /// When in dummy mode, `shouldAutoDetachSubviews` is usually also enabled.
  @objc internal private(set) var shouldCreateTouchHandlerForParentView = false;
  
  /// If you are planning on removing the subviews from the view hierarchy (i.e. using "dummy view" mode),
  /// and you still want them to receive touch event, then set this property to `true`.
  @objc internal private(set) var shouldCreateTouchHandlerForSubviews = false;
  
  
  // MARK: - Init/Lifecycle
  // ---------------------
  
  init(bridge: RCTBridge) {
    super.init(frame: CGRect());
    self.bridge = bridge;
    
    if self.shouldCreateTouchHandlerForParentView {
      self.touchHandlers[self.reactTag] = {
        let handler = RCTTouchHandler(bridge: self.bridge)!;
        handler.attach(to: self);
        
        return handler;
      }();
    };
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
  
  internal override func layoutSubviews() {
    super.layoutSubviews();
    
    if self.shouldAutoSetSizeOnLayout {
      self.notifyForBoundsChange(size: self.bounds.size);
    };
  };
  
  internal override func didMoveToWindow() {
    
    let isMovingToWindowNil = self.window == nil;
    
    let isOrphaned = self.isDummyView
      ? self.reactViews.allSatisfy { $0.superview == nil }
      : self.superview == nil;
        
    /// A: Prevent `cleanup` when changing parent views
    /// B: Only trigger cleanup when moving to a `nil` window
    let shouldTriggerCleanup =
      !self.isMovingToParent && isMovingToWindowNil && isOrphaned;
    
    if shouldTriggerCleanup {
      self.cleanup();
    };
  };
  
  internal override func removeFromSuperview() {
    super.removeFromSuperview();
    Self.detachedViews.setObject(self, forKey: self.reactTag);
  }
  
  // MARK: - React Lifecycle
  // ----------------------
  
  internal override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertSubview(subview, at: atIndex);
    
    if self.shouldAutoDetachSubviews {
      self.reactViews.append(subview);
      subview.removeFromSuperview();
    };
        
    if self.shouldCreateTouchHandlerForSubviews {
      self.touchHandlers[subview.reactTag] = {
        let handler = RCTTouchHandler(bridge: self.bridge);
        handler?.attach(to: subview);
        
        return handler;
      }();
    };
  };
  
  // MARK: -  Functions
  // ------------------
  
  internal func notifyForBoundsChange(size: CGSize){
    if self.isDummyView {
      self.notifyForBoundsChangeForContent(size: size);
      
    } else {
      self.notifyForBoundsChangeForWrapper(size: size);
    };
  };
  
  internal func notifyForBoundsChangeForWrapper(size: CGSize){
    guard let bridge = self.bridge else { return };
    bridge.uiManager.setSize(size, for: self);
  };
  
  internal func notifyForBoundsChangeForContent(size: CGSize){
    guard let bridge = self.bridge
    else { return };
    
    let views = self.isDummyView
      ? self.reactViews
      : self.subviews;
    
    for view in views {
      bridge.uiManager.setSize(size, for: view);
    };
  };
  
  // MARK: - Commands For Module
  // --------------------------
  
  /// Called by `RNIWrapperViewModule.notifyComponentWillUnmount`
  internal func onJSComponentWillUnmount(isManuallyTriggered: Bool){
    self.delegate?.onJSComponentWillUnmount(
      sender: self,
      isManuallyTriggered: isManuallyTriggered
    );
    
    guard self.shouldAutoCleanupOnJSUnmount else { return };
    
    if self.shouldDelayAutoCleanupOnJSUnmount {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
        self?.cleanup();
      };
      
    } else {
      self.cleanup();
    };
  };
};


// MARK: - RNICleanable
// --------------------

extension RNIWrapperView: RNICleanable {
  
  internal func cleanup(){
    guard !self.didTriggerCleanup else { return };
    self.didTriggerCleanup = true;
    
    let viewsToCleanup = self.reactViews + [self];
 
    for view in viewsToCleanup  {
      if let touchHandler = self.touchHandlers[view.reactTag] {
        touchHandler.detach(from: view);
      };
      
      RNIUtilities.recursivelyRemoveFromViewRegistry(
        bridge: self.bridge,
        reactView: view
      );
    };
    
    self.touchHandlers.removeAll();
    self.reactViews.removeAll();
  };
};
