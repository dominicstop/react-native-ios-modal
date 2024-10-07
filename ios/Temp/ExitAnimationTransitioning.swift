//
//  ExitAnimationTransitioning.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/7/24.
//

import Foundation


public protocol ExitAnimationTransitioning {

  func createExitAnimationBlocks() -> (
    start: () -> Void,
    end: () -> Void
  );
};
