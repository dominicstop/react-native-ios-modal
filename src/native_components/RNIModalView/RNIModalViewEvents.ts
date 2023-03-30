import type { NativeSyntheticEvent } from 'react-native';

// Event Object Types
// ------------------

/**
 * Based on `RNIModalData`
 */
export type RNIModalData = {};

/**
 * Based on `RNIModalBaseEventData`
 */
export type RNIModalBaseEvent = RNIModalData & {};

/**
 * Based on `RNIOnModalFocusEventData`
 */
export type RNIOnModalFocusEvent = RNIModalData & {};

// Native Event Object
// -------------------

// TODO - See TODO:2023-03-04-13-06-27 - Impl: Update
// `RNIModalView` Native Events
export type OnModalWillDismissEventObject = NativeSyntheticEvent<
  RNIModalBaseEvent & {}
>;

// TODO - See TODO:2023-03-04-13-06-27 - Impl: Update
// `RNIModalView` Native Events
export type OnModalDidDismissEventObject = NativeSyntheticEvent<
  RNIModalBaseEvent & {}
>;

// Event Handler Types
// -------------------

export type OnModalWillDismissEvent = (
  event: OnModalWillDismissEventObject
) => void;

export type OnModalDidDismissEvent = (
  event: OnModalDidDismissEventObject
) => void;
