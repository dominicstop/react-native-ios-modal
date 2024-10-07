//
//  EntranceAnimationTransitioning.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 10/7/24.
//

import Foundation


public protocol EntranceAnimationTransitioning {
  
  func createEntranceAnimationBlocks() -> (
    start: () -> Void,
    end: () -> Void
  );
};
