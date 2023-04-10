//
//  RNIModalManager.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/9/23.
//

import Foundation

public let RNIModalManagerShared = RNIModalManager.sharedInstance;

/// `Note:2023-04-07-03-22-48` - Archived/Old
///
/// * Manually incrementing and decrementing the `modalIndex` is fragile.
///
/// * For example:
///   * 1 -If multiple blur/focus events were to fire consecutively, the
///     `modalIndex` might be wrong.
///
///   * 2 - If a modal presented/dismissed w/o notifying `RNIModalManager`,
///     the `modalIndex` will be stale.
///
///   * 3 - If a modal was about to be blurred (i.e. "will blur"), but was
///     cancelled halfway (i.e. "did blur" not invoked), and the modal regained
///     focus again (i.e. invoking "will focus" + "did focus").
///
///   * 4 - Invoking "will blur", or "will focus" but not invoking the invoking
///     the corresponding "did blur", and "did focus" methods.
///
///  * When a modal is hidden, it will trigger a "focus" event for the new
///    topmost modal; subsequently, when a modal is shown, it will trigger a
///    "blur" event for the previous topmost modal.
///
///    * This assumes that the "modal manager" can only be notified of a pair of
///      "focus", or "blur" at a given time, per window instance...
///
///    * E.g. "will focus" -> "did focus", "will blur" -> "did blur".
///
///    * However, there might be an instance where multiple modals may be
///      hidden at the same time...
///
///    * E.g. "will blur 1", "will blur 2", "did blur 1", "did blur 2", etc.
///
///    * When multiple "blur" events are firing, the modal with the lowest
///      index should take priority.
///
///    * Subsequently, when multiple "focus" events are firing, the modal with
///      the highest modal index should take priority.
///
///    * Additionally, when a "blur", or "focus" event is firing at the same
///      time...
///
///    * E.g. "will blur 1", "will focus 2", "did blur 1", "did focus 2", etc.
///
///    * The "focus" event should take priority, (assuming that the "focus"
///      event was fired for the topmost modal).
///
///
/// `Note:2023-03-30-19-36-33` - Archived/Old
///
/// * This assumes that the app is using a single window, and all the modals are
///   being presented on that window, as a chain of view controllers.
///
/// * E.g. "window 1" presents a modal, and "window 2" presents a modal
///
///   * Those 2 modals are not related to one another, and their respective
///     modal index should both be 1, since they are the 1st modal presented on
///     their respective window instances.
///
///   * Instead their modal indexes are 1, and 2, respectively.
///
///   * This also means the internal `currentModalIndex` state, and any other
///     logic that relies on it will be wrong too.
///
/// * And since there is no distinction on which modal belongs to a particular
///   window, all the modal instances in the app will get notified when a event
///   occurs.
///
/// * This can be fixed by keeping a separate `currentModalIndex` for each
///   window instance, and only updating it based on the modal's associated
///   window instance.
///
/// * This can also be fixed by programmatically determining the modal's
///   `modalIndex`.
///
public class RNIModalManager {
  
  // MARK: - Static Properties
  // -------------------------
  
  public static let sharedInstance = RNIModalManager();
  
  // MARK: - Static Functions
  // ------------------------
  
  /// TODO:2023-03-20-21-29-36 - Move to `RNIUtilities`
  public static func getWindows() -> [UIWindow] {
    var windows: [UIWindow] = [];
    
    #if swift(>=5.5)
    // Version: Swift 5.5 and newer - iOS 15 and newer
    guard #available(iOS 13.0, *) else { return [] };
    
    for scene in UIApplication.shared.connectedScenes {
      guard let windowScene = scene as? UIWindowScene else { continue };
      windows += windowScene.windows;
    };
    
    #elseif swift(>=5)
    // Version: Swift 5.4 and below - iOS 14.5 and below
    // Note: 'windows' was deprecated in iOS 15.0+
    
    // first element is the "key window"
    if let keyWindow =
        UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
      
      windows.append(keyWindow);
    };
    
    UIApplication.shared.windows.forEach {
      // skip if already added
      guard !windows.contains($0) else { return };
      windows.append($0);
    };

    #elseif swift(>=4)
    // Version: Swift 4 and below - iOS 12.4 and below
    // Note: `keyWindow` was deprecated in iOS 13.0+
    
    // first element is the "key window"
    if let keyWindow = UIApplication.shared.keyWindow {
      windows.append(keyWindow);
    };
    
    UIApplication.shared.windows.forEach {
      // skip if already added
      guard !windows.contains($0) else { return };
      windows.append($0);
    };
    
    #else
    // Version: Swift 3.1 and below - iOS 10.3 and below
    // Note: 'sharedApplication' has been renamed to 'shared'
    guard let appDelegate =
            UIApplication.sharedApplication().delegate as? AppDelegate,
          
          let window = appDelegate.window
    else { return [] };
    
    return windows.append(window);
    #endif
    
    return windows;
  };
  
  /// TODO:2023-03-20-21-29-36 - Move to `RNIUtilities`
  public static func getRootViewController(
    for window: UIWindow? = nil
  ) -> UIViewController? {
    
    if let window = window {
      return window.rootViewController;
    };
    
    return Self.getWindows().first?.rootViewController;
  };
  
  /// TODO:2023-03-20-21-29-36 - Move to `RNIUtilities`
  public static func getPresentedViewControllers(
    for window: UIWindow? = nil
  ) -> [UIViewController] {
    guard let rootVC = Self.getRootViewController(for: window) else {
      #if DEBUG
      print(
          "Error - RNIModalManager.getTopMostPresentedVC"
        + " - arg window isNil: '\(window == nil)'"
        + " - Could not get root view controller"
      );
      #endif
      return [];
    };
    
    var presentedVCList: [UIViewController] = [rootVC];
    
    // climb the vc hierarchy to find the topmost presented vc
    while true {
      guard let topVC = presentedVCList.last,
            let presentedVC = topVC.presentedViewController
      else { break };
      
      presentedVCList.append(presentedVC);
    };
    
    return presentedVCList;
  };
  
  /// TODO:2023-03-20-21-29-36 - Move to `RNIUtilities`
  public static func getTopmostPresentedViewController(
    for window: UIWindow? = nil
  ) -> UIViewController? {
    return Self.getPresentedViewControllers(for: window).last;
  };
  
  static func getPresentedModals(forWindow window: UIWindow) -> [any RNIModal] {
    let vcItems = Self.getPresentedViewControllers(for: window);
    
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
      RNIModalManager.getPresentedViewControllers(for: window);
    
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
  
  // MARK: - Properties
  // ------------------
  
  private(set) public var modalInstanceDict =
    RNIWeakDictionary<UUID, any RNIModal>();
  
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
    
    self.modalInstanceDict[modal.synthesizedUUID] = modal;
  };
  
  public func getModalInstances(forWindow window: UIWindow) -> [any RNIModal] {
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
    
    /// `Note:2023-04-10-20-47-52`
    /// * The sender will already be in `presentedModalList` despite it being
    ///   not fully presented yet.
    ///
    let presentedModalList = Self.getPresentedModals(forWindow: senderWindow);
    
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
            $0.modalFocusState.state.isFocusedOrFocusing
      else { return };
      
      $0.modalFocusState.set(state: .BLURRING);
      $0.onModalWillBlurNotification(sender: sender);
    };
    
    if let modalToBlur = presentedModalList.secondToLast {
      windowData.nextModalToBlur = modalToBlur;
    };
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
    guard let nextModalToFocus = windowData.nextModalToFocus else {
      #if DEBUG
      print(
          "Error - RNIModalManager.notifyOnModalDidShow"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - nextModalToFocus: nil"
        + " - possible notifyOnModalWillShow not invoked for sender"
      );
      #endif
      return;
    };
    
    #if DEBUG
    if nextModalToFocus !== sender {
      print(
          "Warning - RNIModalManager.notifyOnModalDidShow"
        + " - arg sender.modalNativeID: \(sender.modalNativeID)"
        + " - nextModalToFocus.modalNativeID: \(nextModalToFocus.modalNativeID)"
        + " - nextModalToFocus !== sender"
        + " - a different modal is about to focused"
      );
    };
    #endif
    
    let presentedModalList = Self.getPresentedModals(forWindow: senderWindow);
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
      
      $0.modalFocusState.set(state: .BLURRED);
      $0.onModalDidBlurNotification(sender: sender);
    };
    
    // Reset
    windowData.nextModalToBlur = nil;
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
    
    let presentedModalList = Self.getPresentedModals(forWindow: senderWindow);
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
    
    guard let modalToFocus = presentedModalList.secondToLast else { return };
    
    modalToFocus.modalFocusState.set(state: .FOCUSING);
    modalToFocus.onModalWillFocusNotification(sender: sender);
    
    windowData.nextModalToFocus = modalToFocus;
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
    
    let presentedModalList = Self.getPresentedModals(forWindow: senderWindow);
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
    
    presentedModalList.forEach {
      guard $0 !== sender,
            $0.modalFocusState.state.isTransitioning
      else { return };
      
      $0.modalFocusState.set(state: .FOCUSED);
      $0.onModalDidFocusNotification(sender: sender);
    };
    
    // reset
    windowData.nextModalToFocus = nil;
  };
};
