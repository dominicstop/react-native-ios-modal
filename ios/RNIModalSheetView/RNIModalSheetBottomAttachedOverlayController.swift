//
//  RNIModalSheetBottomAttachedOverlayController.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/6/24.
//

import UIKit
import DGSwiftUtilities
import react_native_ios_utilities

public class RNIModalSheetBottomAttachedOverlayController:
  ModalSheetBottomAttachedOverlayController {
  
  public var reactParentView: RNIContentViewParentDelegate?;
  
  public override func setupContent() {
    defer {
      super.setupContent();
    };
    
    guard let reactParentView = self.reactParentView else {
      return;
    };
    
    let childVC = RNIContentViewController();
    self.contentController = childVC;
    
    childVC.reactContentParentView = reactParentView;
    childVC.contentSizingMode = .sizingHeightFromReactAndWidthFromNative;
    
    //self.contentController = DummyContentController();
    
  };
};

// MARK: - RNIContentViewController+RNIViewLifecycle
// -------------------------------------------------

extension RNIContentViewController: RNIViewLifecycle {
  
  public func notifyOnUpdateLayoutMetrics(
    sender: RNIContentViewParentDelegate,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
  ) {
    
    guard self.contentSizingMode.isSizingWidthOrHeightFromReact else {
      return;
    };
    
    self.view.setNeedsLayout();
    
    return;
    self.view.updateConstraints()
    self.reactContentParentView?.invalidateIntrinsicContentSize();
    
    print(
      "RNIContentViewController.\(#function)",
      "\n - reactContentParentView.intrinsicContentSize", self.reactContentParentView?.intrinsicContentSize.debugDescription ?? "N/A",
      "\n - reactContentParentView.intrinsicContentSize", self.reactContentParentView?.intrinsicContentSizeOverride.debugDescription ?? "N/A",
      "\n - arg oldLayoutMetrics.frame", oldLayoutMetrics.frame.size.debugDescription,
      "\n - arg oldLayoutMetrics.contentFrame", oldLayoutMetrics.contentFrame.size,
      "\n - arg newLayoutMetrics", newLayoutMetrics.frame.size.debugDescription,
      "\n - arg newLayoutMetrics.contentFrame", oldLayoutMetrics.contentFrame.size,
      "\n"
    );
  }
};

extension RNIModalSheetBottomAttachedOverlayController: EntranceAnimationTransitioning {

  public func createEntranceAnimationBlocks() -> (
    start: () -> Void,
    end: () -> Void
  ) {
    let initialTransform = Transform3D(
      translateY: 100
    );
    
    let finalTransform = Transform3D(
      translateY: 0
    );
  
    return (
      start: {
        //self.view.alpha = 0;
        self.view.layer.transform = initialTransform.transform;
      },
      end: {
        //self.view.alpha = 1;
        self.view.layer.transform = finalTransform.transform;
      }
    );
  };
};

extension RNIModalSheetBottomAttachedOverlayController: ExitAnimationTransitioning {

  public func createExitAnimationBlocks() -> (
    start: () -> Void,
    end: () -> Void
  ) {
    
    let initialTransform = Transform3D(
      translateY: 0
    );
    
    let finalTransform = Transform3D(
      translateY: 100
    );
  
    return (
      start: {
        //self.view.alpha = 0;
        self.view.layer.transform = initialTransform.transform;
      },
      end: {
        //self.view.alpha = 1;
        self.view.layer.transform = finalTransform.transform;
      }
    );
  };
};
