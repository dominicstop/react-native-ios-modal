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

export type ModalViewBaseProps = Partial<
  Pick<
    RNIModalViewProps,
    // props - flags
    | 'presentViaMount'
    | 'isModalBGBlurred'
    | 'enableSwipeGesture'
    | 'hideNonVisibleModals'
    | 'isModalBGTransparent'
    | 'isModalInPresentation'
    | 'allowModalForceDismiss'

    // props - string
    | 'modalID'
    | 'modalTransitionStyle'
    | 'modalBGBlurEffectStyle'
    | 'modalPresentationStyle'

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
  >
> & {
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

export type ModalViewState = {
  isModalVisible: boolean;
  childProps: unknown;
  enableSwipeGesture: boolean;
  isModalInPresentation: boolean;
  isModalInFocus: boolean;
};
