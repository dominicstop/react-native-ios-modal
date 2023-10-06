//
//  RNIModalViewModule.swift
//  ReactNativeIosModal
//
//  Created by Dominic Go on 10/6/23.
//

import ExpoModulesCore

public class RNIModalViewModule: Module {

  public func definition() -> ModuleDefinition {
    Name("RNIModalViewModule");

    View(RNIModalView.self) {
    };
  };
};
