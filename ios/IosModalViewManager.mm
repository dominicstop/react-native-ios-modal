#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"

@interface IosModalViewManager : RCTViewManager
@end

@implementation IosModalViewManager

RCT_EXPORT_MODULE(IosModalView)

- (UIView *)view
{
  return [[UIView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(color, NSString)

@end
