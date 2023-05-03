import type { NativeSyntheticEvent } from 'react-native';

import type {
  RNIModalBaseEventData,
  RNIModalDetentDidComputeEventData,
  RNIModalDidChangeSelectedDetentIdentifierEventData,
  RNIOnModalFocusEventData,
  RNIModalDidSnapEventData,
  RNIModalSwipeGestureEventData,
} from './RNIModalViewEventData';

// Native Event Object
// -------------------

export type OnModalWillPresentEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData>;

export type OnModalDidPresentEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData>;

export type OnModalWillDismissEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData>;

export type OnModalDidDismissEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData>;

export type OnModalWillShowEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData>;

export type OnModalDidShowEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData>;

export type OnModalWillHideEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData>;

export type OnModalDidHideEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData>;

export type OnPresentationControllerWillDismissEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData>;

export type OnPresentationControllerDidDismissEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData>;

export type OnPresentationControllerDidAttemptToDismissEventObject =
  NativeSyntheticEvent<RNIModalBaseEventData>;

export type OnModalWillFocusEventObject =
  NativeSyntheticEvent<RNIOnModalFocusEventData>;

export type OnModalDidFocusEventObject =
  NativeSyntheticEvent<RNIOnModalFocusEventData>;

export type OnModalDetentDidComputeEventObject =
  NativeSyntheticEvent<RNIModalDetentDidComputeEventData>;

export type OnModalDidChangeSelectedDetentIdentifierEventObject =
  NativeSyntheticEvent<RNIModalDidChangeSelectedDetentIdentifierEventData>;

export type OnModalWillBlurEventObject =
  NativeSyntheticEvent<RNIOnModalFocusEventData>;

export type OnModalDidBlurEventObject =
  NativeSyntheticEvent<RNIOnModalFocusEventData>;

export type OnModalDidSnapEventObject =
  NativeSyntheticEvent<RNIModalDidSnapEventData>;

export type OnModalSwipeGestureStartEventObject =
  NativeSyntheticEvent<RNIModalSwipeGestureEventData>;

export type OnModalSwipeGestureDidEndEventObject =
  NativeSyntheticEvent<RNIModalSwipeGestureEventData>;
