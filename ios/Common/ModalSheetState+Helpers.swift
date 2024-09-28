//
//  ModalSheetState+Helpers.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 9/29/24.
//

import Foundation
import DGSwiftUtilities


// MARK: - DictionaryRepresentable+Helpers
// ---------------------------------------

public extension ModalSheetState {
  
  var asMetrics: RNIModalSheetStateMetrics {
    .init(fromModalSheetState: self);
  };
  
  var asDictionary: [String : Any] {
    self.asMetrics.synthesizedDictionary;
  };
};
