//
//  RNIModalManager.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/9/23.
//

import Foundation

public let RNIModalManagerShared = RNIModalManager.sharedInstance;


/// Archived/Old Notes
/// * `Note:2023-04-07-03-22-48`
/// * `Note:2023-03-30-19-36-33`
///
public class RNIModalManager {
  
  // MARK: - Static Properties
  // -------------------------
  
  public static let sharedInstance = RNIModalManager();
  
  // MARK: - Properties
  // ------------------
  
  private(set) public var modalInstanceDict =
    RNIWeakDictionary<String, any RNIModal>();
  
  private(set) public var windowToCurrentModalIndexMap:
    Dictionary<String, Int> = [:];
  
  // MARK: - Properties - Computed
  // -----------------------------
  
  public var modalInstances: [any RNIModal] {
    self.modalInstanceDict.dict.compactMap {
      $0.value.synthesizedRef;
    };
  };
  
  public var presentedModals: [any RNIModal] {
    self.modalInstances.compactMap {
      $0.modalPresentationState.isPresented ? $0 : nil;
    };
  };
  
  // MARK: - Methods
  // ---------------
  
  public func register(modal: any RNIModal) {
    modal.modalIndex = -1;
    modal.modalIndexPrev = -1;
    
    modal.modalPresentationNotificationDelegate = self;
    
    self.modalInstanceDict[modal.modalNativeID] = modal;
  };
  
  public func isRegistered(modal: any RNIModal) -> Bool {
    self.modalInstances.contains {
      $0.modalNativeID == modal.modalNativeID;
    };
  };
  
  public func isRegistered(viewController: UIViewController) -> Bool {
    self.modalInstances.contains {
      $0.presentingViewController === viewController
    };
  };
  
  public func getModalInstance(
    forPresentingViewController viewController: UIViewController
  ) -> (any RNIModal)? {
    self.modalInstances.first {
      $0.presentingViewController === viewController;
    };
  };
  
  public func getModalInstance(
    forPresentedViewController viewController: UIViewController
  ) -> (any RNIModal)? {
    let presentingModal = self.modalInstances.first {
      $0.modalViewController === viewController;
    };
    
    guard let presentingVC = presentingModal?.modalViewController
    else { return nil };
    
    return self.getModalInstance(forPresentingViewController: presentingVC);
  };
  
  public func getModalInstances(
    forWindow window: UIWindow
  ) -> [any RNIModal] {
    
    return self.modalInstances.filter {
      $0.window === window
    };
  };
};

// MARK: RNIModalPresentationNotifiable
// ------------------------------------

/// The modal instances will notify the manager when they're about to show/hide
/// a modal.
///
extension RNIModalManager: RNIModalPresentationNotifiable {
  
  public func notifyOnModalWillShow(sender: any RNIModal) {
    guard let senderWindow = sender.window else {
      #if DEBUG
      print(
          "Error - RNIModalManager.notifyOnModalWillShow"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - Unable to send event because sender.window is nil"
      );
      #endif
      return;
    };
    
    let windowData = RNIModalWindowMapShared.get(forWindow: senderWindow);
    guard windowData.nextModalToFocus !== sender else {
      #if DEBUG
      let nextModalToFocus = windowData.nextModalToFocus!;
      print(
          "Error - RNIModalManager.notifyOnModalWillShow"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - nextModalToFocus.modalNativeID: \(nextModalToFocus.modalNativeID)"
        + " - possible multiple invokation"
        + " - sender is already about to be in focus"
      );
      #endif
      return;
    };
    
    let purgeCache =
      RNIPresentedVCListCache.beginCaching(forWindow: senderWindow);
    
    /// `Note:2023-04-10-20-47-52`
    /// * The sender will already be in `presentedModalList` despite it being
    ///   not fully presented yet.
    ///
    let presentedModalList =
      RNIModalUtilities.getPresentedModals(forWindow: senderWindow);
    
    #if DEBUG
    if windowData.nextModalToFocus != nil {
      print(
          "Warning - RNIModalManager.notifyOnModalWillShow"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - nextModalToFocus is not nil"
        + " - a different modal is about to be focused"
      );
    };
    #endif
    
    windowData.set(nextModalToFocus: sender);
    
    #if DEBUG
    print(
        "Log - RNIModalManager.notifyOnModalWillShow"
      + " - arg sender.modalNativeID: \(sender.modalNativeID)"
      + " - prevModalIndex: \(windowData.modalIndexPrev)"
      + " - windowData.modalIndexNext: \(windowData.modalIndexNext_)"
      + " - sender.modalIndexPrev: \(sender.modalIndexPrev!)"
      + " - sender.modalIndex: \(sender.modalIndex!)"
      + " - presentedModalList.count: \(presentedModalList.count)"
    );
    #endif
    
    sender.modalFocusState.set(state: .FOCUSING);
    sender.modalPresentationState.set(state: .PRESENTING_UNKNOWN);
    
    sender.onModalWillFocusNotification(sender: sender);
    
    presentedModalList.forEach {
      guard $0 !== sender,
            $0.modalFocusState.state.isFocusedOrFocusing ||
              $0.modalFocusState.state.isBlurring
      else { return };
      
      #if DEBUG
      print(
          "Log - RNIModalManager.notifyOnModalWillShow"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - notify BLURRING"
        + " - for modal.modalNativeID:\($0.modalNativeID)"
        + " - for modal.modalIndex:\($0.modalIndex ?? -1)"
      );
      #endif
      
      $0.modalFocusState.set(state: .BLURRING);
      $0.onModalWillBlurNotification(sender: sender);
    };
    
    if let modalToBlur = presentedModalList.secondToLast {
      windowData.nextModalToBlur = modalToBlur;
    };
    
    purgeCache();
  };
  
  public func notifyOnModalDidShow(sender: any RNIModal) {
    guard let senderWindow = sender.window else {
      #if DEBUG
      print(
          "Error - RNIModalManager.notifyOnModalDidShow"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - Unable to send event because sender.window is nil"
      );
      #endif
      return;
    };
    
    let windowData = RNIModalWindowMapShared.get(forWindow: senderWindow);
    let nextModalToFocus = windowData.nextModalToFocus
    
    if nextModalToFocus == nil {
      #if DEBUG
      print(
          "Error - RNIModalManager.notifyOnModalDidShow"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - nextModalToFocus: nil"
        + " - possible notifyOnModalWillShow not invoked for sender"
      );
      #endif
    };
    
    #if DEBUG
    if nextModalToFocus !== sender {
      print(
          "Warning - RNIModalManager.notifyOnModalDidShow"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - nextModalToFocus.modalNativeID: \(nextModalToFocus?.modalNativeID ?? "N/A")"
        + " - nextModalToFocus !== sender"
        + " - a different modal is about to focused"
      );
    };
    #endif
    
    let purgeCache =
      RNIPresentedVCListCache.beginCaching(forWindow: senderWindow);
    
    let presentedModalList =
      RNIModalUtilities.getPresentedModals(forWindow: senderWindow);
  
    windowData.apply(forFocusedModal: sender);
    
    #if DEBUG
    print(
        "Log - RNIModalManager.notifyOnModalDidShow"
      + " - arg sender.modalNativeID: \(sender.modalNativeID)"
      + " - sender.modalIndexPrev: \(sender.modalIndexPrev!)"
      + " - sender.modalIndex: \(sender.modalIndex!)"
    );
    #endif
        
    sender.modalFocusState.set(state: .FOCUSED);
    sender.modalPresentationState.set(state: .PRESENTED_UNKNOWN);
    
    sender.onModalDidFocusNotification(sender: sender);
    
    presentedModalList.forEach {
      guard $0 !== sender,
            $0.modalFocusState.state.isBlurring
      else { return };
      
      #if DEBUG
      print(
          "Log - RNIModalManager.notifyOnModalDidShow"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - notify BLURRED"
        + " - for modal.modalNativeID:\($0.modalNativeID)"
        + " - for modal.modalIndex:\($0.modalIndex ?? -1)"
      );
      #endif
      
      $0.modalFocusState.set(state: .BLURRED);
      $0.onModalDidBlurNotification(sender: sender);
    };
    
    // Reset
    windowData.nextModalToBlur = nil;
    purgeCache();
  };
  
  public func notifyOnModalWillHide(sender: any RNIModal) {
    guard let senderWindow = sender.window else {
      #if DEBUG
      print(
          "Error - RNIModalManager.notifyOnModalWillHide"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - Unable to send event because sender.window is nil"
      );
      #endif
      return;
    };
    
    let windowData = RNIModalWindowMapShared.get(forWindow: senderWindow);
    guard windowData.nextModalToBlur !== sender else {
      #if DEBUG
      let nextModalToBlur = windowData.nextModalToBlur!;
      print(
          "Error - RNIModalManager.notifyOnModalWillHide"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - nextModalToBlur.modalNativeID: \(nextModalToBlur.modalNativeID)"
        + " - possible multiple invokation"
        + " - sender is already about to be blurred"
      );
      #endif
      return;
    };
    
    #if DEBUG
    if windowData.nextModalToBlur != nil {
      print(
          "Warning - RNIModalManager.notifyOnModalWillHide"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - nextModalToBlur is not nil"
        + " - a different modal is about to blur"
      );
    };
    #endif
    
    let purgeCache =
      RNIPresentedVCListCache.beginCaching(forWindow: senderWindow);
    
    let presentedModalList =
      RNIModalUtilities.getPresentedModals(forWindow: senderWindow);
    
    windowData.set(nextModalToBlur: sender);
    
    #if DEBUG
    print(
        "Log - RNIModalManager.notifyOnModalWillHide"
      + " - arg sender.modalNativeID: \(sender.modalNativeID)"
      + " - prevModalIndex: \(windowData.modalIndexPrev)"
      + " - windowData.modalIndexNext: \(windowData.modalIndexNext_)"
      + " - sender.modalIndexPrev: \(sender.modalIndexPrev!)"
      + " - sender.modalIndex: \(sender.modalIndex!)"
    );
    #endif
    
    sender.modalFocusState.set(state: .BLURRING);
    sender.modalPresentationState.set(state: .DISMISSING_UNKNOWN);
  
    sender.onModalWillBlurNotification(sender: sender);
    
    guard let modalToFocus = presentedModalList.secondToLast else {
      purgeCache();
      return;
    };
    
    #if DEBUG
    print(
        "Log - RNIModalManager.notifyOnModalWillHide"
      + " - arg sender.modalNativeID: \(sender.modalNativeID)"
      + " - notify FOCUSING"
      + " - for modalToFocus.modalNativeID:\(modalToFocus.modalNativeID)"
      + " - for modalToFocus.modalIndex:\(modalToFocus.modalIndex ?? -1)"
    );
    #endif
    
    modalToFocus.modalFocusState.set(state: .FOCUSING);
    modalToFocus.onModalWillFocusNotification(sender: sender);
    
    windowData.nextModalToFocus = modalToFocus;
    purgeCache();
  };
  
  public func notifyOnModalDidHide(sender: any RNIModal) {
    guard let senderWindow = sender.window else {
      #if DEBUG
      print(
          "Error - RNIModalManager.notifyOnModalDidHide"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - Unable to send event because sender.window is nil"
      );
      #endif
      return;
    };
    
    let windowData = RNIModalWindowMapShared.get(forWindow: senderWindow);
    guard let nextModalToBlur = windowData.nextModalToBlur else {
      #if DEBUG
      print(
          "Error - RNIModalManager.notifyOnModalDidHide"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - nextModalToBlur: nil"
        + " - possible notifyOnModalWillHide not invoked for sender"
      );
      #endif
      return;
    };
    
    #if DEBUG
    if nextModalToBlur !== sender {
      print(
          "Warning - RNIModalManager.notifyOnModalDidHide"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - nextModalToBlur.modalNativeID: \(nextModalToBlur.modalNativeID)"
        + " - nextModalToBlur !== sender"
        + " - a different modal is about to be blurred"
      );
    };
    #endif
    
    let purgeCache =
      RNIPresentedVCListCache.beginCaching(forWindow: senderWindow);
    
    windowData.apply(forBlurredModal: sender);
    
    #if DEBUG
    print(
        "Log - RNIModalManager.notifyOnModalDidHide"
      + " - arg sender.modalNativeID: \(sender.modalNativeID)"
      + " - sender.modalIndexPrev: \(sender.modalIndexPrev!)"
      + " - sender.modalIndex: \(sender.modalIndex!)"
    );
    #endif
        
    sender.modalFocusState.set(state: .BLURRED);
    sender.modalPresentationState.set(state: .DISMISSED);
    
    sender.onModalDidBlurNotification(sender: sender);
    
    guard let modalToFocus = windowData.nextModalToFocus else { return };
    
    #if DEBUG
    print(
        "Log - RNIModalManager.notifyOnModalDidHide"
      + " - arg sender.modalNativeID: \(sender.modalNativeID)"
      + " - notify FOCUSED"
      + " - for modal.modalNativeID:\(modalToFocus.modalNativeID)"
      + " - for modal.modalIndex:\(modalToFocus.modalIndex ?? -1)"
    );
    #endif
      
    modalToFocus.modalFocusState.set(state: .FOCUSED);
    modalToFocus.onModalDidFocusNotification(sender: sender);
    
    // reset
    windowData.nextModalToFocus = nil;
    purgeCache();
  };
};
