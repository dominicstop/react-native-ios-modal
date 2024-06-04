//
//  StaticAlias.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/21/23.
//

import UIKit

extension CACornerMask {

  public static let allCorners: Self = [
    .layerMinXMinYCorner,
    .layerMaxXMinYCorner,
    .layerMinXMaxYCorner,
    .layerMaxXMaxYCorner,
  ];

  public static let topCorners: Self = [
    .layerMinXMinYCorner,
    .layerMaxXMinYCorner,
  ];
  
  public static let bottomCorners: Self = [
    .layerMinXMaxYCorner,
    .layerMaxXMaxYCorner,
  ];
  
  public static let leftCorners: Self = [
    .layerMinXMinYCorner,
    .layerMinXMaxYCorner,
  ];
  
  public static let rightCorners: Self = [
    .layerMaxXMinYCorner,
    .layerMaxXMaxYCorner,
  ];
};
