//
//  RNIContentViewController.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/7/24.
//

import UIKit
import DGSwiftUtilities
import react_native_ios_utilities


public class RNIContentViewController: UIViewController {

  public typealias ContentSizingMode = RNIContentSizingMode;
  public typealias ContentPositioningMode = RNIContentPositioningMode;
  
  // MARK: - Properties
  // ------------------
  
  public var contentSizingMode: ContentSizingMode = .sizingFromNative;
  public var contentPositioningMode: ContentPositioningMode = .stretch;
  
  public var nativeViewHeightConstraint: NSLayoutConstraint?;
  public var nativeViewWidthConstraint: NSLayoutConstraint?;
  
  public var reactContentParentView: RNIContentViewParentDelegate?;
  
  // MARK: - View Controller Lifecycle
  // ---------------------------------
  
  public override func loadView() {
    super.loadView();
  };
  
  public override func viewDidLoad() {
    guard let reactContentParentView = self.reactContentParentView else {
      return;
    };

    reactContentParentView.reactViewLifecycleDelegates.add(self);
    
    reactContentParentView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(reactContentParentView);
    
    let constraints = self.contentPositioningMode.createConstraints(
      forView: reactContentParentView,
      attachingTo: self.view
    );
    
    // self.nativeViewHeightConstraint = self.view.heightAnchor.constraint(
    //   equalToConstant: reactContentParentView.cachedLayoutMetrics?.frame.height ?? 0
    // );
    

    
    // constraints.append(
    //   self.view.heightAnchor.constraint(
    //     equalTo: reactContentParentView.heightAnchor
    //   )
    // );
    //
    // let constraints = [
    //   reactContentParentView.leadingAnchor.constraint(
    //     equalTo: self.view.leadingAnchor
    //   ),
    //   reactContentParentView.trailingAnchor.constraint(
    //     equalTo: self.view.trailingAnchor
    //   ),
    //   reactContentParentView.bottomAnchor.constraint(
    //     equalTo: self.view.bottomAnchor
    //   ),
    //   self.view.heightAnchor.constraint(
    //     equalTo: reactContentParentView.heightAnchor
    //   ),
    // ];
    
    
    
    // self.view.backgroundColor = .red;
    
    

    NSLayoutConstraint.activate(constraints);
    
    // MARK: Set Initial Size
    let newSize = self.view.bounds.size;
    let hasValidSize = !newSize.isZero;
    
    if hasValidSize {
      self.contentSizingMode.updateReactSizeIfNeeded(
        forReactParent: reactContentParentView,
        withNewSize: newSize
      );
    };
  };

  public override func viewWillLayoutSubviews() {
    self.updateSizeIfNeeded();
  };
  
  public func updateSizeIfNeeded(){
    guard let reactContentParentView = self.reactContentParentView else {
      return;
    };
    
    let newSize = self.view.bounds.size;
    self.contentSizingMode.updateReactSizeIfNeeded(
      forReactParent: reactContentParentView,
      withNewSize: newSize
    );
  };
};
