//
//  RNIModalSheetViewDelegate.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 6/6/24.
//

import UIKit
import DGSwiftUtilities
import react_native_ios_utilities


@objc(RNIModalSheetViewDelegate)
public final class RNIModalSheetViewDelegate: UIView, RNIContentView {

  enum NativeIDKey: String {
    case mainSheetContent;
  };
  
  public enum Events: String, CaseIterable {
    case onModalWillPresent;
    case onModalDidPresent;
    
    case onModalWillDismiss;
    case onModalDidDismiss;
    
    case onModalWillShow;
    case onModalDidShow;
    
    case onModalWillHide;
    case onModalDidHide;
    
    case onModalFocusChange;
    
    case onModalSheetWillDismissViaGesture;
    case onModalSheetDidDismissViaGesture;
    case onModalSheetDidAttemptToDismissViaGesture;
    
    case onModalSheetStateWillChange;
    case onModalSheetStateDidChange;
  };
  
  public static var propKeyPathMap: PropKeyPathMap {
    return [
      "reactChildrenCount": \.reactChildrenCountProp,
      "shouldAllowDismissalViaGesture": \.shouldAllowDismissalViaGesture,
    ];
  };
  
  // MARK: Properties
  // ----------------
  
  public var detachedModalContentParentViews: [RNIContentViewParentDelegate] = [];
  
  public var modalSheetController: RNIModalSheetViewController?;
  public var sheetMainContentParentView: RNIContentViewParentDelegate?;
  
  // MARK: - Properties - RNIContentViewDelegate
  // -------------------------------------------
  
  public weak var parentReactView: RNIContentViewParentDelegate?;
  
  // MARK: Properties - Props
  // ------------------------
  
  public var reactProps: NSDictionary = [:];
  
  public var reactChildrenCount: Int = 0;
  var reactChildrenCountProp: NSNumber = 0 {
    willSet {
      let oldCount = self.reactChildrenCount;
      let newCount = newValue.intValue;
      
      guard oldCount != newCount else {
        return;
      };
      
      self.reactChildrenCount = newCount;
      // TODO: Add code for verifying child count before presenting
    }
  };
  
  public var shouldAllowDismissalViaGesture: Bool = true {
    willSet {
      self.modalSheetController?.shouldAllowDismissal = newValue;
    }
  };
  
  // MARK: Init
  // ----------
  
  public override init(frame: CGRect) {
    super.init(frame: frame);
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  }
  
  // MARK: - Methods
  // ---------------
  
  func createModalController() throws -> RNIModalSheetViewController {
    guard let mainSheetContentParent = self.sheetMainContentParentView else {
      throw RNIUtilitiesError(errorCode: .unexpectedNilValue);
    };
  
    let modalVC = RNIModalSheetViewController();
    self.modalSheetController = modalVC;
    
    modalVC.mainSheetContentParent = mainSheetContentParent;
    modalVC.view.backgroundColor = .systemBackground;
    modalVC.shouldAllowDismissal = self.shouldAllowDismissalViaGesture;
    
    modalVC.lifecycleEventDelegates.add(self);
    modalVC.modalLifecycleEventDelegates.add(self);
    modalVC.sheetPresentationStateMachine.eventDelegates.add(self);
    modalVC.modalFocusEventDelegates.add(self);
    
    return modalVC;
  };
  
  func discardCurrentModalControllerIfNeeded(){
    guard let modalVC = self.modalSheetController,
          !modalVC.isPresentedAsModal
    else {
      return;
    };
    
    self.modalSheetController = nil;
  };
};

// MARK: - RNIModalSheetViewDelegate+RNIContentViewDelegate
// --------------------------------------------------------

extension RNIModalSheetViewDelegate: RNIContentViewDelegate {

  public typealias KeyPathRoot = RNIModalSheetViewDelegate;

  // MARK: Paper + Fabric
  // --------------------
  
  public func notifyOnInit(sender: RNIContentViewParentDelegate) {
    ModalEventsManagerRegistry.shared.swizzleIfNeeded();
  }
    
  public func notifyOnMountChildComponentView(
    sender: RNIContentViewParentDelegate,
    childComponentView: UIView,
    index: NSInteger,
    superBlock: () -> Void
  ) {
  
    defer {
      childComponentView.removeFromSuperview();
    };
  
    guard let reactView = childComponentView as? RNIContentViewParentDelegate,
          reactView.contentDelegate is RNIWrapperViewContent,
          let nativeID = reactView.reactNativeID,
          let nativeIDKey = NativeIDKey(rawValue: nativeID)
    else {
      return;
    };
    
    defer {
      reactView.attachReactTouchHandler();
      self.detachedModalContentParentViews.append(reactView);
    };
    
    switch nativeIDKey {
      case .mainSheetContent:
        self.sheetMainContentParentView = reactView;
    };
  };
  
  public func notifyOnUnmountChildComponentView(
    sender: RNIContentViewParentDelegate,
    childComponentView: UIView,
    index: NSInteger,
    superBlock: () -> Void
  ) {
    childComponentView.removeFromSuperview();
  }
  
  public func notifyOnViewCommandRequest(
    sender: RNIContentViewParentDelegate,
    forCommandName commandName: String,
    withCommandArguments commandArguments: NSDictionary,
    resolve resolveBlock: (NSDictionary) -> Void,
    reject rejectBlock: (String) -> Void
  ) {
    
    do {
      guard let commandArguments = commandArguments as? Dictionary<String, Any> else {
        throw RNIUtilitiesError(errorCode: .guardCheckFailed);
      };
      
      switch commandName {
        case "presentModal":
          let closestVC =
            self.recursivelyFindNextResponder(withType: UIViewController.self);
            
          guard let closestVC = closestVC else {
            throw RNIUtilitiesError(errorCode: .unexpectedNilValue);
          };

          let isAnimated: Bool = commandArguments.getValueFromDictionary(
            forKey: "isAnimated",
            fallbackValue: true
          );
          
          let modalVC = try self.createModalController();
          closestVC.present(modalVC, animated: isAnimated);
          
          resolveBlock([:]);
          
        case "dismissModal":
          guard let modalSheetController = self.modalSheetController else {
            throw RNIUtilitiesError(errorCode: .unexpectedNilValue);
          };
          
          let isAnimated: Bool = commandArguments.getValueFromDictionary(
            forKey: "isAnimated",
            fallbackValue: true
          );
          
          modalSheetController.dismiss(animated: isAnimated);
          resolveBlock([:]);
          
        case "getModalMetrics":
          guard let modalSheetController = self.modalSheetController else {
            throw RNIUtilitiesError(errorCode: .unexpectedNilValue);
          };
          
          resolveBlock(modalSheetController.baseEventObject as NSDictionary);
        
        default:
          throw RNIUtilitiesError(errorCode: .invalidValue);
      };
    
    } catch {
      rejectBlock(error.localizedDescription);
    };
  };
  
  // MARK: Fabric Only
  // -----------------
  
  #if RCT_NEW_ARCH_ENABLED
  public func shouldRecycleContentDelegate(
    sender: RNIContentViewParentDelegate
  ) -> Bool {
    return false;
  };
  #endif
};

// MARK: - RNIModalSheetViewDelegate+ViewControllerLifecycleNotifiable
// -------------------------------------------------------------------

extension RNIModalSheetViewDelegate: ViewControllerLifecycleNotifiable {

  public func notifyOnViewWillAppear(
    sender: UIViewController,
    isAnimated: Bool,
    isFirstAppearance: Bool
  ) {
    self.dispatchEvent(
      for: .onModalWillShow,
      withPayload: [
        "isAnimated": isAnimated,
        "isFirstAppearance": isFirstAppearance,
      ]
    );
  };
  
  public func notifyOnViewDidAppear(
    sender: UIViewController,
    isAnimated: Bool,
    isFirstAppearance: Bool
  ) {
    self.dispatchEvent(
      for: .onModalDidShow,
      withPayload: [
        "isAnimated": isAnimated,
        "isFirstAppearance": isFirstAppearance,
      ]
    );
  };
  
  public func notifyOnViewWillDisappear(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    self.dispatchEvent(
      for: .onModalWillHide,
      withPayload: [
        "isAnimated": isAnimated,
      ]
    );
  };
  
  public func notifyOnViewDidDisappear(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    self.dispatchEvent(
      for: .onModalDidHide,
      withPayload: [
        "isAnimated": isAnimated,
      ]
    );
  };
};

// MARK: - RNIModalSheetViewDelegate+ModalViewControllerEventsNotifiable
// ---------------------------------------------------------------------

extension RNIModalSheetViewDelegate: ModalViewControllerEventsNotifiable {
  
  public func notifyOnModalWillPresent(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    self.dispatchEvent(
      for: .onModalWillPresent,
      withPayload: [
        "isAnimated": isAnimated,
      ]
    );
  };
  
  public func notifyOnModalDidPresent(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    self.dispatchEvent(
      for: .onModalDidPresent,
      withPayload: [
        "isAnimated": isAnimated,
      ]
    );
  };
  
  public func notifyOnModalWillDismiss(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    self.dispatchEvent(
      for: .onModalWillDismiss,
      withPayload: [
        "isAnimated": isAnimated,
      ]
    );
  };
  
  public func notifyOnModalDidDismiss(
    sender: UIViewController,
    isAnimated: Bool
  ) {
    self.dispatchEvent(
      for: .onModalDidDismiss,
      withPayload: [
        "isAnimated": isAnimated,
      ]
    );
    
    self.discardCurrentModalControllerIfNeeded();
  };
};

// MARK: - RNIModalSheetViewDelegate+ModalSheetPresentationStateEventsNotifiable
// -----------------------------------------------------------------------------

extension RNIModalSheetViewDelegate: ModalSheetPresentationStateEventsNotifiable {
  
  public func onModalSheetStateWillChange(
    sender: ModalSheetPresentationStateMachine,
    prevState: ModalSheetState?,
    currentState: ModalSheetState,
    nextState: ModalSheetState
  ) {
    var payload: Dictionary<String, Any> = [
      "currentState": currentState.asDictionary,
      "nextState": nextState.asDictionary
    ];
    
    payload.unwrapAndMerge(withOther: [
      "prevState": prevState?.asDictionary
    ]);
    
    self.dispatchEvent(
      for: .onModalSheetStateWillChange,
      withPayload: payload
    );
  };
  
  public func onModalSheetStateDidChange(
    sender: ModalSheetPresentationStateMachine,
    prevState: ModalSheetState?,
    currentState: ModalSheetState
  ) {
    var payload: Dictionary<String, Any> = [
      "currentState": currentState.asDictionary
    ];
    
    payload.unwrapAndMerge(withOther: [
      "prevState": prevState?.asDictionary
    ]);
    
    self.dispatchEvent(
      for: .onModalSheetStateDidChange,
      withPayload: payload
    );
  };
};

// MARK: - RNIModalSheetViewDelegate+ModalSheetViewControllerEventsNotifiable
// --------------------------------------------------------------------------

extension RNIModalSheetViewDelegate: ModalSheetViewControllerEventsNotifiable {
  
  public func notifyOnSheetDidAttemptToDismissViaGesture(
    sender: UIViewController,
    presentationController: UIPresentationController
  ) {
    self.dispatchEvent(
      for: .onModalSheetDidAttemptToDismissViaGesture,
      withPayload: [:]
    );
  };
  
  public func notifyOnSheetDidDismissViaGesture(
    sender: UIViewController,
    presentationController: UIPresentationController
  ) {
    self.dispatchEvent(
      for: .onModalSheetWillDismissViaGesture,
      withPayload: [:]
    );
  };
  
  public func notifyOnSheetWillDismissViaGesture(
    sender: UIViewController,
    presentationController: UIPresentationController
  ) {
    self.dispatchEvent(
      for: .onModalSheetDidDismissViaGesture,
      withPayload: [:]
    );
  };
};

// MARK: - RNIModalSheetViewDelegate+ModalSheetViewControllerEventsNotifiable
// --------------------------------------------------------------------------

extension RNIModalSheetViewDelegate: ModalFocusEventNotifiable {
  
  public func notifyForModalFocusStateChange(
    forViewController viewController: UIViewController,
    prevState: ModalFocusState?,
    currentState: ModalFocusState,
    nextState: ModalFocusState
  ) {
    
    var payload: Dictionary<String, Any> = [
      "currentState": currentState.rawValue,
      "nextState": nextState.rawValue,
    ];
    
    payload.unwrapAndMerge(withOther: [
      "prevState": prevState?.rawValue,
    ]);
  
    self.dispatchEvent(
      for: .onModalFocusChange,
      withPayload: payload
    );
  };
};
