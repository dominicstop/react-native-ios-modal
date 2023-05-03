import type { NativeSyntheticEvent } from 'react-native';
import type { CGPoint, CGSize } from 'src/types/NativeTypes';

import type {
  ModalFocusState,
  ModalPresentationState,
} from 'src/types/RNIModalViewRelatedTypes';

// Event Object Types
// ------------------

/** Based on `RNIModalData` */
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

/** Based on `RNIModalBaseEventData` */
export type RNIModalBaseEventData = RNIModalData & {
  reactTag: number;
  modalID?: string;
};

/** Based on `RNIOnModalFocusEventData` */
export type RNIOnModalFocusEventData = RNIModalBaseEventData & {
  senderInfo: RNIModalData;
  isInitial: boolean;
};

/** Based on `RNIModalSwipeGestureEventData` */
export type RNIModalSwipeGestureEventData = {
  position: CGPoint;
};

/** Based on `RNIModalDidSnapEventData` */
export type RNIModalDidSnapEventData = {
  selectedDetentIdentifier?: string;
  modalContentSize: CGSize;
};

/** Based on RNIModalDidChangeSelectedDetentIdentifierEventData */
export type RNIModalDidChangeSelectedDetentIdentifierEventData = {
  sheetDetentStringPrevious?: string;
  sheetDetentStringCurrent?: string;
};

/** Based on RNIModalDetentDidComputeEventData */
export type RNIModalDetentDidComputeEventData = {
  maximumDetentValue: number;
  computedDetentValue: number;
  key: string;
};

// Native Event Object
// -------------------

export type OnModalWillPresentEventObject = NativeSyntheticEvent<
  RNIModalBaseEventData & {}
>;
export type OnModalDidPresentEventObject = NativeSyntheticEvent<
  RNIModalBaseEventData & {}
>;

export type OnModalWillDismissEventObject = NativeSyntheticEvent<
  RNIModalBaseEventData & {}
>;
export type OnModalDidDismissEventObject = NativeSyntheticEvent<
  RNIModalBaseEventData & {}
>;

export type OnModalWillShowEventObject = NativeSyntheticEvent<
  RNIModalBaseEventData & {}
>;
export type OnModalDidShowEventObject = NativeSyntheticEvent<
  RNIModalBaseEventData & {}
>;

export type OnModalWillHideEventObject = NativeSyntheticEvent<
  RNIModalBaseEventData & {}
>;
export type OnModalDidHideEventObject = NativeSyntheticEvent<
  RNIModalBaseEventData & {}
>;

export type OnPresentationControllerWillDismissEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData & {}>;

export type OnPresentationControllerDidDismissEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData & {}>;

export type OnPresentationControllerDidAttemptToDismissEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData & {}>;

export type OnModalWillFocusEventObject = NativeSyntheticEvent<
  RNIOnModalFocusEventData & {}
>;

export type OnModalDidFocusEventObject = NativeSyntheticEvent<
  RNIOnModalFocusEventData & {}
>;

export type OnModalDetentDidComputeEventObject =
  NativeSyntheticEvent<RNIModalDetentDidComputeEventData>;

export type OnModalDidChangeSelectedDetentIdentifierEventObject =
  NativeSyntheticEvent<RNIModalDidChangeSelectedDetentIdentifierEventData>;

export type OnModalWillBlurEventObject = NativeSyntheticEvent<
  RNIOnModalFocusEventData & {}
>;
export type OnModalDidBlurEventObject = NativeSyntheticEvent<
  RNIOnModalFocusEventData & {}
>;

export type OnModalDidSnapEventObject =
  NativeSyntheticEvent<RNIModalDidSnapEventData>;

export type OnModalSwipeGestureStartEventObject =
  NativeSyntheticEvent<RNIModalSwipeGestureEventData>;

export type OnModalSwipeGestureDidEndEventObject =
  NativeSyntheticEvent<RNIModalSwipeGestureEventData>;

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

export type OnModalDidSnapEvent = (event: OnModalDidSnapEventObject) => void;

export type OnModalSwipeGestureStartEvent = (
  event: OnModalSwipeGestureStartEventObject
) => void;

export type OnModalSwipeGestureDidEndEvent = (
  event: OnModalSwipeGestureDidEndEventObject
) => void;
