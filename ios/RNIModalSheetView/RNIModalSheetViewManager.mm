//
//  RNIModalSheetViewManager.m
//  react-native-ios-modal
//
//  Created by Dominic Go on 6/6/24.
//

#import "RNIModalSheetView.h"
#import <objc/runtime.h>

#import "react-native-ios-utilities/RNIBaseViewUtils.h"

#import "RCTBridge.h"
#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>


@interface RNIModalSheetViewManager : RCTViewManager
@end

@implementation RNIModalSheetViewManager

RCT_EXPORT_MODULE(RNIModalSheetView)

#ifndef RCT_NEW_ARCH_ENABLED
- (UIView *)view
{
  return [[RNIModalSheetView new] initWithBridge:self.bridge];
}
#endif

@end

