//
//  ModalEventsManager.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/2/24.
//

import UIKit
import DGSwiftUtilities


public final class ModalEventsManager {
  
  // MARK: - Properties
  // ------------------
  
  public weak var window: UIWindow?;
  private(set) public var modalRegistry: ModalRegistry = .init();
  
  // MARK: - Init
  // ------------
  
  public init(withWindow window: UIWindow){
    self.window = window;
  };
  
  func registerModalIfNeeded(
    _ modalVC: UIViewController,
    isAboutToBePresented: Bool
  ){
    let window =
         self.window
      ?? modalVC.view.window
      ?? UIApplication.shared.activeWindow;
    
    guard let window = window else {
      return;
    };
    
    if self.window == nil {
      self.window = window;
    };
    
    let currentModalLevel = window.currentModalLevel ?? -1;
    
    let nextModalFocusIndex = isAboutToBePresented
      ? currentModalLevel + 1
      : modalVC.modalLevel ?? -1;
    
    self.modalRegistry.registerModalIfNeeded(
      modalVC,
      modalFocusIndex: nextModalFocusIndex
    );
  };
  
  // MARK: - Methods Invoked Via Swizzling
  // -------------------------------------
  
  public func notifyOnModalWillPresent(
    forViewController modalVC: UIViewController,
    targetWindow: UIWindow?
  ){
    
    guard let targetWindow = targetWindow else {
      return
    };
    
    let eventManager =
      ModalEventsManagerRegistry.shared.getManager(forWindow: targetWindow);
  
    eventManager.registerModalIfNeeded(
      modalVC,
      isAboutToBePresented: true
    );
    
    let modalEntries = eventManager.modalRegistry.getEntriesGrouped();
    
    modalEntries.topMostModal!.setModalFocusState(.focusing);
    modalEntries.secondTopMostModal?.setModalFocusState(.blurring);
    
    modalEntries.otherModals?.forEach {
      $0.setModalFocusState(.blurred);
    };
  };
  
  public func notifyOnModalDidPresent(
    forViewController modalVC: UIViewController,
    targetWindow: UIWindow?
  ){
    guard let targetWindow = targetWindow else {
      return
    };
    
    let eventManager =
      ModalEventsManagerRegistry.shared.getManager(forWindow: targetWindow);
      
    let modalEntries = eventManager.modalRegistry.getEntriesGrouped();
      
    modalEntries.topMostModal!.setModalFocusState(.focused);
    modalEntries.secondTopMostModal?.setModalFocusState(.blurred);
    
    modalEntries.otherModals?.forEach {
      $0.setModalFocusState(.blurred);
    };
  };
  
  public func notifyOnModalWillDismiss(
    forViewController modalVC: UIViewController,
    targetWindow: UIWindow?
  ){
    guard let targetWindow = targetWindow else {
      return
    };
    
    let eventManager =
      ModalEventsManagerRegistry.shared.getManager(forWindow: targetWindow);
      
    let modalEntries = eventManager.modalRegistry.getEntriesGrouped();
      
    modalEntries.topMostModal!.setModalFocusState(.blurring);
    modalEntries.secondTopMostModal?.setModalFocusState(.focusing);
    
    modalEntries.otherModals?.forEach {
      $0.setModalFocusState(.blurred);
    };
  };
  
  public func notifyOnModalDidDismiss(
    forViewController modalVC: UIViewController,
    targetWindow: UIWindow?
  ){
    guard let targetWindow = targetWindow else {
      return
    };
    
    let didDismiss =
         modalVC.view.window == nil
      || !modalVC.isPresentedAsModal;
      
    guard didDismiss else {
      return;
    };
    
    let eventManager =
      ModalEventsManagerRegistry.shared.getManager(forWindow: targetWindow);
      
    let modalEntries = eventManager.modalRegistry.getEntriesGrouped();
      
    modalEntries.topMostModal!.setModalFocusState(.blurred);
    modalEntries.secondTopMostModal?.setModalFocusState(.focused);
    
    modalEntries.otherModals?.forEach {
      $0.setModalFocusState(.blurred);
    };
    
    eventManager.modalRegistry.removeEntry(forViewController: modalVC);
  };
};

