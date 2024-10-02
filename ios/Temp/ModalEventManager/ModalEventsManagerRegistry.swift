//
//  ModalEventsManagerRegistry.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/2/24.
//

import UIKit
import DGSwiftUtilities


public final class ModalEventsManagerRegistry: Singleton {
  
  public typealias `Self` = ModalEventsManagerRegistry;
  
  // MARK: Static Properties
  // -----------------------

  public static let shared: Self = .init();
  
  // MARK: - Static Properties (Swizzling-Related)
  // ---------------------------------------------

  private(set) public static var isSwizzled = false;
  public static var shouldSwizzle = true;
  
  // MARK: - Properties
  // ------------------
  
  public var instanceRegistry: Dictionary<String, ModalEventsManager> = [:]
  
  // MARK: - Init
  // ------------
  
  public init(){
    self.swizzleIfNeeded();
  };
  
  // MARK: - Methods
  // ---------------
  
  public func getManager(forWindow window: UIWindow) -> ModalEventsManager {
    let match = self.instanceRegistry[window.synthesizedStringID];
    
    
    if let match = match,
       match.window != nil
    {
      return match;
    };
    
    let newManager: ModalEventsManager = .init(withWindow: window);
    self.instanceRegistry[window.synthesizedStringID] = newManager;
    
    return newManager;
  };
  
  // MARK: - Methods (Swizzling-Related)
  // ----------------------------------
  
  public func swizzleIfNeeded(){
    guard Self.shouldSwizzle,
          !Self.isSwizzled
    else { return };
    
    Self.isSwizzled = true;
    self._swizzlePresent();
    self._swizzleDismiss();
  };
  
  private func _swizzlePresent(){
    SwizzlingHelpers.swizzlePresent() { originalImp, selector in
      return { _self, vcToPresent, animated, completion in
        
        let currentWindow =
             _self.view.window
          ?? vcToPresent.view.window
          ?? UIApplication.shared.activeWindow;
          
        guard let currentWindow = currentWindow else {
          #if DEBUG
          fatalError("Unable to get window")
          #else
          return;
          #endif
        };
          
        let eventManager = self.getManager(forWindow: currentWindow);
        
        eventManager.notifyOnModalWillPresent(
          forViewController: vcToPresent,
          targetWindow: currentWindow
        );
        
        // Call the original implementation.
        originalImp(_self, selector, vcToPresent, animated){
          eventManager.notifyOnModalDidPresent(
            forViewController: vcToPresent,
            targetWindow: currentWindow
          );
          completion?();
        };
      };
    };
  };
  
  private func _swizzleDismiss(){
    SwizzlingHelpers.swizzleDismiss() { originalImp, selector in
      return { _self, animated, completion in

        let currentWindow =
             _self.view.window
          ?? _self.presentedViewController?.view.window
          ?? UIApplication.shared.activeWindow;
          
        let modalVC =
             _self.presentedViewController
          ?? currentWindow?.topmostPresentedViewController;
          
        guard let currentWindow = currentWindow,
              let modalVC = modalVC
        else {
          #if DEBUG
          fatalError("Unable to get window or presented view controller")
          #else
          return;
          #endif
        };
        
        let eventManager = self.getManager(forWindow: currentWindow);

        eventManager.notifyOnModalWillDismiss(
          forViewController: modalVC,
          targetWindow: currentWindow
        );
        
        // Call the original implementation.
        originalImp(_self, selector, animated){
          eventManager.notifyOnModalDidDismiss(
            forViewController: modalVC,
            targetWindow: currentWindow
          );
          completion?();
        };
      };
    };
  };
};
