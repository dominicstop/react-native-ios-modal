//
//  RNIModalUtilities.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 5/1/23.
//

import UIKit

public class RNIModalUtilities {

  static func getPresentedModals(
    forWindow window: UIWindow
  ) -> [any RNIModal] {
  
    let vcItems =
      RNIPresentedVCListCache.getPresentedViewControllers(forWindow: window);
    
    return vcItems.compactMap {
      guard let modalVC = $0 as? RNIModalViewController else { return nil };
      return modalVC.modalViewRef;
    };
  };
  
  static func computeModalIndex(
    forWindow window: UIWindow,
    forViewController viewController: UIViewController? = nil
  ) -> Int {
    
    let listPresentedVC =
      RNIPresentedVCListCache.getPresentedViewControllers(forWindow: window);
    
    var index = -1;
    
    for vc in listPresentedVC {
      if vc.presentingViewController != nil {
        index += 1;
      };
      
      /// A - no `viewController` arg., keep counting until all items in
      ///     `listPresentedVC` have been exhausted.
      guard viewController == nil else { continue };
      
      /// B - `viewController` arg. specified, stop counting if found matching
      ///      instance of `viewController` in `listPresentedVC`.
      guard viewController !== vc
      else { break };
    };
    
    return index;
  };
  
  static func computeModalIndex(
    forWindow window: UIWindow?,
    forViewController viewController: UIViewController? = nil
  ) -> Int {
    guard let window = window else { return -1 };
    
    return Self.computeModalIndex(
      forWindow: window,
      forViewController: viewController
    );
  };
  
  static func getPresentedModal(
    forPresentingViewController presentingVC: UIViewController,
    presentedViewController presentedVC: UIViewController? = nil
  ) -> (any RNIModal)? {
    
    let presentedVC = presentedVC ?? presentingVC.presentedViewController;
    
    /// A - `presentedVC` is a `RNIModalViewController`.
    if let presentedModalVC = presentedVC as? RNIModalViewController {
      return presentedModalVC.modalViewRef;
    };
    
    /// B - `presentingVC` is a `RNIModalViewController`.
    if let presentingModalVC = presentingVC as? RNIModalViewController,
       let presentingModal = presentingModalVC.modalViewRef,
       let presentedModalVC = presentingModal.modalVC,
       let presentedModal = presentedModalVC.modalViewRef  {
       
      return presentedModal;
    };
        
    /// C - `presentedVC` has a corresponding `RNIModalViewControllerWrapper`
    ///     instance associated to it.
    if let presentedVC = presentedVC,
       let presentedModalWrapper = RNIModalViewControllerWrapperRegistry.get(
         forViewController: presentedVC
       ) {
      
      return presentedModalWrapper;
    };
    
    /// D - `presentingVC` has a `RNIModalViewControllerWrapper` instance
    ///     associated to it.
    if let presentingModalWrapper = RNIModalViewControllerWrapperRegistry.get(
         forViewController: presentingVC
       ),
       let presentedVC = presentingModalWrapper.modalViewController,
       let presentedModalWrapper = RNIModalViewControllerWrapperRegistry.get(
         forViewController: presentedVC
       ) {
      
      return presentedModalWrapper;
    };
    
    let topmostVC = RNIUtilities.getTopmostPresentedViewController(
      for: presentingVC.view.window
    );
    
    if let topmostModalVC = topmostVC as? RNIModalViewController,
       let topmostModal = topmostModalVC.modalViewRef {
    
      return topmostModal;
    };
    
    return nil;
  };
};
