//
//  RNIModalSwizzledViewController.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/11/23.
//

import Foundation


extension UIViewController {
  
  static var isSwizzled = false;
  
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
    
    // call original impl.
    self._swizzled_present(viewControllerToPresent, animated: flag) {
      #if DEBUG
      print(
          "Log - UIViewController+Swizzling"
        + " - UIViewController._swizzled_present"
        + " - completion invoked"
      );
      #endif
      
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
    
    // call original impl.
    self._swizzled_dismiss(animated: flag) {
      #if DEBUG
      print(
          "Log - UIViewController+Swizzling"
        + " - UIViewController._swizzled_dismiss"
        + " - completion invoked"
      );
      #endif
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
