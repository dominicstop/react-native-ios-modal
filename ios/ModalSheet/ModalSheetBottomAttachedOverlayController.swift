//
//  RNIModalSheetDecorationController.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/3/24.
//

import UIKit
import DGSwiftUtilities


public class ModalSheetBottomAttachedOverlayController: UIViewController {

  public var contentController: UIViewController?;

  public var layoutConfig:
    ModalSheetBottomAttachedOverlayLayoutConfig = .default;
  
  public override func viewDidLoad() {
    super.viewDidLoad();
    self.setupContent();
  };
  
  // MARK: - Setup
  // -------------
  
  public func setupContent(){
    guard let contentController = self.contentController else {
      return;
    };
    
    self.view.addSubview(contentController.view);
    contentController.view.translatesAutoresizingMaskIntoConstraints = false;
    
    var constraints: [NSLayoutConstraint] = [
      self.view.leadingAnchor.constraint(
        equalTo: contentController.view.leadingAnchor
      ),
      self.view.trailingAnchor.constraint(
        equalTo: contentController.view.trailingAnchor
      ),
      self.view.topAnchor.constraint(
        equalTo: contentController.view.topAnchor
      ),
    ];
    
    constraints += self.layoutConfig.createInternalBottomConstraint(
      forView: contentController.view,
      attachingTo: self.view
    );
    
    NSLayoutConstraint.activate(constraints);

    self.addChild(contentController);
    contentController.didMove(toParent: self);
  };
  
  // MARK: - Methods
  // ---------------
  
  public func attachView(
    anchoredToBottomEdgesOf bottomEdgeAnchorView: UIView,
    withSheetContainerView sheetContainerView: UIView
  ){
    self.view.translatesAutoresizingMaskIntoConstraints = false;
    bottomEdgeAnchorView.addSubview(self.view);
    
    var constraints: [NSLayoutConstraint] = [];
    constraints += self.layoutConfig.createExternalHorizontalConstraints(
      forView: self.view,
      attachingTo: sheetContainerView
    );
    
    constraints += self.layoutConfig.createExternalBottomConstraints(
      forView: self.view,
      attachingTo: bottomEdgeAnchorView
    );
    
    NSLayoutConstraint.activate(constraints);
  };
};
