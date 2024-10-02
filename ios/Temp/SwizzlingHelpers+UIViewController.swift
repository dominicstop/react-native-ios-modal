//
//  SwizzlingHelpers+UIViewController.swift
//
//
//  Created by Dominic Go on 6/14/24.
//

import UIKit
import DGSwiftUtilities

public extension SwizzlingHelpers {

  @discardableResult
  static func swizzlePresent<T, U>(
    /// `UIViewController.present(_:animated:completion)` or:
    /// `func present(`
    /// `  _ viewControllerToPresent: UIViewController,
    /// `  animated: Bool,
    /// `  completion: (() -> Void)?
    /// `)`
    ///
    impMethodType: T.Type = (@convention(c) (
      /* self       : */ UIViewController,
      /* _cmd       : */ Selector,
      /* vcToPresent: */ UIViewController,
      /* animated   : */ Bool,
      /* completion : */ (() -> Void)?
    ) -> Void).self,
      
    impBlockType: U.Type = (@convention(block) (
      /* self       : */ UIViewController,
      /* vcToPresent: */ UIViewController,
      /* animated   : */ Bool,
      /* completion : */ (() -> Void)?) -> Void
    ).self,

    presentBlockMaker: @escaping (
      _ originalImp: T,
      _ selector: Selector
    ) -> U
  ) -> IMP? {
    let selector = #selector(UIViewController.present(_:animated:completion:));
    
    return Self.swizzleWithBlock(
      impMethodType: impMethodType,
      forClass: UIViewController.self,
      withSelector: selector,
      newImpMaker: presentBlockMaker
    );
  };
  
  @discardableResult
  static func swizzleDismiss<T, U>(
    /// `UIViewController.dismiss(animated:completion)` or:
    /// `func dismiss(animated: Bool, completion: (() -> Void)?)`
    ///
    impMethodType: T.Type = (@convention(c) (
      /* self       : */ UIViewController,
      /* _cmd       : */ Selector,
      /* animated   : */ Bool,
      /* completion : */ (() -> Void)?
    ) -> Void).self,
      
    impBlockType: U.Type = (@convention(block) (
      /* self       : */ UIViewController,
      /* animated   : */ Bool,
      /* completion : */ (() -> Void)?) -> Void
    ).self,

    dismissBlockMaker: @escaping (
      _ originalImp: T,
      _ selector: Selector
    ) -> U
  ) -> IMP? {
    let selector = #selector(UIViewController.dismiss(animated:completion:));
    
    return Self.swizzleWithBlock(
      impMethodType: impMethodType,
      forClass: UIViewController.self,
      withSelector: selector,
      newImpMaker: dismissBlockMaker
    );
  };
};
