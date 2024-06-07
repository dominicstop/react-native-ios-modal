//
//  RNIModalView.h
//  react-native-ios-modal
//
//  Created by Dominic Go on 6/6/24.
//

#import <react-native-ios-utilities/RNIBaseView.h>

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

@interface RNIModalView : RNIBaseView

@end
