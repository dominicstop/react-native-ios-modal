//
//  WeakElement.swift
//  RNSwiftReviewer
//
//  Created by Dominic Go on 8/15/20.
//

import Foundation


class WeakElement<Element: AnyObject> {
  private(set) weak var value: Element?;
};
