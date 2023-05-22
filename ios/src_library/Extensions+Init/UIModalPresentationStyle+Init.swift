//
//  UIModalPresentationStyle+Init.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/24/23.
//

import UIKit

extension UIModalPresentationStyle: CaseIterable, CustomStringConvertible {
  
  /// The available `UIModalPresentationStyle` that can be used based on the
  /// current platform version
  ///
  public static var availableStyles: [UIModalPresentationStyle] {
    var styles: [UIModalPresentationStyle] = [
      .fullScreen,
      .pageSheet,
      .formSheet,
      .currentContext,
      .custom,
      .overFullScreen,
      .overCurrentContext,
      .popover,
    ];
    
    if #available(iOS 13.0, *) {
      styles.append(.automatic);
    };
    
    #if !os(iOS)
    styles.append(.blurOverFullScreen);
    #endif
    
    return styles;
  };

  
  public static var allCases: [UIModalPresentationStyle] {
    return self.availableStyles;
  };
  
  // MARK: - CustomStringConvertible
  // -------------------------------
  
  /// See: Note:2023-03-23-23-14-57
  public var description: String {
    switch self {
      case .automatic         : return "automatic";
      case .none              : return "none";
      case .fullScreen        : return "fullScreen";
      case .pageSheet         : return "pageSheet";
      case .formSheet         : return "formSheet";
      case .currentContext    : return "currentContext";
      case .custom            : return "custom";
      case .overFullScreen    : return "overFullScreen";
      case .overCurrentContext: return "overCurrentContext";
      case .popover           : return "popover";
      
      #if !os(iOS)
      case .blurOverFullScreen: return "blurOverFullScreen";
      #endif
      
      @unknown default: return "";
    };
  };
  
  
  // MARK: - Init
  // ------------
  
  init?(string: String){
    /// See: Note:2023-03-23-23-21-21
    let style = Self.allCases.first{
      $0.description == string
    };
    
    guard let style = style else { return nil };
    self = style;
  };
};
