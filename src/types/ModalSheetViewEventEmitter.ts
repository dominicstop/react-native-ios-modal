import type { TSEventEmitter } from '@dominicstop/ts-event-emitter';
import type { RemapObject } from 'react-native-ios-utilities';

import type { OnModalDidHideEventPayload, OnModalDidPresentEventPayload, OnModalDidShowEventPayload, OnModalWillHideEventPayload, OnModalWillPresentEventPayload, OnModalWillShowEventPayload } from './CommonModalEvents';
import type { OnModalSheetStateDidChangeEventPayload, OnModalSheetStateWillChangeEventPayload } from '../native_components/RNIModalSheetVIew';


export enum ModalSheetViewEvents {
  // common modal presentation events
  onModalWillPresent = "onModalWillPresent",
  onModalDidPresent = "onModalDidPresent",
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
