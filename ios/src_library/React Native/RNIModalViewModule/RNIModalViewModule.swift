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
};

// MARK: - Standalone Functions
// ----------------------------

extension RNIModalViewModule {
  
  // TODO: See TODO:2023-03-05-00-33-15  - Refactor: Re-write 
  // `dismissModalByID``
  @objc func dismissModalByID(
    _ modalID: NSString,
    callback: @escaping RCTResponseSenderBlock
  ) {
    DispatchQueue.main.async {
      guard let rootVC = UIWindow.key?.rootViewController else {
        #if DEBUG
        print("RNIModalViewModule, dismissModalByID Error: could not get root VC. ");
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
           let modalVC = rootVC as? RNIModalViewController,
           // check if this is the modal we want to dismiss
           modalVC.modalID == modalID as String {
          
          let completion = {
            // modal dismissed
            callback([true]);
            
            #if DEBUG
            print("RNIModalViewModule, dismissModalByID: dismissing \(modalVC.modalID ?? "N/A")");
            #endif
          };
          
          if let modalRef = modalVC.modalViewRef {
            /// use `modalRef` to dismiss modal if it still exists so that modal blur/focus events will work
            modalRef.dismissModal { (isSuccess, error) in
              guard isSuccess else {
                #if DEBUG
                print(
                    "RNIModalViewModule, dismissModalByID Fail: modalID \(modalRef.modalID ?? "N/A")"
                  + " - error code: \(error?.rawValue ?? "N/A")"
                  + " - error message: \(error?.errorMessage ?? "N/A")"
                );
                #endif
                callback([false]);
                return;
              };
              
              // modal dismissed
              completion();
              
              let manager = RNIModalViewManager.sharedInstance;
              manager?.presentedModalRefs.removeObject(forKey: modalRef.modalNativeID! as NSString);
            };
            
          } else {
            /// `modalRef` no longer exists, so we have dismiss manually

            /// TODO: See TODO:2023-03-05-00-32-43 - Fix: Edge 
            // Case - Modal Focus/Blur Bug
            //
            // * Add code to manually propagate modal blur/focus 
            //   events
            //
            // * The modal is being dismissed via calling the 
            //   modal view controller's dismiss method. As such, 
            //   the focus/blur event is not being propagated.
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
};

// MARK: - View-Related Functions
// ------------------------------

extension RNIModalViewModule {
  
  @objc func setModalVisibility(
    _ node: NSNumber,
    visibility: Bool,
    // promise blocks ------------------------
    resolve: @escaping RCTPromiseResolveBlock,
    reject : @escaping RCTPromiseRejectBlock
  ){
    DispatchQueue.main.async {
      guard let modalView = self.getModalViewInstance(for: node) else {
        reject(nil, "Unable to get the corresponding 'RNIModalView' instance for node: \(node)", nil);
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
        reject(nil, "Unable to get the corresponding 'RNIModalView' instance for node: \(node)", nil);
        return;
      };
      
      resolve(
        modalView.synthesizedBaseEventData.synthesizedDictionary
      );
    };
  };
};
