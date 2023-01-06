/* eslint-disable no-trailing-spaces */

import type { NativeSyntheticEvent } from 'react-native';

// Event Object Types
// ------------------

export type RNIModalViewInfo = {
  modalUUID: string;
  isInFocus: boolean;
  isPresented: boolean;
  modalLevel: number;
  modalLevelPrev: number;
};

// TODO
export type OnModalShowEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

// TODO
export type OnModalDismissEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

// TODO
export type OnRequestResultEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

// TODO
export type OnModalBlurEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

// TODO
export type OnModalFocusEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

// TODO
export type OnModalDidDismissEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

// TODO
export type OnModalWillDismissEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

// TODO
export type OnModalAttemptDismissEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
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
