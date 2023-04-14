import type { NativeSyntheticEvent } from 'react-native';

import type {
  ModalFocusState,
  ModalPresentationState,
} from 'src/types/RNIModalViewRelatedTypes';

// Event Object Types
// ------------------

/**
 * Based on `RNIModalData`
 */
export type RNIModalData = {
  modalNativeID: string;
  modalIndex: number;
  currentModalIndex: number;
  modalFocusState: ModalFocusState;
  modalFocusStatePref: ModalFocusState;
  wasBlurCancelled: boolean;
  wasFocusCancelled: boolean;
  modalPresentationState: ModalPresentationState;
  modalPresentationStatePrev: ModalPresentationState;
  isInitialPresent: boolean;
  wasCancelledPresent: boolean;
  wasCancelledDismiss: boolean;
  wasCancelledDismissViaGesture: boolean;
  isModalPresented: boolean;
  isModalInFocus: boolean;
  computedIsModalInFocus: boolean;
  computedIsModalPresented: boolean;
  computedModalIndex: number;
  computedViewControllerIndex: number;
  computedCurrentModalIndex: number;
  synthesizedWindowID?: string;
};

/**
 * Based on `RNIModalBaseEventData`
 */
export type RNIModalBaseEvent = RNIModalData & {
  reactTag: number;
  modalID?: string;
};

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
