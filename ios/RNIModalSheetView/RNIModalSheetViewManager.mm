//
//  RNIModalSheetViewManager.m
//  react-native-ios-modal
//
//  Created by Dominic Go on 6/6/24.
//

#import "RNIModalSheetView.h"
#import <objc/runtime.h>

#import "RCTBridge.h"
#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>

#import <react_native_ios_utilities/RNIBaseViewUtils.h>


@interface RNIModalSheetViewManager : RCTViewManager
@end

@implementation RNIModalSheetViewManager

RCT_EXPORT_MODULE(RNIModalSheetView)

#ifndef RCT_NEW_ARCH_ENABLED
- (UIView *)view
{
  return [[RNIModalSheetView alloc] initWithBridge:self.bridge];
}

RNI_EXPORT_VIEW_PROPERTY(reactChildrenCount, NSNumber);
RNI_EXPORT_VIEW_PROPERTY(shouldAllowDismissalViaGesture, BOOL);

RNI_EXPORT_VIEW_EVENT(onDidSetViewID, RCTBubblingEventBlock)
  
RNI_EXPORT_VIEW_EVENT(onModalWillPresent, RCTBubblingEventBlock);
RNI_EXPORT_VIEW_EVENT(onModalDidPresent, RCTBubblingEventBlock);

RNI_EXPORT_VIEW_EVENT(onModalWillDismiss, RCTBubblingEventBlock);
RNI_EXPORT_VIEW_EVENT(onModalDidDismiss, RCTBubblingEventBlock);

RNI_EXPORT_VIEW_EVENT(onModalWillShow, RCTBubblingEventBlock);
RNI_EXPORT_VIEW_EVENT(onModalDidShow, RCTBubblingEventBlock);

RNI_EXPORT_VIEW_EVENT(onModalWillHide, RCTBubblingEventBlock);
RNI_EXPORT_VIEW_EVENT(onModalDidHide, RCTBubblingEventBlock);

RNI_EXPORT_VIEW_EVENT(onModalFocusChange, RCTBubblingEventBlock);

RNI_EXPORT_VIEW_EVENT(onModalSheetWillDismissViaGesture, RCTBubblingEventBlock);
RNI_EXPORT_VIEW_EVENT(onModalSheetDidDismissViaGesture, RCTBubblingEventBlock);
RNI_EXPORT_VIEW_EVENT(onModalSheetDidAttemptToDismissViaGesture, RCTBubblingEventBlock);

RNI_EXPORT_VIEW_EVENT(onModalSheetStateWillChange, RCTBubblingEventBlock);
RNI_EXPORT_VIEW_EVENT(onModalSheetStateDidChange, RCTBubblingEventBlock);

#endif

@end

