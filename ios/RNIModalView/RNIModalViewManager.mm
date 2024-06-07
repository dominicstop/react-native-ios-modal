//
//  RNIModalViewManager.m
//  react-native-ios-modal
//
//  Created by Dominic Go on 6/6/24.
//

#import "RNIModalView.h"
#import <objc/runtime.h>

#import "react-native-ios-utilities/RNIBaseViewUtils.h"

#import "RCTBridge.h"
#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>


@interface RNIModalViewManager : RCTViewManager
@end

@implementation RNIModalViewManager

RCT_EXPORT_MODULE(RNIModalView)

#ifndef RCT_NEW_ARCH_ENABLED
- (UIView *)view
{
  return [[RNIModalView new] initWithBridge:self.bridge];
}
#endif

@end

