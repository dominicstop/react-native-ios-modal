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
  
  public override func setupContent() {
    defer {
      super.setupContent();
    };
    
    // MARK: TODO TEMP!
    self.contentController = DummyContentController();
    self.view.backgroundColor = .red;
  };
};

// MARK: TODO - TEMP!
public class DummyContentController: UIViewController {
  public override func viewDidLoad() {
    self.view.backgroundColor = .blue;
    
    self.view.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint.activate([
      self.view.heightAnchor.constraint(equalToConstant: 100),
    ]);
  };
};
