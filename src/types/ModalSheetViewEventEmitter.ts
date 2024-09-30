import type { TSEventEmitter } from '@dominicstop/ts-event-emitter';
import type { RemapObject } from 'react-native-ios-utilities';

import type { OnModalDidDidDismissEventPayload, OnModalDidHideEventPayload, OnModalDidPresentEventPayload, OnModalDidShowEventPayload, OnModalWillDismissEventPayload, OnModalWillHideEventPayload, OnModalWillPresentEventPayload, OnModalWillShowEventPayload } from './CommonModalEvents';
import type { OnModalSheetStateDidChangeEventPayload, OnModalSheetStateWillChangeEventPayload } from '../native_components/RNIModalSheetVIew';


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
  onModalSheetStateWillChange: OnModalSheetStateWillChangeEventPayload;
  onModalSheetStateDidChange: OnModalSheetStateDidChangeEventPayload;
}>;

export type ModalSheetViewEventEmitter = TSEventEmitter<
  ModalSheetViewEvents,
  ModalSheetViewEventEmitterMap
>;
