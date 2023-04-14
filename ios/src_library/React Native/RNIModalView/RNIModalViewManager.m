
#import <React/RCTViewManager.h>
 
@interface RCT_EXTERN_MODULE(RNIModalViewManager, RCTViewManager)

// ------------------------------
// MARK: Props - Callbacks/Events
// ------------------------------

RCT_EXPORT_VIEW_PROPERTY(onModalWillPresent, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalDidPresent, RCTDirectEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onModalWillDismiss, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalDidDismiss, RCTDirectEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onModalWillShow, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalDidShow, RCTDirectEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onModalWillHide, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalDidHide, RCTDirectEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onModalWillFocus, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalDidFocus, RCTDirectEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onModalWillBlur, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onModalDidBlur, RCTDirectEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onPresentationControllerWillDismiss, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPresentationControllerDidDismiss, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPresentationControllerDidAttemptToDismiss, RCTDirectEventBlock);

// --------------------------------
// MARK: Props - RN Component Props
// --------------------------------

RCT_EXPORT_VIEW_PROPERTY(presentViaMount       , BOOL);
RCT_EXPORT_VIEW_PROPERTY(isModalBGBlurred      , BOOL);
RCT_EXPORT_VIEW_PROPERTY(enableSwipeGesture    , BOOL);
RCT_EXPORT_VIEW_PROPERTY(hideNonVisibleModals  , BOOL);
RCT_EXPORT_VIEW_PROPERTY(isModalBGTransparent  , BOOL);
RCT_EXPORT_VIEW_PROPERTY(isModalInPresentation , BOOL);
RCT_EXPORT_VIEW_PROPERTY(allowModalForceDismiss, BOOL);


RCT_EXPORT_VIEW_PROPERTY(modalID               , NSString);
RCT_EXPORT_VIEW_PROPERTY(modalTransitionStyle  , NSString);
RCT_EXPORT_VIEW_PROPERTY(modalBGBlurEffectStyle, NSString);
RCT_EXPORT_VIEW_PROPERTY(modalPresentationStyle, NSString);

@end

