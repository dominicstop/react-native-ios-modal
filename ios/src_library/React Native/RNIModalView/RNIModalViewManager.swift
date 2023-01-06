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
  
  // a weak ref to the currently presented modals
  // currently unused, remove later
  var presentedModalRefs = NSMapTable<NSString, RNIModalView>.init(
    keyOptions  : .copyIn,
    valueOptions: .weakMemory
  );
  
  // TODO: Relocate
  var delegatesFocus = MulticastDelegate<RNIModalViewFocusDelegate>();
  
  // TODO: Relocate
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
        .availableStyles.map { $0.stringDescription() },
      
      "availablePresentationStyles": UIModalPresentationStyle
        .availableStyles.map { $0.stringDescription() },
    ];
  };
  
  @objc func requestModalPresentation(_ node: NSNumber, requestID: NSNumber, visibility: Bool){
    DispatchQueue.main.async {
      guard
        let component = self.bridge.uiManager.view(forReactTag: node),
        let modalView = component as? RNIModalView
      else {
        #if DEBUG
        print("RNIModalViewManager, requestModalOpen failed");
        #endif
        return;
      };
      
      #if DEBUG
      print(
          "RNIModalViewManager, requestModalOpen Received - "
        + "prevVisibility: \(modalView.isPresented) and nextVisibility: \(visibility) - "
        + "For node: \(node) and requestID: \(requestID)"
      );
      #endif
      
      modalView.requestModalPresentation(requestID, visibility);
    };
  };
  
  @objc func requestModalInfo(_ node: NSNumber, requestID: NSNumber){
    DispatchQueue.main.async {
      guard
        let component = self.bridge.uiManager.view(forReactTag: node),
        let modalView = component as? RNIModalView
      else {
        #if DEBUG
        print("RNIModalViewManager, requestModalInfo failed");
        #endif
        return;
      };
      
      #if DEBUG
      print(
          "RNIModalViewManager, requestModalInfo Received - "
        + "For node: \(node) and requestID: \(requestID)"
      );
      #endif
      
      modalView.requestModalInfo(requestID);
    };
  };
};

// ---------------------------------
// MARK: RNIModalViewPresentDelegate
// ---------------------------------

extension RNIModalViewManager: RNIModalViewPresentDelegate {
  
  func onPresentModalView(modalView: RNIModalView) {
    let modalLevel = modalView.modalLevel;
    let modalUUID  = modalView.modalUUID;
    
    self.currentModalLevel = modalLevel;
    self.presentedModalRefs.setObject(modalView, forKey: modalUUID as NSString);
    
    // notify delegates that a new modal is in focus
    self.delegatesFocus.invoke {
      $0.onModalChangeFocus(
        modalLevel: modalLevel,
        modalUUID : modalUUID,
        isInFocus : true
      );
    };
  };
  
  func onDismissModalView(modalView: RNIModalView) {
    let modalLevel = modalView.modalLevelPrev;
    let modalUUID  = modalView.modalUUID;
    
    self.currentModalLevel = modalLevel;
    self.presentedModalRefs.removeObject(forKey: modalUUID as NSString);
    
    // notify delegates that a new modal is lost focus
    self.delegatesFocus.invoke {
      $0.onModalChangeFocus(
        modalLevel: modalLevel,
        modalUUID : modalUUID,
        isInFocus : false
      );
    };
  };
};
