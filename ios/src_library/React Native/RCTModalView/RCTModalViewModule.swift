//
//  RCTModalViewModule.swift
//  RNSwiftReviewer
//
//  Created by Dominic Go on 7/11/20.
//

import Foundation


@objc(RCTModalViewModule)
class RCTModalViewModule: RCTEventEmitter {
  
  enum Events: String, CaseIterable {
    case onModalFocus;
    case onModalDismiss;
  };
  
  @objc override static func requiresMainQueueSetup() -> Bool {
    return false;
  };
  
  var hasListeners = false;
  
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
};

// -----------------------------
// MARK: Extension: JS Functions
// -----------------------------

extension RCTModalViewModule {
  @objc func dismissModalByID(_ modalID: NSString, callback: @escaping RCTResponseSenderBlock) {
    DispatchQueue.main.async {
      guard let rootVC = UIWindow.key?.rootViewController else {
        #if DEBUG
        print("RCTModalViewModule, dismissModalByID Error: could not get root VC. ");
        #endif
        callback([false]);
        return;
      };
      
      // climb the vc hierarchy to find the modal
      var currentVC = rootVC;
      while let presentedVC = currentVC.presentedViewController {
        currentVC = presentedVC;

        if let navVC   = presentedVC as? UINavigationController,
           let rootVC  = navVC.viewControllers.first,
           let modalVC = rootVC as? RCTModalViewController,
           // check if this is the modal we want to dismiss
           modalVC.modalID == modalID {
          
          let completion = {
            // modal dismissed
            callback([true]);
            
            #if DEBUG
            print("RCTModalViewModule, dismissModalByID: dismissing \(modalVC.modalID ?? "N/A")");
            #endif
          };
          
          if let modalRef = modalVC.modalViewRef {
            /// use `modalRef` to dismiss modal if it still exists so that modal blur/focus events will work
            modalRef.dismissModal { (isSuccess, error) in
              guard isSuccess else {
                #if DEBUG
                print(
                    "RCTModalViewModule, dismissModalByID Fail: modalID \(modalRef.modalID ?? "N/A")"
                  + " - error code: \(error?.rawValue ?? "N/A")"
                  + " - error message: \(error?.errorMessage ?? "N/A")"
                );
                #endif
                callback([false]);
                return;
              };
              
              // modal dismissed
              completion();
              
              let manager = RCTModalViewManager.sharedInstance;
              manager?.presentedModalRefs.removeObject(forKey: modalRef.modalUUID as NSString);
            };
            
          } else {
            /// `modalRef` no longer eixists, so we have dismiss manually
            /// TODO: Add code to manually propogate modal blur/focus events
            modalVC.dismiss(animated: true){
              // modal dismissed
              completion();
            };
          };
          
          // early exit, stop loop
          return;
        };
        
        // reached end of loop, modal not found
        callback([false]);
      };
    };
  };
  
  @objc func dismissAllModals(_ animated: Bool, callback: @escaping RCTResponseSenderBlock){
    DispatchQueue.main.async {
      let success: Void? = UIWindow.key?
        .rootViewController?
        .dismiss(animated: animated, completion: nil);
      
      callback([success != nil]);
    };
  };
};

// --------------------------------------------
// MARK: Extension: RCTModalViewPresentDelegate
// --------------------------------------------

extension RCTModalViewModule: RCTModalViewPresentDelegate {
  func onPresentModalView(modalView: RCTModalView) {
    guard self.hasListeners else { return };
    
    self.sendEvent(
      withName: Self.Events.onModalFocus.rawValue,
      body: modalView.createModalNativeEventDict()
    );
  };
  
  func onDismissModalView(modalView: RCTModalView) {
    guard self.hasListeners else { return };
    
    self.sendEvent(
      withName: Self.Events.onModalDismiss.rawValue,
      body: modalView.createModalNativeEventDict()
    );
  };
};
