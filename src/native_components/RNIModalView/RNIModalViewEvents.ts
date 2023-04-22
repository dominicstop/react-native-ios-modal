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
  modalIndexPrev: number;
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
export type RNIOnModalFocusEvent = RNIModalBaseEvent & {
  senderInfo: RNIModalData;
  isInitial: boolean;
};

// Native Event Object
// -------------------

export type OnModalWillPresentEventObject = NativeSyntheticEvent<
  RNIModalBaseEvent & {}
>;
export type OnModalDidPresentEventObject = NativeSyntheticEvent<
  RNIModalBaseEvent & {}
>;

export type OnModalWillDismissEventObject = NativeSyntheticEvent<
  RNIModalBaseEvent & {}
>;
export type OnModalDidDismissEventObject = NativeSyntheticEvent<
  RNIModalBaseEvent & {}
>;

export type OnModalWillShowEventObject = NativeSyntheticEvent<
  RNIModalBaseEvent & {}
>;
export type OnModalDidShowEventObject = NativeSyntheticEvent<
  RNIModalBaseEvent & {}
>;

export type OnModalWillHideEventObject = NativeSyntheticEvent<
  RNIModalBaseEvent & {}
>;
export type OnModalDidHideEventObject = NativeSyntheticEvent<
  RNIModalBaseEvent & {}
>;

export type OnPresentationControllerWillDismissEventObject =
  NativeSyntheticEvent<RNIModalBaseEvent & {}>;

export type OnPresentationControllerDidDismissEventObject =
  NativeSyntheticEvent<RNIModalBaseEvent & {}>;

export type OnPresentationControllerDidAttemptToDismissEventObject =
  NativeSyntheticEvent<RNIModalBaseEvent & {}>;

export type OnModalWillFocusEventObject = NativeSyntheticEvent<
  RNIOnModalFocusEvent & {}
>;
export type OnModalDidFocusEventObject = NativeSyntheticEvent<
  RNIOnModalFocusEvent & {}
>;

export type OnModalDetentDidComputeEventObject = NativeSyntheticEvent<{
  maximumDetentValue: number;
}>;

export type OnModalDidChangeSelectedDetentIdentifierEventObject =
  NativeSyntheticEvent<{
    sheetDetentStringPrevious?: string;
    sheetDetentStringCurrent?: string;
  }>;

export type OnModalWillBlurEventObject = NativeSyntheticEvent<
  RNIOnModalFocusEvent & {}
>;
export type OnModalDidBlurEventObject = NativeSyntheticEvent<
  RNIOnModalFocusEvent & {}
>;

// Event Handler Types
// -------------------

export type OnModalWillPresentEvent = (
  event: OnModalWillPresentEventObject
) => void;

export type OnModalDidPresentEvent = (
  event: OnModalDidPresentEventObject
) => void;

export type OnModalWillDismissEvent = (
  event: OnModalWillDismissEventObject
) => void;

export type OnModalDidDismissEvent = (
  event: OnModalDidDismissEventObject
) => void;

export type OnModalWillShowEvent = (event: OnModalWillShowEventObject) => void;

export type OnModalDidShowEvent = (event: OnModalDidShowEventObject) => void;

export type OnModalWillHideEvent = (event: OnModalWillHideEventObject) => void;

export type OnModalDidHideEvent = (event: OnModalDidHideEventObject) => void;

export type OnPresentationControllerWillDismissEvent = (
  event: OnPresentationControllerWillDismissEventObject
) => void;

export type OnPresentationControllerDidDismissEvent = (
  event: OnPresentationControllerDidDismissEventObject
) => void;

export type OnPresentationControllerDidAttemptToDismissEvent = (
  event: OnPresentationControllerDidAttemptToDismissEventObject
) => void;

export type OnModalWillFocusEvent = (
  event: OnModalWillFocusEventObject
) => void;

export type OnModalDidFocusEvent = (event: OnModalDidFocusEventObject) => void;

export type OnModalWillBlurEvent = (event: OnModalWillBlurEventObject) => void;

export type OnModalDidBlurEvent = (event: OnModalDidBlurEventObject) => void;


export type OnModalDetentDidComputeEvent = (
  event: OnModalDetentDidComputeEventObject
) => void;

export type OnModalDidChangeSelectedDetentIdentifierEvent = (
  event: OnModalDidChangeSelectedDetentIdentifierEventObject
) => void;