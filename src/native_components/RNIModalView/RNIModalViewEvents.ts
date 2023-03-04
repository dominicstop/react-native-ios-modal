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

// TODO - See TODO:2023-03-04-13-06-27 - Impl: Update
// `RNIModalView` Native Events
export type OnModalShowEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

// TODO - See TODO:2023-03-04-13-06-27 - Impl: Update
// `RNIModalView` Native Events
export type OnModalDismissEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

// TODO - See TODO:2023-03-04-13-06-27 - Impl: Update
// `RNIModalView` Native Events
export type OnModalBlurEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

/// TODO - See TODO:2023-03-04-13-06-27 - Impl: Update
// `RNIModalView` Native Events
export type OnModalFocusEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

// TODO - See TODO:2023-03-04-13-06-27 - Impl: Update
// `RNIModalView` Native Events
export type OnModalDidDismissEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

// TODO - See TODO:2023-03-04-13-06-27 - Impl: Update
// `RNIModalView` Native Events
export type OnModalWillDismissEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

// TODO - See TODO:2023-03-04-13-06-27 - Impl: Update
// `RNIModalView` Native Events
export type OnModalAttemptDismissEventObject = NativeSyntheticEvent<
  RNIModalViewInfo & {}
>;

// Event Handler Types
// -------------------

// prettier-ignore
export type OnModalShowEvent = (
  event: OnModalShowEventObject
) => void;

// prettier-ignore
export type OnModalDismissEvent = (
  event: OnModalDismissEventObject
) => void;

// prettier-ignore
export type OnModalBlurEvent = (
  event: OnModalBlurEventObject
) => void;

// prettier-ignore
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
