import type { ViewProps } from 'react-native';

import type {
  UIModalPresentationStyle,
  UIModalTransitionStyle,
  UISheetPresentationControllerDetents,
  UIBlurEffectStyle,
} from 'src/types/NativeTypes';

import type { RNIModalCustomSheetDetent } from 'src/types/RNIModalTypes';
import type { ViewManagerConstantMap } from 'src/types/ViewModuleRelatedTypes';

import type {
  OnModalWillPresentEvent,
  OnModalDidPresentEvent,
  OnModalWillDismissEvent,
  OnModalDidDismissEvent,
  OnModalWillShowEvent,
  OnModalDidShowEvent,
  OnModalWillHideEvent,
  OnModalDidHideEvent,
  OnModalWillFocusEvent,
  OnModalDidFocusEvent,
  OnModalWillBlurEvent,
  OnModalDidBlurEvent,
  OnPresentationControllerWillDismissEvent,
  OnPresentationControllerDidDismissEvent,
  OnPresentationControllerDidAttemptToDismissEvent,
  OnModalDetentDidComputeEvent,
  OnModalDidChangeSelectedDetentIdentifierEvent,
  OnModalDidSnapEvent,
  OnModalSwipeGestureStartEvent,
  OnModalSwipeGestureDidEndEvent,
  OnModalDismissWillCancelEvent,
  OnModalDismissDidCancelEvent,
} from './RNIModalViewEvents';

import type { UnionWithAutoComplete } from 'src/types/UtilityTypes';
import type { RNIComputableSize } from 'src/types/RNIComputable';

export type RNIModalViewBaseProps = {
  // Props - General
  // ---------------

  modalID?: string;
  modalContentPreferredContentSize?: RNIComputableSize;

  // Props - BG-Related
  // ------------------

  isModalBGBlurred?: boolean;
  isModalBGTransparent?: boolean;
  modalBGBlurEffectStyle?: UIBlurEffectStyle;

  // Props - Presentation/Transition
  // -------------------------------

  modalTransitionStyle?: UIModalTransitionStyle;
  modalPresentationStyle?: UIModalPresentationStyle;

  hideNonVisibleModals?: boolean;
  presentViaMount?: boolean;
  enableSwipeGesture?: boolean;
  allowModalForceDismiss?: boolean;
  isModalInPresentation?: boolean;

  // Props - Sheet-Related
  // ---------------------

  modalSheetDetents?: Array<
    UISheetPresentationControllerDetents | RNIModalCustomSheetDetent
  >;

  sheetPrefersScrollingExpandsWhenScrolledToEdge?: boolean;
  sheetPrefersEdgeAttachedInCompactHeight?: boolean;
  sheetWidthFollowsPreferredContentSizeWhenEdgeAttached?: boolean;
  sheetPrefersGrabberVisible?: boolean;
  sheetShouldAnimateChanges?: boolean;

  sheetPreferredCornerRadius?: number;

  sheetLargestUndimmedDetentIdentifier?: UnionWithAutoComplete<
    UISheetPresentationControllerDetents,
    string
  >;

  sheetSelectedDetentIdentifier?: UnionWithAutoComplete<
    UISheetPresentationControllerDetents,
    string
  >;

  // Props - Events
  // --------------

  onModalWillPresent: OnModalWillPresentEvent;
  onModalDidPresent: OnModalDidPresentEvent;

  onModalWillDismiss: OnModalWillDismissEvent;
  onModalDidDismiss: OnModalDidDismissEvent;

  onModalWillShow: OnModalWillShowEvent;
  onModalDidShow: OnModalDidShowEvent;

  onModalWillHide: OnModalWillHideEvent;
  onModalDidHide: OnModalDidHideEvent;

  onModalWillFocus: OnModalWillFocusEvent;
  onModalDidFocus: OnModalDidFocusEvent;

  onModalWillBlur: OnModalWillBlurEvent;
  onModalDidBlur: OnModalDidBlurEvent;

  onPresentationControllerWillDismiss: OnPresentationControllerWillDismissEvent;
  onPresentationControllerDidDismiss: OnPresentationControllerDidDismissEvent;
  onPresentationControllerDidAttemptToDismiss: OnPresentationControllerDidAttemptToDismissEvent;

  onModalDetentDidCompute: OnModalDetentDidComputeEvent;
  onModalDidChangeSelectedDetentIdentifier: OnModalDidChangeSelectedDetentIdentifierEvent;

  onModalDidSnap: OnModalDidSnapEvent;

  onModalSwipeGestureStart: OnModalSwipeGestureStartEvent;
  onModalSwipeGestureDidEnd: OnModalSwipeGestureDidEndEvent;

  onModalDismissWillCancel: OnModalDismissWillCancelEvent;
  onModalDismissDidCancel: OnModalDismissDidCancelEvent;
};

export type RNIModalViewProps = Partial<ViewProps> & RNIModalViewBaseProps;

export type RNIModalViewConstantMap = ViewManagerConstantMap<{
  availableBlurEffectStyles: UIBlurEffectStyle[];
  availablePresentationStyles: UIModalPresentationStyle[];
}>;
