import type { ViewProps, ViewStyle } from 'react-native';

import type {
  RNIModalViewProps,
  OnModalFocusEvent,
  OnModalShowEvent,
  OnModalAttemptDismissEvent,
  OnModalDismissEvent,
  OnModalBlurEvent,
  DeprecatedOnModalWillDismissEvent,
  DeprecatedOnModalDidDismissEvent,
} from 'src/native_components/RNIModalView';

import type { RNIComputableSize } from '../../types/RNIComputable';

export type ModalViewBaseProps = Partial<
  Pick<
    RNIModalViewProps,
    // Props - General
    | 'modalID'

    // Props - BG-Related
    | 'isModalBGBlurred'
    | 'isModalBGTransparent'
    | 'modalBGBlurEffectStyle'

    // Props - Presentation/Transition
    | 'modalPresentationStyle'
    | 'modalTransitionStyle'
    | 'hideNonVisibleModals'
    | 'presentViaMount'
    | 'enableSwipeGesture'
    | 'allowModalForceDismiss'
    | 'isModalInPresentation'

    // Props - Sheet-Related
    | 'modalSheetDetents'
    | 'sheetPrefersScrollingExpandsWhenScrolledToEdge'
    | 'sheetPrefersEdgeAttachedInCompactHeight'
    | 'sheetWidthFollowsPreferredContentSizeWhenEdgeAttached'
    | 'sheetPrefersGrabberVisible'
    | 'sheetShouldAnimateChanges'
    | 'sheetLargestUndimmedDetentIdentifier'
    | 'sheetPreferredCornerRadius'
    | 'sheetSelectedDetentIdentifier'

    // props - events
    | 'onModalWillPresent'
    | 'onModalDidPresent'
    | 'onModalWillDismiss'
    | 'onModalDidDismiss'
    | 'onModalWillShow'
    | 'onModalDidShow'
    | 'onModalWillHide'
    | 'onModalDidHide'
    | 'onModalWillFocus'
    | 'onModalDidFocus'
    | 'onModalWillBlur'
    | 'onModalDidBlur'
    | 'onPresentationControllerWillDismiss'
    | 'onPresentationControllerDidDismiss'
    | 'onPresentationControllerDidAttemptToDismiss'
    | 'onModalDetentDidCompute'
    | 'onModalDidChangeSelectedDetentIdentifier'
    | 'onModalDidSnap'
    | 'onModalSwipeGestureStart'
    | 'onModalSwipeGestureDidEnd'
    | 'onModalDismissWillCancel'
    | 'onModalDismissDidCancel'
  >
> & {
  modalContentPreferredContentSize?: RNIComputableSize;

  // TODO: See TODO:2023-03-04-13-02-45 - Refactor: Rename to
  // shouldAutoCloseOnUnmount
  autoCloseOnUnmount?: boolean;
  setEnableSwipeGestureFromProps?: boolean;
  setModalInPresentationFromProps?: boolean;
  isModalContentLazy?: boolean;

  shouldEnableAggressiveCleanup?: boolean;

  containerStyle: ViewStyle;
  children?: React.ReactNode;
};

/** @deprecated */
export type ModalViewDeprecatedProps = {
  /** @deprecated */ onModalFocus?: OnModalFocusEvent;
  /** @deprecated */ onModalShow?: OnModalShowEvent;
  /** @deprecated */ onModalAttemptDismiss?: OnModalAttemptDismissEvent;
  /** @deprecated */ onModalDismiss?: OnModalDismissEvent;
  /** @deprecated */ onModalBlur?: OnModalBlurEvent;
  /** @deprecated */ _onModalWillDismiss?: DeprecatedOnModalWillDismissEvent;
  /** @deprecated */ _onModalDidDismiss?: DeprecatedOnModalDidDismissEvent;
};

// prettier-ignore
export type ModalViewProps =
  ViewProps & ModalViewBaseProps & ModalViewDeprecatedProps;
