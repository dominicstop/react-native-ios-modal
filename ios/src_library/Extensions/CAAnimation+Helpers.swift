//
//  CAAnimation+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 5/1/23.
//

import UIKit

public extension CAAnimation {
  func waitUntiEnd(_ block: @escaping () -> Void){
    DispatchQueue.main.asyncAfter(
      deadline: .now() + self.duration,
      execute: block
    );
  };
};
