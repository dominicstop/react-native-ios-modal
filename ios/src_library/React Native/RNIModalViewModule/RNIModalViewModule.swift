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
  
  @objc func setModalVisibilityByID(
    _ modalID: NSString,
    visibility: Bool,
    // promise blocks ------------------------
    resolve: @escaping RCTPromiseResolveBlock,
    reject : @escaping RCTPromiseRejectBlock
  ) {
    DispatchQueue.main.async {
      let listPresentedVC = RNIUtilities.getPresentedViewControllers();
      
      let debugData: Dictionary<String, Any> = [
        "modalID": modalID,
        "visibility": visibility,
      ];
      
      do {
        guard listPresentedVC.count > 0 else {
          throw RNIModalError(
            code: .runtimeError,
            message: "The list of presented view controllers is empty",
            debugData: debugData
          );
        };
        
        let listPresentedModalVC =
          listPresentedVC.compactMap { $0 as? RNIModalViewController };
        
        let targetModalVC = listPresentedModalVC.first {
          guard let modalID = $0.modalID else { return false };
          return modalID == modalID;
        };
        
        guard let targetModalView = targetModalVC?.modalViewRef else {
          let errorMessage =
              "Unable to get the matching RNIModalView instance for"
            + " modalID: \(modalID)";
        
          throw RNIModalError(
            code: .runtimeError,
            message: errorMessage,
            debugData: debugData
          );
        };
        
        let modalAction = visibility
          ? targetModalView.presentModal
          : targetModalView.dismissModal;
        
        try modalAction {
          // modal dismissed
          resolve([:]);
        };
        
        #if DEBUG
        print(
            "Log - RNIModalViewModule.setModalVisibilityByID - Dismissing modal"
          + " - target modalID: '\(targetModalView.modalID!)'"
        );
        #endif
      
      } catch let error as RNIModalError {
        error.invokePromiseRejectBlock(reject);
      
      } catch {
        var errorWrapper = RNIModalError(
          code: .unknownError,
          error: error
        );
        
        errorWrapper.addDebugData(debugData);
        errorWrapper.invokePromiseRejectBlock(reject);
      };
    };
  };
  
  @objc func dismissAllModals(
    _ animated: Bool,
    // promise blocks ------------------------
    resolve: @escaping RCTPromiseResolveBlock,
    reject : @escaping RCTPromiseRejectBlock
  ) {
    DispatchQueue.main.async {
      let windows = RNIUtilities.getWindows();
      let rootViewControllers = windows.map { $0.rootViewController };
      
      guard rootViewControllers.isEmpty else {
        let error = RNIModalError(
          code: .runtimeError,
          message: "Could not get root view controllers"
        );
        
        error.invokePromiseRejectBlock(reject);
        return;
      };
      
      rootViewControllers.enumerated().forEach {
        let isLast = $0.offset == rootViewControllers.count - 1;
        
        $0.element?.dismiss(animated: animated) {
          guard isLast else { return };
          resolve([:]);
        };
      };
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
        let error = RNIModalError(
          code: .runtimeError,
          message: "Unable to get the matching RNIModalView instance for node",
          debugData: [
            "node": node,
            "visibility": visibility
          ]
        );
      
        error.invokePromiseRejectBlock(reject);
        return;
      };
      
      let modalAction = visibility
        ? modalView.presentModal
        : modalView.dismissModal;
        
      do {
        try modalAction() {
          resolve([:]);
        };
      
      } catch let error as RNIModalError {
        error.invokePromiseRejectBlock(reject)
        
      } catch {
        let errorWrapper = RNIModalError(
          code: .unknownError,
          error: error
        );
        
        errorWrapper.invokePromiseRejectBlock(reject);
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
        let errorMessage =
            "Unable to get the corresponding RNIModalView instance"
          + " for node: \(node)"
          
        let error = RNIModalError(code: .runtimeError, message: errorMessage);
        error.invokePromiseRejectBlock(reject);
        return;
      };
      
      resolve(
        modalView.synthesizedBaseEventData.synthesizedJSDictionary
      );
    };
  };
};
