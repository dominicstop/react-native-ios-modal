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
  
  public static var propKeyPathMap: Dictionary<String, PartialKeyPath<RNIModalSheetViewDelegate>> {
    return [:];
  };
  
  public enum Events: String, CaseIterable {
    case placeholderEvent;
  }
  
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
  
  // TBA
  
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
  
};

extension RNIModalSheetViewDelegate: RNIContentViewDelegate {

  public typealias KeyPathRoot = RNIModalSheetViewDelegate;

  // MARK: Paper + Fabric
  // --------------------
    
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
    // no-op
  }
  
  public func notifyDidSetProps(sender: RNIContentViewParentDelegate) {
    // no-op
  };
  
  public func notifyOnUpdateLayoutMetrics(
    sender: RNIContentViewParentDelegate,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
  ) {
    // no-op
  };
  
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

          guard let mainSheetContentParent = self.sheetMainContentParentView else {
            throw RNIUtilitiesError(errorCode: .unexpectedNilValue);
          };
          
          let isAnimated: Bool = commandArguments.getValueFromDictionary(
            forKey: "isAnimated",
            fallbackValue: true
          );
          
          let modalVC = RNIModalSheetViewController();
          self.modalSheetController = modalVC;
          
          modalVC.mainSheetContentParent = mainSheetContentParent;
          modalVC.view.backgroundColor = .systemBackground;
          
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
          
          modalSheetController.dismiss(animated: isAnimated) {
            self.modalSheetController = nil;
          };
          
          resolveBlock([:]);
        
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
