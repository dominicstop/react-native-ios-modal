import type { ViewProps } from 'react-native';

import type { UIBlurEffectStyles } from 'src/types/UIBlurEffectStyles';

import type {
  UIModalPresentationStyle,
  UIModalTransitionStyle,
} from 'src/types/UIModalTypes';

import type {
  ViewManagerCommandMap,
  ViewManagerConstantMap,
} from 'src/types/ViewModuleRelatedTypes';

import type {
  OnModalShowEvent,
  OnModalDismissEvent,
  OnRequestResultEvent,
  OnModalBlurEvent,
  OnModalFocusEvent,
  OnModalDidDismissEvent,
  OnModalWillDismissEvent,
  OnModalAttemptDismissEvent,
} from './RNIModalViewEvents';

export type RNIModalViewProps = ViewProps & {
  // Props - Flags
  // --------------

  presentViaMount: boolean;
  isModalBGBlurred: boolean;
  enableSwipeGesture: boolean;
  hideNonVisibleModals: boolean;
  isModalBGTransparent: boolean;
  isModalInPresentation: boolean;
  allowModalForceDismiss: boolean;

  // Props - Strings
  // --------------

  modalID: string;
  modalTransitionStyle: UIModalTransitionStyle;
  modalBGBlurEffectStyle: UIBlurEffectStyles;
  modalPresentationStyle: UIModalPresentationStyle;

  // Props - Events
  // --------------

  onModalShow: OnModalShowEvent;
  onModalDismiss: OnModalDismissEvent;
  onRequestResult: OnRequestResultEvent;

  onModalBlur: OnModalBlurEvent;
  onModalFocus: OnModalFocusEvent;

  onModalDidDismiss: OnModalDidDismissEvent;
  onModalWillDismiss: OnModalWillDismissEvent;
  onModalAttemptDismiss: OnModalAttemptDismissEvent;
};

// prettier-ignore
export type RNIModalViewCommandMap = ViewManagerCommandMap<
  | 'requestModalInfo'
  | 'requestModalPresentation'
>;

export type RNIModalViewConstantMap = ViewManagerConstantMap<{
  availableBlurEffectStyles: UIBlurEffectStyles[];
  availablePresentationStyles: UIModalPresentationStyle[];
}>;
