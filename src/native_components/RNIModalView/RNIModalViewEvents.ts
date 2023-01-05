/* eslint-disable no-trailing-spaces */

import type { NativeSyntheticEvent } from 'react-native';

// Event Object Types
// ------------------

export type RNIModalViewNativeEventBase = {
  modalUUID: string;
  isInFocus: boolean;
  isPresented: boolean;
  modalLevel: number;
  modalLevelPrev: number;
};

// TODO
export type OnModalShowEventObject = NativeSyntheticEvent<
  RNIModalViewNativeEventBase & {}
>;

// TODO
export type OnModalDismissEventObject = NativeSyntheticEvent<
  RNIModalViewNativeEventBase & {}
>;

// TODO
export type OnRequestResultEventObject = NativeSyntheticEvent<
  RNIModalViewNativeEventBase & {}
>;

// TODO
export type OnModalBlurEventObject = NativeSyntheticEvent<
  RNIModalViewNativeEventBase & {}
>;

// TODO
export type OnModalFocusEventObject = NativeSyntheticEvent<
  RNIModalViewNativeEventBase & {}
>;

// TODO
export type OnModalDidDismissEventObject = NativeSyntheticEvent<
  RNIModalViewNativeEventBase & {}
>;

// TODO
export type OnModalWillDismissEventObject = NativeSyntheticEvent<
  RNIModalViewNativeEventBase & {}
>;

// TODO
export type OnModalAttemptDismissEventObject = NativeSyntheticEvent<
  RNIModalViewNativeEventBase & {}
>;

// Event Handler Types
// -------------------

// eslint-disable-next-line prettier/prettier
export type OnModalShowEvent = (
  event: OnModalShowEventObject
) => void;

// eslint-disable-next-line prettier/prettier
export type OnModalDismissEvent = (
  event: OnModalDismissEventObject
) => void;

// eslint-disable-next-line prettier/prettier
export type OnRequestResultEvent = (
  event: OnRequestResultEventObject
) => void;

// eslint-disable-next-line prettier/prettier
export type OnModalBlurEvent = (
  event: OnModalBlurEventObject
) => void;

// eslint-disable-next-line prettier/prettier
export type OnModalFocusEvent = (
  event: OnModalFocusEventObject
) => void; 

export type OnModalDidDismissEvent = (
  event: OnModalDidDismissEventObject
) => void;

export type OnModalWillDismissEvent = (
  event: OnModalWillDismissEventObject
) => void;

export type OnModalAttemptDismissEvent = (
  event: OnModalAttemptDismissEventObject
) => void;
