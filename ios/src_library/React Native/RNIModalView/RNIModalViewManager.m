
#import <React/RCTViewManager.h>
 
@interface RCT_EXTERN_MODULE(RNIModalViewManager, RCTViewManager)

// MARK: - Props - Callbacks/Events
// --------------------------------

RCT_EXPORT_VIEW_PROPERTY(onModalWillPresent, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalDidPresent, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onModalWillDismiss, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalDidDismiss, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onModalWillShow, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalDidShow, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onModalWillHide, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalDidHide, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onModalWillFocus, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalDidFocus, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onModalWillBlur, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onModalDidBlur, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onPresentationControllerWillDismiss, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPresentationControllerDidDismiss, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPresentationControllerDidAttemptToDismiss, RCTBubblingEventBlock);

// MARK: - Value Props - General
// -----------------------------

RCT_EXPORT_VIEW_PROPERTY(modalID, NSString);

// MARK: - Value Props - BG-Related
// --------------------------------

RCT_EXPORT_VIEW_PROPERTY(isModalBGBlurred, BOOL);
RCT_EXPORT_VIEW_PROPERTY(isModalBGTransparent, BOOL);
RCT_EXPORT_VIEW_PROPERTY(modalBGBlurEffectStyle, NSString);

// MARK: - Value Props - Presentation/Transition
// ---------------------------------------------

RCT_EXPORT_VIEW_PROPERTY(modalPresentationStyle, NSString);
RCT_EXPORT_VIEW_PROPERTY(modalTransitionStyle, NSString);

RCT_EXPORT_VIEW_PROPERTY(hideNonVisibleModals, BOOL);
RCT_EXPORT_VIEW_PROPERTY(presentViaMount, BOOL);
RCT_EXPORT_VIEW_PROPERTY(enableSwipeGesture, BOOL);
RCT_EXPORT_VIEW_PROPERTY(allowModalForceDismiss, BOOL);
RCT_EXPORT_VIEW_PROPERTY(isModalInPresentation, BOOL);

// MARK: - Value Props - Sheet-Related
// -----------------------------------

RCT_EXPORT_VIEW_PROPERTY(modalSheetDetents, NSArray);

RCT_EXPORT_VIEW_PROPERTY(sheetPrefersScrollingExpandsWhenScrolledToEdge, BOOL);
RCT_EXPORT_VIEW_PROPERTY(sheetPrefersEdgeAttachedInCompactHeight, BOOL);
RCT_EXPORT_VIEW_PROPERTY(sheetWidthFollowsPreferredContentSizeWhenEdgeAttached, BOOL);
RCT_EXPORT_VIEW_PROPERTY(sheetPrefersGrabberVisible, BOOL);

@end

