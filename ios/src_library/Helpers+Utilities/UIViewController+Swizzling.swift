//
//  RNIModalSwizzledViewController.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/11/23.
//

import Foundation

extension UIViewController {
  
  static var isSwizzled = false;
  
  fileprivate var modalWrapper: RNIModalViewControllerWrapper? {
    RNIModalManagerShared.getModalInstance(
      forPresentingViewController: self
    ) as? RNIModalViewControllerWrapper;
  };
  
  @discardableResult
  func registerIfNeeded(
    viewControllerToPresent: UIViewController? = nil
  ) -> RNIModalViewControllerWrapper? {
    guard !(self is RNIModalViewController),
          !RNIModalManagerShared.isRegistered(viewController: self)
    else { return nil };
    
    let modalWrapper = self.modalWrapper ?? RNIModalViewControllerWrapper();
    
    modalWrapper.presentingViewController = self;
    modalWrapper.modalViewController = viewControllerToPresent;
    
    return modalWrapper;
  };
  
  func getPresentedModal(
    viewControllerToPresent: UIViewController? = nil
  ) -> (any RNIModal)? {
    if let presentedModalVC = viewControllerToPresent as? RNIModalViewController {
      return presentedModalVC.modalViewRef;
      
    } else if let presentedVC = self.presentedViewController,
              let presentedModalVC = presentedVC as? RNIModalViewController {
      return presentedModalVC.modalViewRef;
      
    } else if let presentingModalVC = self as? RNIModalViewController,
              let presentingModal = presentingModalVC.modalViewRef,
              let presentedModalVC = presentingModal.modalVC {
      return presentedModalVC.modalViewRef;
      
    } else if let viewControllerToPresent = viewControllerToPresent,
              let presentedModal =
                RNIModalManagerShared.getModalInstance(
                  forPresentedViewController: viewControllerToPresent
                ) {
      return presentedModal;
      
    } else if let presentingModalWrapper = self.modalWrapper,
              let presentingModalVC = presentingModalWrapper.modalViewController,
              let presentedModal =
                RNIModalManagerShared.getModalInstance(
                  forPresentedViewController: presentingModalVC
                ) {
      return presentedModal;
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
  
  // TODO: Move to `RNIUtilities`
  static func swizzleExchangeMethods(
    defaultSelector: Selector,
    newSelector: Selector,
    forClass class: AnyClass
  ) {
    let defaultInstace =
      class_getInstanceMethod(`class`.self, defaultSelector);
    
    let newInstance =
      class_getInstanceMethod(`class`.self, newSelector);
    
    guard let defaultInstance = defaultInstace,
          let newInstance = newInstance
    else { return };
          
    method_exchangeImplementations(defaultInstance, newInstance);
  };
  
  internal static func swizzleMethods() {
    guard RNIModalSwizzling.shouldEnableSwizzling else { return };
    
    #if DEBUG
    print(
        "Log - UIViewController+Swizzling"
      + " - UIViewController.swizzleMethods invoked"
    );
    #endif
    
    self.swizzleExchangeMethods(
      defaultSelector: #selector(Self.present(_:animated:completion:)),
      newSelector:  #selector(Self._swizzled_present(_:animated:completion:)),
      forClass: UIViewController.self
    );
    
    self.swizzleExchangeMethods(
      defaultSelector: #selector(Self.dismiss(animated:completion:)),
      newSelector: #selector(Self._swizzled_dismiss(animated:completion:)),
      forClass: UIViewController.self
    );
    
    self.isSwizzled.toggle();
  };
};
