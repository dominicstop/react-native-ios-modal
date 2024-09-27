//
//  PresentationControllerMetrics.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/27/24.
//

import UIKit
import DGSwiftUtilities


public struct PresentationControllerMetrics: Encodable {

  public var frameOfPresentedViewInContainerView: CGRect;
  public var preferredContentSize: CGSize;
  
  public var presentedViewFrame: CGRect?;
  public var containerViewFrame: CGRect?;
  
  public var adaptivePresentationStyle: String;
  
  public var shouldPresentInFullscreen: Bool;
  public var shouldRemovePresentersView: Bool;
  
  public init(from presentationController: UIPresentationController) {
    self.frameOfPresentedViewInContainerView =
      presentationController.frameOfPresentedViewInContainerView;
      
    self.preferredContentSize =
      presentationController.preferredContentSize;
      
    self.presentedViewFrame = {
      guard let presentedView = presentationController.presentedView else {
        return nil;
      };
      
      return presentedView.globalFrame ?? presentedView.frame;
    }();
    
    self.containerViewFrame = {
      guard let containerView = presentationController.containerView else {
        return nil;
      };
      
      return containerView.globalFrame ?? containerView.frame;
    }();
    
    self.adaptivePresentationStyle =
      presentationController.adaptivePresentationStyle.caseString;
    
    self.shouldPresentInFullscreen =
      presentationController.shouldPresentInFullscreen;
      
    self.shouldRemovePresentersView =
      presentationController.shouldRemovePresentersView;
  };
};

