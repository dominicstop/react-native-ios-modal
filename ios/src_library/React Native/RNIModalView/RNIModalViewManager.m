
#import <React/RCTViewManager.h>
 
@interface RCT_EXTERN_MODULE(RNIModalViewManager, RCTViewManager)

// ------------------------------
// MARK: Props - Callbacks/Events
// ------------------------------

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

