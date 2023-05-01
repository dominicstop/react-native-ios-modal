//
//  RNIModalWindowMap.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/8/23.
//

import Foundation


internal class RNIWindowMapData {
  
  // MARK: - Properties
  // ------------------
  
  weak var window: UIWindow?;
  
  private(set) var modalIndexCurrent: Int = -1;
  private(set) var modalIndexPrev: Int = -1;
  private(set) var modalIndexNext: Int?;
  
  weak var nextModalToFocus: (any RNIModal)?;
  weak var nextModalToBlur: (any RNIModal)?;
  
  #if DEBUG
  var modalIndexNext_: String {
    self.modalIndexNext == nil ? "N/A" : "\(self.modalIndexNext!)"
  };
  #endif
  
  // MARK: - Functions
  // -----------------
  
  init(window: UIWindow){
    self.window = window;
  };

  func set(nextModalToFocus modalToFocus: any RNIModal) {
    self.nextModalToFocus = modalToFocus;
    
    let modalIndexCurrent =
      RNIModalUtilities.computeModalIndex(forWindow: modalToFocus.window);
    
    let modalIndexPrev = self.modalIndexCurrent;
    
    self.modalIndexCurrent = modalIndexCurrent;
    self.modalIndexNext = modalIndexCurrent + 1;
    self.modalIndexPrev = modalIndexPrev;
  };
  
  func apply(forFocusedModal focusedModal: any RNIModal) {
    self.nextModalToFocus = nil;
    
    let modalIndexCurrent =
      RNIModalUtilities.computeModalIndex(forWindow: focusedModal.window);
    
    let modalIndexPrev = self.modalIndexCurrent;
    
    self.modalIndexCurrent = modalIndexCurrent;
    self.modalIndexNext = nil;
    self.modalIndexPrev = modalIndexPrev;
    
    focusedModal.modalIndexPrev = modalIndexPrev;
    focusedModal.modalIndex = modalIndexCurrent;
  };
  
  func set(nextModalToBlur modalToBlur: any RNIModal) {
    self.nextModalToBlur = modalToBlur;
    
    let modalIndexCurrent =
      RNIModalUtilities.computeModalIndex(forWindow: modalToBlur.window);
    
    let modalIndexPrev = self.modalIndexCurrent;
    
    self.modalIndexCurrent = modalIndexCurrent;
    self.modalIndexNext = modalIndexCurrent - 1;
    self.modalIndexPrev = modalIndexPrev;
  };
  
  func apply(forBlurredModal blurredModal: any RNIModal) {
    self.nextModalToBlur = nil;
    
    let modalIndexCurrent =
      RNIModalUtilities.computeModalIndex(forWindow: blurredModal.window);
    
    let modalIndexPrev = self.modalIndexCurrent;
    
    self.modalIndexCurrent = modalIndexCurrent;
    self.modalIndexNext = nil;
    self.modalIndexPrev = modalIndexPrev;
    
    blurredModal.modalIndexPrev = modalIndexPrev;
    blurredModal.modalIndex = modalIndexCurrent;
  };
  
  // MARK: - Properties - Computed
  // -----------------------------
  
  var windowID: String? {
    self.window?.synthesizedStringID;
  };
};

// MARK: - RNIModalWindowMap
// -------------------------

internal let RNIModalWindowMapShared = RNIModalWindowMap.sharedInstance;

internal class RNIModalWindowMap {
  
  // MARK: - Properties - Static
  // ---------------------------
  
  static var sharedInstance = RNIModalWindowMap();
  
  // MARK: - Properties
  // ------------------
  
  private(set) var windowDataMap: Dictionary<String, RNIWindowMapData> = [:];
  
  // MARK: - Functions
  // -----------------
  
  func set(forWindow window: UIWindow, data: RNIWindowMapData){
    self.windowDataMap[window.synthesizedStringID] = data;
  };
  
  func get(forWindow window: UIWindow) -> RNIWindowMapData {
    guard let windowData = self.windowDataMap[window.synthesizedStringID] else {
      // No corresponding "modal index" for window yet, so initialize
      // with value
      let windowDataNew = RNIWindowMapData(window: window);
      self.set(forWindow: window, data: windowDataNew);
      
      return windowDataNew;
    };
    
    return windowData;
  };
};
