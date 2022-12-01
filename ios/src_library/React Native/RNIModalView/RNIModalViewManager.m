
#import <React/RCTViewManager.h>
 
@interface RCT_EXTERN_MODULE(RNIModalViewManager, RCTViewManager)

// ------------------------------
// MARK: Props - Callbacks/Events
// ------------------------------

RCT_EXPORT_VIEW_PROPERTY(onModalShow    , RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalDismiss , RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onRequestResult, RCTDirectEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onModalBlur , RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalFocus, RCTDirectEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onModalDidDismiss    , RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalWillDismiss   , RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalAttemptDismiss, RCTDirectEventBlock);

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

// ---------------------------
// MARK: View Manager Commands
// ---------------------------

RCT_EXTERN_METHOD(requestModalPresentation
            : (nonnull NSNumber *)node
  requestID : (nonnull NSNumber *)requestID
  visibility: (nonnull BOOL     *)visibility
);

RCT_EXTERN_METHOD(requestModalInfo
            : (nonnull NSNumber *)node
  requestID : (nonnull NSNumber *)requestID
);

@end

