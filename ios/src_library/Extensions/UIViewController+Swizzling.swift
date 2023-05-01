//
//  RNIModalSwizzledViewController.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/11/23.
//

import Foundation

extension UIViewController {

  // MARK: - Static - Swizzling-Related
  // ----------------------------------
  
  static var isSwizzled = false;
  
  internal static func swizzleMethods() {
    guard RNIModalFlagsShared.shouldSwizzleViewControllers else { return };
    
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
  
  // MARK: - Helpers - Static
  // ------------------------
  
  @discardableResult
  static private func registerIfNeeded(
    forViewController vc: UIViewController
  ) -> RNIModalViewControllerWrapper? {
  
    let shouldWrapVC = vc is RNIModalViewController
      ? RNIModalFlagsShared.shouldWrapAllViewControllers
      : true;
  
    /// If the arg `vc` is a `RNIModalViewController` instance, then we don't
    ///  need to wrap the current instance inside a
    /// `RNIModalViewControllerWrapper` since it will already notify
    /// `RNIModalManager` of modal-related events...
    ///
    guard shouldWrapVC else { return nil };
    
    let modalWrapper: RNIModalViewControllerWrapper = {
      /// A - Wrapper already exists for arg `vc`, so return the matching
      ///     wrapper instance.
      ///
      if let modalWrapper = RNIModalViewControllerWrapperRegistry.get(
        forViewController: vc
      ) {
        return modalWrapper;
      };
      
      /// B - Wrapper does not exists for arg `vc`, so create a new wrapper
      ///     instance.
      ///
      let newModalWrapper = RNIModalViewControllerWrapper(viewController: vc);
        
      RNIModalViewControllerWrapperRegistry.set(
        forViewController: vc,
        newModalWrapper
      );
      return newModalWrapper;
    }();

    return modalWrapper;
  };
  
  // MARK: - Helpers - Computed Properties
  // -------------------------------------
  
  /// Get the associated `RNIModalViewControllerWrapper` instance for the
  /// current view controller
  ///
  var modalWrapper: RNIModalViewControllerWrapper? {
    RNIModalViewControllerWrapperRegistry.get(forViewController: self);
  };
  
  // MARK: - Helpers - Functions
  // ---------------------------
  
  private func getPresentedModalToNotify(
    _ presentedVC: UIViewController? = nil
  ) -> (any RNIModal)? {
  
    let presentedModal = RNIModalUtilities.getPresentedModal(
      forPresentingViewController: self,
      presentedViewController: presentedVC
    );
    
    return RNIModalFlagsShared.shouldSwizzledViewControllerNotifyAll
      ? presentedModal
      : presentedModal as? RNIModalViewControllerWrapper;
  };
  
  private func registerOrInitialize(
    _ viewControllerToPresent: UIViewController
  ){
    let presentingWrapper = Self.registerIfNeeded(forViewController: self);
    
    presentingWrapper?.modalViewController = viewControllerToPresent;
    presentingWrapper?.presentingViewController = self;
    
    let presentedWrapper =
      Self.registerIfNeeded(forViewController: viewControllerToPresent);
      
    presentedWrapper?.presentingViewController = self;
  };
  
  
  private func notifyOnModalWillDismiss() -> (() -> Void)? {
    guard let presentedModal = self.getPresentedModalToNotify()
    else { return nil };
    
    presentedModal.notifyWillDismiss();
    
    return {
      if presentedModal.computedIsModalInFocus {
        presentedModal.notifyDidPresent();
        
      } else {
        presentedModal.notifyDidDismiss();
      };
    };
  };
  
  // MARK: - Swizzled Functions
  // --------------------------
  
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
    
    self.registerOrInitialize(viewControllerToPresent);
    
    let presentedModal = self.getPresentedModalToNotify(viewControllerToPresent);
    presentedModal?.notifyWillPresent();
    
    // call original impl.
    self._swizzled_present(viewControllerToPresent, animated: flag) {
      #if DEBUG
      print(
          "Log - UIViewController+Swizzling"
        + " - UIViewController._swizzled_present"
        + " - completion invoked"
      );
      #endif
      
      presentedModal?.notifyDidPresent();
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
    
    let notifyOnModalDidDismiss = self.notifyOnModalWillDismiss();
    
    // call original impl.
    self._swizzled_dismiss(animated: flag) {
      #if DEBUG
      print(
          "Log - UIViewController+Swizzling"
        + " - UIViewController._swizzled_dismiss"
        + " - completion invoked"
      );
      #endif
      
      notifyOnModalDidDismiss?();
      completion?();
    };
  };
};

// MARK: - Extensions - Helpers
// ----------------------------

fileprivate extension RNIModalPresentationNotifying where Self: RNIModal {
  func notifyWillPresent() {
    guard let delegate = modalPresentationNotificationDelegate else { return };
    delegate.notifyOnModalWillShow(sender: self);
  };
  
  func notifyDidPresent(){
    guard let delegate = modalPresentationNotificationDelegate else { return };
    delegate.notifyOnModalDidShow(sender: self);
  };
  
  func notifyWillDismiss(){
    guard let delegate = modalPresentationNotificationDelegate else { return };
    delegate.notifyOnModalWillHide(sender: self);
  };
  
  func notifyDidDismiss(){
    guard let delegate = modalPresentationNotificationDelegate else { return };
    delegate.notifyOnModalDidHide(sender: self);
  };
};
