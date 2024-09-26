//
//  UIViewController+ModalHelpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import Foundation
import DGSwiftUtilities


extension UIViewController {

  // MARK: - Embedded Types
  // ----------------------
  
  fileprivate enum PrivateSymbolString: String, HashedStringDecodable {
    
    /// `UIDropShadowView`
    case classNameForDropShadowView;
    
    var encodedString: String {
      switch self {
        case .classNameForDropShadowView:
          return "VUlEcm9wU2hhZG93Vmlldw==";
      };
    };
  };
  
  // MARK: - Computed Properties
  // ---------------------------

  public var modalPanGestureViaPresentationController: UIPanGestureRecognizer? {
    guard let presentationController = self.presentationController,
          let presentedView = presentationController.presentedView,
          let gestureRecognizers = presentedView.gestureRecognizers
    else {
      return nil;
    };
    
    let match = gestureRecognizers.first {
      $0 is UIPanGestureRecognizer;
    };
    
    guard let match = match as? UIPanGestureRecognizer else {
      return nil;
    };
    
    return match;
  };
  
  public var modalPanGestureViaClimbingParentViews: UIPanGestureRecognizer? {
    guard let targetClassName = PrivateSymbolString.classNameForDropShadowView.decodedString else {
      return nil;
    };
    
    let matchingAncestorView = self.view.recursivelyFindParentView {
         $0.className == targetClassName
      && $0.gestureRecognizers?.count ?? 0 > 0;
    };
    
    guard let matchingAncestorView = matchingAncestorView,
          let gestureRecognizers = matchingAncestorView.gestureRecognizers
    else {
      return nil;
    };
    
    let matchingGestureRecognizer = gestureRecognizers.first {
      $0 is UIPanGestureRecognizer;
    };
    
    guard let matchingGestureRecognizer = matchingGestureRecognizer as? UIPanGestureRecognizer else {
      return nil;
    };
    
    return matchingGestureRecognizer;
  };
  
  public var modalPanGesture: UIPanGestureRecognizer? {
       self.modalPanGestureViaPresentationController
    ?? self.modalPanGestureViaClimbingParentViews;
  };
  
  public var modalRootScrollViewGestureRecognizer: UIPanGestureRecognizer? {
    guard let scrollView = self.view.recursivelyFindSubview(whereType: UIScrollView.self),
          let scrollViewGestures = scrollView.gestureRecognizers
    else {
      return nil;
    };
    
    return scrollViewGestures.first(
      whereType: UIPanGestureRecognizer.self
    );
  };
  
  public var modalPositionAnimator: CAAnimation? {
    guard self.isPresentedAsModal,
          let presentationController = self.presentationController,
          let presentedView = presentationController.presentedView
    else {
      return nil;
    };
    
    return presentedView.layer.animation(forKey: "position");
  };
};
