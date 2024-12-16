//
//  RNIModalSheetView.h
//  react-native-ios-modal
//
//  Created by Dominic Go on 6/6/24.
//

#import "RNIModalHeaderUtils.h"
#import RNI_UTILITIES_HEADER(RNIBaseView.h)

#if RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#else
#import <React/RCTView.h>
#endif

@protocol RNIContentViewParentDelegate;
@protocol RNIContentViewDelegate;

@class RCTBridge;

#if RCT_NEW_ARCH_ENABLED
namespace react = facebook::react;
#endif

@interface RNIModalSheetView : RNIBaseView

@end
