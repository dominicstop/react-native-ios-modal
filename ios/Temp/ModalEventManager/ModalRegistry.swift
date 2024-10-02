//
//  ModalRegistry.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/2/24.
//

import UIKit


public class ModalRegistry {
  
  public typealias ModalRegistry = Dictionary<String, ModalRegistryEntry>;
  
  public var registry: ModalRegistry = [:];
  
  public func registerModalIfNeeded(
    _ modalVC: UIViewController,
    modalFocusIndex: Int
  ){
    let match = self.registry[modalVC.synthesizedStringID];

    let isRegistered = match != nil;
    let shouldOverwrite = match?.isValidEntry ?? false;
    
    let shouldRegister = !isRegistered || shouldOverwrite;
    guard shouldRegister else {
      return;
    };
    
    self.registry[modalVC.synthesizedStringID] = .init(
      viewController: modalVC,
      modalFocusIndex: modalFocusIndex
    );
  };
  
  public func getEntry(for modalVC: UIViewController) -> ModalRegistryEntry? {
    self.registry[modalVC.synthesizedStringID];
  };
  
  public func removeEntry(forViewController modalVC: UIViewController){
    self.registry.removeValue(forKey: modalVC.synthesizedStringID);
  };
  
  public func removeEntry(forEntry entry: ModalRegistryEntry){
    self.registry.removeValue(forKey: entry.modalInstanceID);
  };
  
  @discardableResult
  public func setModalFocusState(
    for modalVC: UIViewController,
    withModalFocusState modalFocusStateNext: ModalFocusState
  ) -> ModalRegistryEntry? {
    guard let match = self.getEntry(for: modalVC) else {
      return nil;
    };
    
    match.setModalFocusState(modalFocusStateNext);
    return match;
  };
  
  public func getRegistry() -> ModalRegistry {
    let filtered = self.registry.filter {
      $1.isValidEntry
    };
    
    self.registry = filtered;
    return filtered;
  };
  
  public func getEntriesSorted() -> [ModalRegistryEntry] {
    self.registry.values.sorted {
      $0.modalFocusIndex > $1.modalFocusIndex;
    };
  };
  
  public func getEntriesGrouped() -> (
    topMostModal: ModalRegistryEntry?,
    secondTopMostModal: ModalRegistryEntry?,
    otherModals: [ModalRegistryEntry]?
  ) {
    var entriesSorted = self.getEntriesSorted();
    
    return (
      topMostModal: entriesSorted.popLast(),
      secondTopMostModal: entriesSorted.popLast(),
      otherModals: entriesSorted
    );
  };
};

