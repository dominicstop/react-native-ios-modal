/* eslint-disable prettier/prettier */

import type {
  OnModalWillPresentEventObject,
  OnModalDidPresentEventObject,
  OnModalWillDismissEventObject,
  OnModalDidDismissEventObject,
  OnModalWillShowEventObject,
  OnModalDidShowEventObject,
  OnModalWillHideEventObject,
  OnModalDidHideEventObject,
  OnPresentationControllerWillDismissEventObject,
  OnPresentationControllerDidDismissEventObject,
  OnPresentationControllerDidAttemptToDismissEventObject,
  OnModalWillFocusEventObject,
  OnModalDidFocusEventObject,
  OnModalWillBlurEventObject,
  OnModalDidBlurEventObject,
  OnModalDetentDidComputeEventObject,
  OnModalDidChangeSelectedDetentIdentifierEventObject,
  OnModalDidSnapEventObject,
  OnModalSwipeGestureStartEventObject,
  OnModalSwipeGestureDidEndEventObject,
  OnModalDismissWillCancelEventObject,
  OnModalDismissDidCancelEventObject,
} from './RNIModalViewEventObjects';

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

export type OnModalWillShowEvent = (
  event: OnModalWillShowEventObject
) => void;

export type OnModalDidShowEvent = (
  event: OnModalDidShowEventObject
) => void;

export type OnModalWillHideEvent = (
  event: OnModalWillHideEventObject
) => void;

export type OnModalDidHideEvent = (
  event: OnModalDidHideEventObject
) => void;

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

export type OnModalDidFocusEvent = (
  event: OnModalDidFocusEventObject
) => void;

export type OnModalWillBlurEvent = (
  event: OnModalWillBlurEventObject
) => void;

export type OnModalDidBlurEvent = (
  event: OnModalDidBlurEventObject
) => void;

export type OnModalDetentDidComputeEvent = (
  event: OnModalDetentDidComputeEventObject
) => void;

export type OnModalDidChangeSelectedDetentIdentifierEvent = (
  event: OnModalDidChangeSelectedDetentIdentifierEventObject
) => void;

export type OnModalDidSnapEvent = (
  event: OnModalDidSnapEventObject
) => void;

export type OnModalSwipeGestureStartEvent = (
  event: OnModalSwipeGestureStartEventObject
) => void;

export type OnModalSwipeGestureDidEndEvent = (
  event: OnModalSwipeGestureDidEndEventObject
) => void;

export type OnModalDismissWillCancelEvent = (
  event: OnModalDismissWillCancelEventObject
) => void;

export type OnModalDismissDidCancelEvent = (
  event: OnModalDismissDidCancelEventObject
) => void;

