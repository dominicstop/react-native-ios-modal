//
//  RNIModalView.swift
//  ReactNativeIosModal
//
//  Created by Dominic Go on 10/6/23.
//

import ExpoModulesCore

public class RNIModalView: ExpoView {

  // MARK: Properties
  // ----------------
  
  public override var reactTag: NSNumber! {
    didSet {
      guard let newValue = self.reactTag,
            newValue != oldValue
      else { return };
      
      self.onReactTagDidSetEvent.callAsFunction([
        "reactTag": newValue
      ]);
    }
  };
  
  // MARK: Properties - Prop - Events
  // --------------------------------
  
  let onReactTagDidSetEvent = EventDispatcher("onReactTagDidSet");
  
    // MARK: Init + Lifecycle
  // ----------------------

  public required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext);
  };
  
  public override func layoutSubviews() {
    super.layoutSubviews();
  };
  
  public override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    super.insertReactSubview(subview, at: atIndex);
  };
};
