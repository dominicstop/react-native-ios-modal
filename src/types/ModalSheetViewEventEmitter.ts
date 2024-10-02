import type { TSEventEmitter } from '@dominicstop/ts-event-emitter';
import type { RemapObject } from 'react-native-ios-utilities';

import type { OnModalDidDidDismissEventPayload, OnModalDidHideEventPayload, OnModalDidPresentEventPayload, OnModalDidShowEventPayload, OnModalFocusChangeEventPayload, OnModalWillDismissEventPayload, OnModalWillHideEventPayload, OnModalWillPresentEventPayload, OnModalWillShowEventPayload } from './CommonModalEvents';
import type { OnModalSheetStateDidChangeEventPayload, OnModalSheetStateWillChangeEventPayload, onModalSheetDidAttemptToDismissViaGestureEventPayload, onModalSheetDidDismissViaGestureEventPayload, onModalSheetWillDismissViaGestureEventPayload } from '../native_components/RNIModalSheetVIew';


export enum ModalSheetViewEvents {
  // common modal presentation events
  onModalWillPresent = "onModalWillPresent",
  onModalDidPresent = "onModalDidPresent",
  onModalWillDismiss = "onModalWillDismiss",
  onModalDidDismiss = "onModalDidDismiss",
  onModalWillShow = "onModalWillShow",
  onModalDidShow = "onModalDidShow",
  onModalWillHide = "onModalWillHide",
  onModalDidHide = "onModalDidHide",
  onModalFocusChange = "onModalFocusChange",

  // presentation controller event delegates
  onModalSheetWillDismissViaGesture = "onModalSheetWillDismissViaGesture",
  onModalSheetDidDismissViaGesture = "onModalSheetDidDismissViaGesture",
  onModalSheetDidAttemptToDismissViaGesture = "onModalSheetDidAttemptToDismissViaGesture",

  // modal sheet events
  onModalSheetStateWillChange = "onModalSheetStateWillChange",
  onModalSheetStateDidChange = "onModalSheetStateDidChange",
};

export type ModalSheetViewEventKeys = keyof typeof ModalSheetViewEvents;

export type ModalSheetViewEventEmitterMap = RemapObject<typeof ModalSheetViewEvents, {
  onModalWillPresent: OnModalWillPresentEventPayload;
  onModalDidPresent: OnModalDidPresentEventPayload;
  onModalWillDismiss: OnModalWillDismissEventPayload;
  onModalDidDismiss: OnModalDidDidDismissEventPayload;
  onModalWillShow: OnModalWillShowEventPayload;
  onModalDidShow: OnModalDidShowEventPayload;
  onModalWillHide: OnModalWillHideEventPayload;
  onModalDidHide: OnModalDidHideEventPayload;
  onModalFocusChange: OnModalFocusChangeEventPayload;

  onModalSheetWillDismissViaGesture: onModalSheetWillDismissViaGestureEventPayload;
  onModalSheetDidDismissViaGesture: onModalSheetDidDismissViaGestureEventPayload;
  onModalSheetDidAttemptToDismissViaGesture: onModalSheetDidAttemptToDismissViaGestureEventPayload;
  onModalSheetStateWillChange: OnModalSheetStateWillChangeEventPayload;
  onModalSheetStateDidChange: OnModalSheetStateDidChangeEventPayload;
}>;

export type ModalSheetViewEventEmitter = TSEventEmitter<
  ModalSheetViewEvents,
  ModalSheetViewEventEmitterMap
>;
