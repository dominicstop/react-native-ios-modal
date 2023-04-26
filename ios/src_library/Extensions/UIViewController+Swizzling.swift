//
//  RNIModalSwizzledViewController.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/11/23.
//

import Foundation


class RNIModalWrapperMap {
  static let instanceMap = NSMapTable<
    UIViewController,
    RNIModalViewControllerWrapper
  >(
    keyOptions: .weakMemory,
    valueOptions: .weakMemory
  );
  
  static func get(
    forViewController viewController: UIViewController
  ) -> RNIModalViewControllerWrapper? {
    
    Self.instanceMap.object(forKey: viewController);
  };
  
  static func set(
    forViewController viewController: UIViewController,
    _ modalWrapper: RNIModalViewControllerWrapper
  ){
    
    Self.instanceMap.setObject(modalWrapper, forKey: viewController);
  };
  
  static func isRegistered(
    forViewController viewController: UIViewController
  ) -> Bool {
    Self.get(forViewController: viewController) != nil;
  };
};


extension UIViewController {
  
  static var isSwizzled = false;
  
  fileprivate var modalWrapper: RNIModalViewControllerWrapper? {
    RNIModalWrapperMap.get(forViewController: self);
  };
  
  @discardableResult
  fileprivate func registerIfNeeded(
    viewControllerToPresent: UIViewController
  ) -> RNIModalViewControllerWrapper? {
  
    /// If `viewControllerToPresent` is being presented by a
    /// `RNIModalViewController` instance, then we don't need to wrap the
    /// current instance inside a `RNIModalViewControllerWrapper` since it
    /// will already notify `RNIModalManager` of modal-related events...
    ///
    guard !(self is RNIModalViewController) else { return nil };
    
    let modalWrapper: RNIModalViewControllerWrapper = {
    
      /// A - Wrapper already exists for `viewControllerToPresent`,
      ///     return matching instance.
      ///
      if let modalWrapper =
        RNIModalWrapperMap.get(forViewController: viewControllerToPresent) {
        
        return modalWrapper;
      };
      
      // B - Wrapper does not exists for `viewControllerToPresent`,
      //     so create new instance.
      //
      let newModalWrapper = RNIModalViewControllerWrapper();
        
      RNIModalWrapperMap.set(
        forViewController: self,
        newModalWrapper
      );
      
      return newModalWrapper;
    }();
 
    modalWrapper.presentingViewController = self;
    modalWrapper.modalViewController = viewControllerToPresent;
    
    return modalWrapper;
  };
  
  fileprivate func getPresentedModal(
    viewControllerToPresent: UIViewController? = nil
  ) -> (any RNIModal)? {
    if let presentedModalVC = viewControllerToPresent as? RNIModalViewController {
      return presentedModalVC.modalViewRef;
      
    } else if let presentedVC = self.presentedViewController,
              let presentedModalVC = presentedVC as? RNIModalViewController {
      
      /// A - Arg `viewControllerToPresent` is a `RNIModalViewController`
      return presentedModalVC.modalViewRef;
      
    } else if let presentingModalVC = self as? RNIModalViewController,
              let presentingModal = presentingModalVC.modalViewRef,
              let presentedModalVC = presentingModal.modalVC {
      
      /// B - Current vc instance is a `RNIModalViewController` (and was
      ///     presented by a `RNIModalView`).
      return presentedModalVC.modalViewRef;
      
    } else if let presentedVC = viewControllerToPresent,
              let presentedModalWrapper =
                RNIModalWrapperMap.get(forViewController: presentedVC) {
      
      /// C - `viewControllerToPresent` has a corresponding
      ///     `RNIModalViewControllerWrapper` instance associated to it.
      return presentedModalWrapper;
      
    } else if let presentingModalWrapper = self.modalWrapper,
              let presentedVC = presentingModalWrapper.modalViewController,
              let presentedModalWrapper =
                RNIModalWrapperMap.get(forViewController: presentedVC) {
      
      /// D - Current vc instance has a `RNIModalViewControllerWrapper`
      ///     instance associated to it.
      return presentedModalWrapper;
    };
    
    return nil;
  };
  
  @objc fileprivate func _swizzled_present(
    _ viewControllerToPresent: UIViewController,
    animated flag: Bool,
    completion: (() -> Void)? = nil
  ) {
    #if DEBUG
    print(
        "Log - UIViewController+Swizzling"
      + " - UIViewController._swizzled_present invoked"
      + " - arg viewControllerToPresent: \(viewControllerToPresent)"
      + " - arg animated: \(flag)"
    );
    #endif
    
    self.registerIfNeeded(viewControllerToPresent: viewControllerToPresent);
    
    let presentedModal =
      self.getPresentedModal(viewControllerToPresent: viewControllerToPresent);
    
    if let presentedModal = presentedModal {
      presentedModal.modalPresentationNotificationDelegate
        .notifyOnModalWillShow(sender: presentedModal);
    };
    
    // call original impl.
    self._swizzled_present(viewControllerToPresent, animated: flag) {
      #if DEBUG
      print(
          "Log - UIViewController+Swizzling"
        + " - UIViewController._swizzled_present"
        + " - completion invoked"
      );
      #endif
      
      if let presentedModal = presentedModal {
        presentedModal.modalPresentationNotificationDelegate
          .notifyOnModalDidShow(sender: presentedModal);
      };
      
      completion?();
    };
  };
  
  @objc fileprivate func _swizzled_dismiss(
    animated flag: Bool,
    completion: (() -> Void)? = nil
  ) {
    #if DEBUG
    print(
        "Log - UIViewController+Swizzling"
      + " - UIViewController._swizzled_dismiss invoked"
      + " - arg animated: \(flag)"
      + " - self.presentedViewController: \(String(describing: presentedViewController))"
    );
    #endif
    
    let presentedModal = self.getPresentedModal();
    
    if let presentedModal = presentedModal {
      presentedModal.modalPresentationNotificationDelegate
        .notifyOnModalWillHide(sender: presentedModal);
    };
    
    // call original impl.
    self._swizzled_dismiss(animated: flag) {
      #if DEBUG
      print(
          "Log - UIViewController+Swizzling"
        + " - UIViewController._swizzled_dismiss"
        + " - completion invoked"
      );
      #endif
      
      if let presentedModal = presentedModal {
        presentedModal.modalPresentationNotificationDelegate
          .notifyOnModalDidHide(sender: presentedModal);
      };
      
      completion?();
    };
  };
  
  internal static func swizzleMethods() {
    guard RNIModalSwizzling.shouldEnableSwizzling else { return };
    
    #if DEBUG
    print(
        "Log - UIViewController+Swizzling"
      + " - UIViewController.swizzleMethods invoked"
    );
    #endif
    
    RNIUtilities.swizzleExchangeMethods(
      defaultSelector: #selector(Self.present(_:animated:completion:)),
      newSelector:  #selector(Self._swizzled_present(_:animated:completion:)),
      forClass: UIViewController.self
    );
    
    RNIUtilities.swizzleExchangeMethods(
      defaultSelector: #selector(Self.dismiss(animated:completion:)),
      newSelector: #selector(Self._swizzled_dismiss(animated:completion:)),
      forClass: UIViewController.self
    );
    
    self.isSwizzled.toggle();
  };
};
