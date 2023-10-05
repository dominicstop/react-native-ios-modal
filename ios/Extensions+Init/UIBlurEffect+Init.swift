//
//  UIBlurEffect+Init.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/23/23.
//

import UIKit

extension UIBlurEffect.Style: CaseIterable, CustomStringConvertible {
  
  /// The available `UIBlurEffect.Style` that can be used based on the current
  /// platform version
  ///
  public static var availableStyles: [UIBlurEffect.Style] {
    var styles: [UIBlurEffect.Style] = [
      .light,
      .extraLight,
      .dark,
    ];
    
    if #available(iOS 10.0, *) {
      styles.append(contentsOf: [
        .regular,
        .prominent,
      ]);
    };
    
    if #available(iOS 13.0, *) {
      styles.append(contentsOf: [
        .systemUltraThinMaterial,
        .systemThinMaterial,
        .systemMaterial,
        .systemThickMaterial,
        .systemChromeMaterial,
        .systemMaterialLight,
        .systemThinMaterialLight,
        .systemUltraThinMaterialLight,
        .systemThickMaterialLight,
        .systemChromeMaterialLight,
        .systemChromeMaterialDark,
        .systemMaterialDark,
        .systemThickMaterialDark,
        .systemThinMaterialDark,
        .systemUltraThinMaterialDark,
      ]);
    };
    
    return styles;
  };
  
  // MARK: - CaseIterable
  // --------------------
  
  public static var allCases: [UIBlurEffect.Style] {
    return self.availableStyles;
  };
  
  // MARK: - CustomStringConvertible
  // -------------------------------
  
  /// Note:2023-03-23-23-14-57
  ///
  /// * `UIBlurEffect.Style` is an objc enum, and as such, it's actually raw
  ///    value internally is `Int`.
  ///
  /// * As such, `String(describing:)` a ` UIBlurEffect.Style` enum value
  ///   outputs an `Int`.
  ///
  /// * Because of this, we have to manually map out the enum values to a string
  ///   representation.
  ///
  public var description: String {
    switch self {
      // Adaptable Styles
      case .systemUltraThinMaterial: return "systemUltraThinMaterial";
      case .systemThinMaterial     : return "systemThinMaterial";
      case .systemMaterial         : return "systemMaterial";
      case .systemThickMaterial    : return "systemThickMaterial";
      case .systemChromeMaterial   : return "systemChromeMaterial";
        
      // Light Styles
      case .systemMaterialLight         : return "systemMaterialLight";
      case .systemThinMaterialLight     : return "systemThinMaterialLight";
      case .systemUltraThinMaterialLight: return "systemUltraThinMaterialLight";
      case .systemThickMaterialLight    : return "systemThickMaterialLight";
      case .systemChromeMaterialLight   : return "systemChromeMaterialLight";
      
        // Dark Styles
      case .systemChromeMaterialDark   : return "systemChromeMaterialDark";
      case .systemMaterialDark         : return "systemMaterialDark";
      case .systemThickMaterialDark    : return "systemThickMaterialDark";
      case .systemThinMaterialDark     : return "systemThinMaterialDark";
      case .systemUltraThinMaterialDark: return "systemUltraThinMaterialDark";
        
      // Additional Styles
      case .regular   : return "regular";
      case .prominent : return "prominent";
      case .light     : return "light";
      case .extraLight: return "extraLight";
      case .dark      : return "dark";
        
      @unknown default: return "";
    };
  };
  
  // MARK: - Init
  // ------------
  
  init?(string: String){
    
    /// Note:2023-03-23-23-21-21
    ///
    /// * Normally, a simple `switch` + `case "foo": self = foo` would suffice,
    ///   (especially since it's O(1) access), but the usable enum values depend
    ///   on the platform version.
    ///
    /// * The useable enums are stored in `availableStyles`, and is used to
    ///   communicate to JS the available enum values.
    ///
    /// * As such, we might as well re-use `availableStyles` for the parsing
    ///   logic (even if it's less efficient).
    ///
    let style = Self.allCases.first{
      $0.description == string
    };
    
    guard let style = style else { return nil };
    self = style;
  };
};

