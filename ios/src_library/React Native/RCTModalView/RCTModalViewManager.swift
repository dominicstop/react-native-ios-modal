//
//  RCTModalViewManager.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/9/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation



@objc (RCTModalViewManager)
class RCTModalViewManager: RCTViewManager {
  static var sharedInstance: RCTModalViewManager!;
  
  override static func requiresMainQueueSetup() -> Bool {
    return true;
  };
  
  var presentedModalRefs = NSMapTable<NSString, RCTModalView>.init(
    keyOptions  : .copyIn,
    valueOptions: .weakMemory
  );
  
  var delegatesFocus = MulticastDelegate<RCTModalViewFocusDelegate>();
  
  private var currentModalLevel = -1;
 
  override func view() -> UIView! {
    let view = RCTModalView(bridge: self.bridge);
    // set delegates
    self.delegatesFocus.add(view);
    view.delegate = self;
    
    return view;
  };
  
  override init() {
    super.init();
    RCTModalViewManager.sharedInstance = self;
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
        let modalView = component as? RCTModalView
      else {
        #if DEBUG
        print("RCTModalViewManager, requestModalOpen failed");
        #endif
        return;
      };
      
      #if DEBUG
      print(
          "RCTModalViewManager, requestModalOpen Received - "
        + "prevVisibility: \(modalView.isPresented) and nextVisibility: \(visibility) - "
        + "For node: \(node) and requestID: \(requestID)"
      );
      #endif
      
      modalView.requestModalPresentation(requestID, visibility);
    };
  };
};

// ---------------------------------
// MARK: RCTModalViewPresentDelegate
// ---------------------------------

extension RCTModalViewManager: RCTModalViewPresentDelegate {
  
  func onPresentModalView(modalView: RCTModalView) {
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
  
  func onDismissModalView(modalView: RCTModalView) {
    let modalLevel = modalView.modalLevelPrev;
    let modalUUID  = modalView.modalUUID;
    
    self.currentModalLevel = modalLevel;
    self.presentedModalRefs.removeObject(forKey: modalUUID as NSString);
    
    self.delegatesFocus.invoke {
      $0.onModalChangeFocus(
        modalLevel: modalLevel,
        modalUUID : modalUUID,
        isInFocus : false
      );
    };
  };
};
