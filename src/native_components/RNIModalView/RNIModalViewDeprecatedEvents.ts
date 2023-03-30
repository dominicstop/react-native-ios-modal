import type { NativeSyntheticEvent } from 'react-native';

// Event Object Types
// ------------------

/** @deprecated */
export type RNIModalDeprecatedBaseEvent = {
  modalUUID: string;
  isInFocus: boolean;
  isPresented: boolean;
  modalLevel: number;
  modalLevelPrev: number;
  reactTag?: number;
  modalID?: string;
};

// Native Event Object
// -------------------

/** @deprecated */
export type OnModalShowEventObject = NativeSyntheticEvent<
  RNIModalDeprecatedBaseEvent & {}
>;

/** @deprecated */
export type OnModalDismissEventObject = NativeSyntheticEvent<
  RNIModalDeprecatedBaseEvent & {}
>;

/** @deprecated */
export type OnModalBlurEventObject = NativeSyntheticEvent<
  RNIModalDeprecatedBaseEvent & {}
>;

/** @deprecated */
export type OnModalFocusEventObject = NativeSyntheticEvent<
  RNIModalDeprecatedBaseEvent & {}
>;

/** @deprecated */
export type OnModalAttemptDismissEventObject = NativeSyntheticEvent<
  RNIModalDeprecatedBaseEvent & {}
>;

// Event Handler Types
// -------------------

// prettier-ignore
/** @deprecated */
export type OnModalShowEvent = (
  event: OnModalShowEventObject
) => void;

// prettier-ignore
/** @deprecated */
export type OnModalDismissEvent = (
  event: OnModalDismissEventObject
) => void;

// prettier-ignore
/** @deprecated */
export type OnModalBlurEvent = (
  event: OnModalBlurEventObject
) => void;

// prettier-ignore
/** @deprecated */
export type OnModalFocusEvent = (
  event: OnModalFocusEventObject
) => void;

/** @deprecated */
export type OnModalAttemptDismissEvent = (
  event: OnModalAttemptDismissEventObject
) => void;
