//
//  ModalViewControllerMetrics.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import Foundation
import DGSwiftUtilities


public struct ModalViewControllerMetrics: Encodable {
  
  public var isBeingDismissed: Bool;
  public var isBeingPresented: Bool;
  public var isPresentedAsModal: Bool;
  
  public var modalLevel: Int;
  public var topmostModalLevel: Int;
  public var isTopMostModal: Bool;
  
  public var hasPanGesture: Bool;
  public var isPanGestureEnabled: Bool;
  
  public var modalPresentationStyle: String;
  public var isUsingSheetPresentationController: Bool;
  
  public init(viewController modalVC: UIViewController){
    
    self.isBeingDismissed = modalVC.isBeingDismissed
    self.isBeingPresented = modalVC.isBeingPresented
    self.isPresentedAsModal = modalVC.isPresentedAsModal;
    
    self.modalLevel = modalVC.modalLevel ?? -1;
    self.topmostModalLevel = modalVC.topmostModalLevel ?? -1;
    self.isTopMostModal = modalVC.isTopMostModal;
    
    let modalGesture = modalVC.closestSheetPanGesture;
    self.hasPanGesture = modalGesture != nil;
    self.isPanGestureEnabled = modalGesture?.isEnabled ?? false;
    
    self.modalPresentationStyle = modalVC.modalPresentationStyle.caseString;
    
    self.isUsingSheetPresentationController =
      modalVC.isUsingSheetPresentationController;
  };
};
