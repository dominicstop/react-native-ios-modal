import type { TSEventEmitter } from '@dominicstop/ts-event-emitter';
import type { RemapObject } from 'react-native-ios-utilities';
import type { OnModalDidHideEventPayload, OnModalDidPresentEventPayload, OnModalDidShowEventPayload, OnModalWillHideEventPayload, OnModalWillPresentEventPayload, OnModalWillShowEventPayload } from './CommonModalEvents';


export enum ModalSheetViewEvents {
  onModalWillPresent = "onModalWillPresent",
  onModalDidPresent = "onModalDidPresent",
  onModalWillShow = "onModalWillShow",
  onModalDidShow = "onModalDidShow",
  onModalWillHide = "onModalWillHide",
  onModalDidHide = "onModalDidHide",
};

export type ModalSheetViewEventKeys = keyof typeof ModalSheetViewEvents;

export type ModalSheetViewEventEmitterMap = RemapObject<typeof ModalSheetViewEvents, {
  onModalWillPresent: OnModalWillPresentEventPayload;
  onModalDidPresent: OnModalDidPresentEventPayload;
  onModalWillShow: OnModalWillShowEventPayload;
  onModalDidShow: OnModalDidShowEventPayload;
  onModalWillHide: OnModalWillHideEventPayload;
  onModalDidHide: OnModalDidHideEventPayload;
}>;

export type ModalSheetViewEventEmitter = TSEventEmitter<
  ModalSheetViewEvents,
  ModalSheetViewEventEmitterMap
>;
