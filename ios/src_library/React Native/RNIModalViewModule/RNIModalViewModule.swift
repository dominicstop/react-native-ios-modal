//
//  RNIModalViewModule.swift
//  RNSwiftReviewer
//
//  Created by Dominic Go on 7/11/20.
//

import Foundation


@objc(RNIModalViewModule)
class RNIModalViewModule: RCTEventEmitter {
  
  enum Events: String, CaseIterable {
    case placeholderEvent;
  };
  
  @objc override static func requiresMainQueueSetup() -> Bool {
    return false;
  };

  func getModalViewInstance(for node: NSNumber) -> RNIModalView? {
    return RNIUtilities.getView(
      forNode: node,
      type   : RNIModalView.self,
      bridge : self.bridge
    );
  };
  
  // MARK: - Event-Related
  // ----------------------
  
  private var hasListeners = false;
  
  override func supportedEvents() -> [String]! {
    return Self.Events.allCases.map { $0.rawValue };
  };
  
  // called when first listener is added
  override func startObserving() {
    self.hasListeners = true;
  };
  
  // called when this module's last listener is removed, or dealloc
  override func stopObserving() {
    self.hasListeners = false;
  };
  
  func sendModalEvent(event: Events, params: Dictionary<AnyHashable, Any>) {
    guard self.hasListeners else { return };
    self.sendEvent(withName: event.rawValue, body: params);
  };
  
  // MARK: - Module Functions
  // ------------------------

  @objc func dismissModalByID(
    _ modalID: NSString,
    callback: @escaping RCTResponseSenderBlock
  ) {
    DispatchQueue.main.async {
      let listPresentedVC = RNIModalManager.getPresentedViewControllers();
      
      
      guard listPresentedVC.count > 0 else {
        #if DEBUG
        print(
            "RNIModalViewModule - dismissModalByID - Error - "
          + "`listPresentedVC` is empty"
        );
        #endif
        callback([false]);
        return;
      };
      
      let listPresentedModalVC =
        listPresentedVC.compactMap { $0 as? RNIModalViewController };
      
      let targetModalVC = listPresentedModalVC.first {
        guard let modalID = $0.modalID else { return false };
        return modalID == modalID;
      };
      
      guard let targetModalView = targetModalVC?.modalViewRef else {
        #if DEBUG
        print(
            "RNIModalViewModule - dismissModalByID - Error - "
          + "Could not get matching `RNIModalView` instance."
        );
        #endif
        callback([false]);
        return;
      };
      
      targetModalView.dismissModal { isSuccess, error in
        guard isSuccess else {
          #if DEBUG
          print(
              "RNIModalViewModule - dismissModalByID - Error - "
            + "RNIModalView.dismissModal"
          );
          #endif
          callback([false]);
          return;
        };
        
        // modal dismissed
        callback([true]);
        
        #if DEBUG
        print(
            "RNIModalViewModule - dismissModalByID - Dismissing modal - "
          + "modalID: '\(targetModalView.modalID!)'"
        );
        #endif
      };
    };
  };
  
  @objc func dismissAllModals(
    _ animated: Bool,
    callback: @escaping RCTResponseSenderBlock
  ) {
    DispatchQueue.main.async {
      let success: Void? = UIWindow.key?
        .rootViewController?
        .dismiss(animated: animated, completion: nil);
      
      callback([success != nil]);
    };
  };

  // MARK: - View-Related Functions
  // ------------------------------
  
  @objc func setModalVisibility(
    _ node: NSNumber,
    visibility: Bool,
    // promise blocks ------------------------
    resolve: @escaping RCTPromiseResolveBlock,
    reject : @escaping RCTPromiseRejectBlock
  ){
    DispatchQueue.main.async {
      guard let modalView = self.getModalViewInstance(for: node) else {
        let message =
            "RNIModalViewModule.setModalVisibility - Unable to get the "
          + "corresponding 'RNIModalView' instance for node: \(node)"
        
        reject(nil, message, nil);
        return;
      };
      
      modalView.setModalVisibility(visibility: visibility) { isSuccess, error in
        if isSuccess {
          resolve(
            modalView.synthesizedBaseEventData.synthesizedDictionary
          );
          
        } else {
          reject(nil, error?.errorMessage, nil);
        };
      };
    };
  };
  
  @objc func requestModalInfo(
    _ node: NSNumber,
    // promise blocks ------------------------
    resolve: @escaping RCTPromiseResolveBlock,
    reject : @escaping RCTPromiseRejectBlock
  ){
    DispatchQueue.main.async {
      guard let modalView = self.getModalViewInstance(for: node) else {
        let message =
            "RNIModalViewModule.requestModalInfo - Unable to get the "
          + "corresponding 'RNIModalView' instance for node: \(node)"
        
        reject(nil, message, nil);
        return;
      };
      
      resolve(
        modalView.synthesizedBaseEventData.synthesizedDictionary
      );
    };
  };
};
