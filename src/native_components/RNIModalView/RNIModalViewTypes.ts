import type { ViewProps } from 'react-native';

import type { TUIBlurEffectStyles } from 'src/types/UIBlurEffectStyles';

import type {
  TUIModalPresentationStyle,
  TUIModalTransitionStyle,
} from 'src/types/UIModalTypes';

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
} from './RNIModalViewEvents';

export type RNIModalViewBaseProps = {
  // Props - Flags
  // --------------

  presentViaMount?: boolean;
  isModalBGBlurred?: boolean;
  enableSwipeGesture?: boolean;
  hideNonVisibleModals?: boolean;
  isModalBGTransparent?: boolean;
  isModalInPresentation?: boolean;
  allowModalForceDismiss?: boolean;

  // Props - Strings
  // --------------

  modalID?: string;
  modalTransitionStyle?: TUIModalTransitionStyle;
  modalBGBlurEffectStyle?: TUIBlurEffectStyles;
  modalPresentationStyle?: TUIModalPresentationStyle;

  // Props - Events
  // --------------

  // TODO: TODO:2023-03-04-13-15-11 - Refactor: Use Will/Did
  // Prefix for RNIModalView Events
  //
  // * Rename - Add `will/did` prefix and deprecate prev. props
  //
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
};

export type RNIModalViewProps = Partial<ViewProps> & RNIModalViewBaseProps;

export type RNIModalViewConstantMap = ViewManagerConstantMap<{
  availableBlurEffectStyles: TUIBlurEffectStyles[];
  availablePresentationStyles: TUIModalPresentationStyle[];
}>;
