//
//  RNIUtilitiesError.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/18/23.
//

import Foundation
import DGSwiftUtilities
import react_native_ios_utilities


public struct RNIModalErrorMetadata: ErrorMetadata {
  public static var domain: String? = "react-native-ios-utilities";
  public static var parentType: String? = nil;
};

public typealias RNIModalError = RNIError<RNIModalErrorMetadata>;
