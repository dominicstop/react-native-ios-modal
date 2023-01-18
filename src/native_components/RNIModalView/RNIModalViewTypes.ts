import type { ViewProps } from 'react-native';

import type { UIBlurEffectStyles } from 'src/types/UIBlurEffectStyles';

import type {
  UIModalPresentationStyle,
  UIModalTransitionStyle,
} from 'src/types/UIModalTypes';

import type { ViewManagerConstantMap } from 'src/types/ViewModuleRelatedTypes';

import type {
  OnModalShowEvent,
  OnModalDismissEvent,
  OnModalBlurEvent,
  OnModalFocusEvent,
  OnModalDidDismissEvent,
  OnModalWillDismissEvent,
  OnModalAttemptDismissEvent,
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
  modalTransitionStyle?: UIModalTransitionStyle;
  modalBGBlurEffectStyle?: UIBlurEffectStyles;
  modalPresentationStyle?: UIModalPresentationStyle;

  // Props - Events
  // --------------

  // TODO: Rename - Add `will/did` prefix and deprecate prev. props
  onModalShow: OnModalShowEvent;
  onModalDismiss: OnModalDismissEvent;

  onModalBlur: OnModalBlurEvent;
  onModalFocus: OnModalFocusEvent;

  onModalDidDismiss: OnModalDidDismissEvent;
  onModalWillDismiss: OnModalWillDismissEvent;
  onModalAttemptDismiss: OnModalAttemptDismissEvent;
};

export type RNIModalViewProps = Partial<ViewProps> & RNIModalViewBaseProps;

export type RNIModalViewConstantMap = ViewManagerConstantMap<{
  availableBlurEffectStyles: UIBlurEffectStyles[];
  availablePresentationStyles: UIModalPresentationStyle[];
}>;
