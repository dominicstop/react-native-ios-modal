//
//  RNIComputableValueEvaluator.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 4/27/23.
//

import Foundation
import JavaScriptCore

class RNIComputableValueEvaluator {

  // MARK: - Embedded Types
  // ----------------------

  private enum JSObjectKeys: String {
    case getView;
    case getWindowSize;
    case getScreenSize;
    case getEnvObject;
  
    case valueFunction;
    case parentView;
    case extraData;
    
    var string: NSString {
      self.rawValue as NSString
    };
    
    func getValue(in jsContext: JSContext) -> Any? {
      return jsContext.objectForKeyedSubscript(self);
    };
    
    func setValue(in jsContext: JSContext, with value: Any?) {
      jsContext.setObject(value, forKeyedSubscript: self.string);
    };
  };
  
  // MARK: - Properties
  // ------------------
  
  lazy var jsContext = JSContext();
  
  private var didInitializeJSContext = false;
  
  // MARK: - Properties - Env-Related
  // --------------------------------
  
  public var rootView: UIView?;
  
  public var targetView: UIView? {
    didSet {
      guard let jsContext = self.jsContext else { return };
      self.initializeJSContextIfNeeded();
      
      let viewMetadataDict: Dictionary<String, Any>? = {
        guard let targetView = self.targetView else { return nil };
          
        let viewMetadata = RNIViewMetadata(fromView: targetView);
        return viewMetadata.synthesizedJSDictionary;
      }();
      
      jsContext.setObject(
        viewMetadataDict,
        forKeyedSubscript: JSObjectKeys.parentView.string
      );
    }
  };
  
  public var extraData: NSDictionary? {
    willSet {
      self.initializeJSContextIfNeeded();
      self.jsContext?.setObject(
        newValue,
        forKeyedSubscript: JSObjectKeys.extraData.string
      );
    }
  };
  
  public var jsString: String = "" {
    willSet {
      self.initializeJSContextIfNeeded();
      self.jsContext?.setObject(
        newValue,
        forKeyedSubscript: JSObjectKeys.valueFunction.string
      );
    }
  };
  
  // MARK: - Properties - Computed
  // ------------------------------
  
  public var computedValue: JSValue? {
    guard let jsContext = self.jsContext else { return nil };
    self.initializeJSContextIfNeeded();

    let result = jsContext.evaluateScript(
      "valueFunction(getEnvObject())"
    );
    
    return result;
  };
  
  // MARK: - Functions
  // -----------------
  
  private func initializeJSValuesWithNullIfNeeded(){
    guard let jsContext = self.jsContext else { return };
    
    let valueKeys: [JSObjectKeys] = [
      .parentView,
      .valueFunction,
      .extraData,
    ];
    
    valueKeys.forEach {
      guard $0.getValue(in: jsContext) == nil else { return };
      $0.setValue(in: jsContext, with: nil);
    };
  };
  
  private func initializeJSContextIfNeeded(){
    guard let jsContext = self.jsContext,
          !self.didInitializeJSContext
    else { return };
    
    self.didInitializeJSContext = true;
    self.initializeJSValuesWithNullIfNeeded();
    
    let getView: @convention(block)
      (NSDictionary) -> [AnyHashable: Any] = { [unowned self] in
      
      let args = RNIComputableCommandArguments.GetView(fromDict: $0);
      
      guard let matchingView = self.getView(forArgs: args)
      else { return [:] };
    
      let viewMetadata = RNIViewMetadata(fromView: matchingView);
      return viewMetadata.synthesizedJSDictionary;
    };
    
    let getWindowSize: @convention(block)
      () -> [AnyHashable: Any] = { [unowned self] in
      
      let windowSize = self.targetView?.window?.frame.size ?? .zero;
      
      return [
        "height": windowSize.height,
        "width": windowSize.width
      ];
    };
    
    let getScreenSize: @convention(block)
      () -> [AnyHashable: Any] = { [unowned self] in
      
      let screenSize = self.targetView?.window?.screen.bounds.size ?? .zero;
      
      return [
        "height": screenSize.height,
        "width": screenSize.width
      ]
    };
    
    jsContext.setObject(
      getView,
      forKeyedSubscript: JSObjectKeys.getView.string
    );
    
    jsContext.setObject(
      getWindowSize,
      forKeyedSubscript: JSObjectKeys.getWindowSize.string
    );
    
    jsContext.setObject(
      getScreenSize,
      forKeyedSubscript: JSObjectKeys.getScreenSize.string
    );
    
    jsContext.evaluateScript("""
      function \(JSObjectKeys.getEnvObject)(){
        \(JSObjectKeys.getView),
        getWindowSize: null,
        getScreenSize: null,
        
        \(JSObjectKeys.parentView),
      };
    """);
  };
  
  // MARK: - Functions - Called from JS-Side
  // ---------------------------------------
  
  // Used by `getView`
  private func getView(
    forArgs args: RNIComputableCommandArguments.GetView
  ) -> UIView? {
  
    if let tag = args.tag,
       let rootView = self.rootView {
      
      return rootView.viewWithTag(tag);
    };
    
    if let reactTag = args.reactTag,
       let bridge = RNIUtilities.sharedBridge {
       
      return RNIUtilities.getView(
        forNode: reactTag,
        type: UIView.self,
        bridge: bridge
      );
    };
    
    if let nativeID = args.nativeID,
       let rootView = self.rootView {
      
      return RNIUtilities.getFirstMatchingView(
        forNativeID: nativeID,
        startingView: rootView
      );
    };
    
    return nil;
  };
};
