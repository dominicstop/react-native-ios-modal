import type { ViewProps } from 'react-native';

import type {
  TUIModalPresentationStyle,
  TUIModalTransitionStyle,
  TUISheetPresentationControllerDetents,
} from 'src/types/UIModalTypes';

import type { TUIBlurEffectStyles } from 'src/types/UIBlurEffectStyles';
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
  modalBGBlurEffectStyle?: TUIBlurEffectStyles;

  // Props - Presentation/Transition
  // -------------------------------

  modalTransitionStyle?: TUIModalTransitionStyle;
  modalPresentationStyle?: TUIModalPresentationStyle;

  hideNonVisibleModals?: boolean;
  presentViaMount?: boolean;
  enableSwipeGesture?: boolean;
  allowModalForceDismiss?: boolean;
  isModalInPresentation?: boolean;

  // Props - Sheet-Related
  // ---------------------

  modalSheetDetents?: Array<
    TUISheetPresentationControllerDetents | RNIModalCustomSheetDetent
  >;

  sheetPrefersScrollingExpandsWhenScrolledToEdge?: boolean;
  sheetPrefersEdgeAttachedInCompactHeight?: boolean;
  sheetWidthFollowsPreferredContentSizeWhenEdgeAttached?: boolean;
  sheetPrefersGrabberVisible?: boolean;
  sheetShouldAnimateChanges?: boolean;

  sheetPreferredCornerRadius?: number;

  sheetLargestUndimmedDetentIdentifier?: UnionWithAutoComplete<
    TUISheetPresentationControllerDetents,
    string
  >;

  sheetSelectedDetentIdentifier?: UnionWithAutoComplete<
    TUISheetPresentationControllerDetents,
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
};

export type RNIModalViewProps = Partial<ViewProps> & RNIModalViewBaseProps;

export type RNIModalViewConstantMap = ViewManagerConstantMap<{
  availableBlurEffectStyles: TUIBlurEffectStyles[];
  availablePresentationStyles: TUIModalPresentationStyle[];
}>;
