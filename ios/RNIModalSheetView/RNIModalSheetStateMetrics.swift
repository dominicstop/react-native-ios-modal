//
//  RNIModalSheetStateMetrics.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/29/24.
//

import Foundation


public struct RNIModalSheetStateMetrics: DictionaryRepresentationSynthesizing {

  public var state: ModalSheetState;
  public var simplified: ModalSheetState;
  
  public var isPresenting: Bool;
  public var isPresented: Bool;
  public var isDismissing: Bool;
  public var isDismissed: Bool;
  public var isIdle: Bool;
  
  public init(
    state: ModalSheetState,
    simplified: ModalSheetState,
    isPresenting: Bool,
    isPresented: Bool,
    isDismissing: Bool,
    isDismissed: Bool,
    isIdle: Bool
  ) {
    self.state = state;
    self.simplified = simplified;
    self.isPresenting = isPresenting;
    self.isPresented = isPresented;
    self.isDismissing = isDismissing;
    self.isDismissed = isDismissed;
    self.isIdle = isIdle;
  };
  
  public init(fromModalSheetState state: ModalSheetState){
    self.state = state;
    self.simplified = state.simplified;
    self.isPresenting = state.isPresenting;
    self.isPresented = state.isPresented;
    self.isDismissing = state.isDismissing;
    self.isDismissed = state.isDismissed;
    self.isIdle = state.isIdle;
  };
};
