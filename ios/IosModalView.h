// This guard prevent this file to be compiled in the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

#ifndef IosModalViewNativeComponent_h
#define IosModalViewNativeComponent_h

NS_ASSUME_NONNULL_BEGIN

@interface IosModalView : RCTViewComponentView
@end

NS_ASSUME_NONNULL_END

#endif /* IosModalViewNativeComponent_h */
#endif /* RCT_NEW_ARCH_ENABLED */
