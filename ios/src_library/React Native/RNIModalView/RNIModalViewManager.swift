//
//  RNIModalViewManager.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


@objc (RNIModalViewManager)
class RNIModalViewManager: RCTViewManager {
  static var sharedInstance: RNIModalViewManager!;
  
  override static func requiresMainQueueSetup() -> Bool {
    return true;
  };
  
  /// TODO:2023-03-24-14-25-52 - Remove `RNIModalViewFocusDelegate`-related
  /// logic
  ///
  // TODO: See TODO:2023-03-04-15-49-02 - Refactor:  Relocate 
  //`presentedModalRefs`
  //
  // * a weak ref to the currently presented modals.
  // * currently unused, remove later.
  var presentedModalRefs = NSMapTable<NSString, RNIModalView>.init(
    keyOptions  : .copyIn,
    valueOptions: .weakMemory
  );
  
  // TODO: See `TODO:2023-03-04-15-33-15` - Refactor: Relocate 
  // `delegatesFocus`
  var delegatesFocus = MulticastDelegate<RNIModalViewFocusDelegate>();
  
  // TODO: See TODO:2023-03-04-15-38-02 - Refactor: Relocate 
  // `currentModalLevel`
  private var currentModalLevel = -1;
 
  override func view() -> UIView! {
    let view = RNIModalView(bridge: self.bridge);
    view.delegate = self;
    self.delegatesFocus.add(view);
    
    return view;
  };
  
  override init() {
    super.init();
    RNIModalViewManager.sharedInstance = self;
  };
  
  @objc override func constantsToExport() -> [AnyHashable : Any]! {
    return [
      "availableBlurEffectStyles": UIBlurEffect.Style
        .availableStyles.map { $0.description },
      
      "availablePresentationStyles": UIModalPresentationStyle
        .availableStyles.map { $0.description },
    ];
  };
};

// ---------------------------------
// MARK: RNIModalViewPresentDelegate
// ---------------------------------

/// TODO:2023-03-24-14-25-52 - Remove `RNIModalViewFocusDelegate`-related logic
extension RNIModalViewManager: RNIModalViewPresentDelegate {
  
  func onPresentModalView(modalView: RNIModalView) {
    let modalLevel = modalView.modalLevel;
    let modalNativeID = modalView.modalNativeID!;
    
    self.currentModalLevel = modalLevel;
    self.presentedModalRefs.setObject(modalView, forKey: modalNativeID as NSString);
    
    // notify delegates that a new modal is in focus
    self.delegatesFocus.invoke {
      $0.onModalChangeFocus(
        modalLevel: modalLevel,
        modalNativeID: modalNativeID,
        isInFocus : true
      );
    };
  };
  
  func onDismissModalView(modalView: RNIModalView) {
    let modalLevel = modalView.modalLevelPrev;
    let modalID    = modalView.modalNativeID!
    
    self.currentModalLevel = modalLevel;
    self.presentedModalRefs.removeObject(forKey: modalID as NSString);
    
    // notify delegates that a new modal is lost focus
    self.delegatesFocus.invoke {
      $0.onModalChangeFocus(
        modalLevel: modalLevel,
        modalNativeID: modalID,
        isInFocus : false
      );
    };
  };
};
