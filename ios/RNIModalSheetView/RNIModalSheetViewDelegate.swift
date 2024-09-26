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
  
  public static var propKeyPathMap: Dictionary<String, PartialKeyPath<RNIModalSheetViewDelegate>> {
    return [:];
  };
  
  public enum Events: String, CaseIterable {
    case placeholderEvent;
  }
  
  // MARK: Properties
  // ----------------
  
  var _didSendEvents = false;
  
  // MARK: - Properties - RNIContentViewDelegate
  // -------------------------------------------
  
  public weak var parentReactView: RNIContentViewParentDelegate?;
  
  public var detachedModalContentParentViews: [RNIContentViewParentDelegate] = [];
  
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
  
  // MARK: Functions
  // ---------------
  
  public override func didMoveToWindow() {
    guard self.window != nil,
          let parentReactView = self.parentReactView
    else { return };
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 10){
      parentReactView.setSize(.init(width: 300, height: 300));
    };
  };
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
  
    guard let parentReactView = parentReactView else {
      return;
    };
  
    defer {
      parentReactView.requestToRemoveReactSubview(childComponentView);
      childComponentView.removeFromSuperview();
    };
  
    guard let reactView = childComponentView as? RNIContentViewParentDelegate,
          reactView.contentDelegate is RNIWrapperViewContent
    else {
      return;
    };
    
    self.detachedModalContentParentViews.append(reactView);
  };
  
  public func notifyOnUnmountChildComponentView(
    sender: RNIContentViewParentDelegate,
    childComponentView: UIView,
    index: NSInteger,
    superBlock: () -> Void
  ) {
    #if !RCT_NEW_ARCH_ENABLED
    superBlock();
    #endif
    
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
          
          let mainSheetContentParent =
            self.detachedModalContentParentViews.first;

          guard let mainSheetContentParent = mainSheetContentParent else {
            throw RNIUtilitiesError(errorCode: .unexpectedNilValue);
          };
          
          let isAnimated: Bool = commandArguments.getValueFromDictionary(
            forKey: "isAnimated",
            fallbackValue: true
          );
          
          let modalVC = RNIModalSheetViewController();
          modalVC.mainSheetContentParent = mainSheetContentParent;
          modalVC.view.backgroundColor = .systemBackground;
          
          closestVC.present(modalVC, animated: isAnimated);
          
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
  public func notifyOnUpdateProps(
    sender: RNIContentViewParentDelegate,
    oldProps: NSDictionary,
    newProps: NSDictionary
  ) {
    // no-op
  };
  
  public func notifyOnUpdateState(
    sender: RNIContentViewParentDelegate,
    oldState: NSDictionary?,
    newState: NSDictionary
  ) {
    // no-op
  };
  
  public func notifyOnFinalizeUpdates(
    sender: RNIContentViewParentDelegate,
    updateMaskRaw: Int,
    updateMask: RNIComponentViewUpdateMask
  ) {
    // no-op
  };
  
  public func notifyOnPrepareForReuse(sender: RNIContentViewParentDelegate) {
    // no-op
  };
  #else
  
  // MARK: - Paper Only
  // ------------------
  
  #endif
};
