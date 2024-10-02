import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypes';
import type { ModalFocusState } from './ModalFocusState';


// MARK: Event Objects
// -------------------

export type OnModalWillPresentEventPayload = Readonly<{
  viewControllerInstanceID: string;
  isAnimated: boolean;
}>;

export type OnModalDidPresentEventPayload = Readonly<{
  viewControllerInstanceID: string;
  isAnimated: boolean;
}>;

export type OnModalWillDismissEventPayload = Readonly<{
  viewControllerInstanceID: string;
  isAnimated: boolean;
}>;

export type OnModalDidDidDismissEventPayload = Readonly<{
  viewControllerInstanceID: string;
  isAnimated: boolean;
}>;

export type OnModalWillShowEventPayload = Readonly<{
  viewControllerInstanceID: string;
  isAnimated: boolean;
  isFirstAppearance: boolean;
}>;

export type OnModalDidShowEventPayload = Readonly<{
  viewControllerInstanceID: string;
  isAnimated: boolean;
  isFirstAppearance: boolean;
}>;

export type OnModalWillHideEventPayload = Readonly<{
  viewControllerInstanceID: string;
  isAnimated: boolean;
}>;

export type OnModalDidHideEventPayload = Readonly<{
  viewControllerInstanceID: string;
  isAnimated: boolean;
}>;

export type OnModalFocusChangeEventPayload = Readonly<{
  viewControllerInstanceID: string;
  modalLevel: number;
  prevState?: ModalFocusState;
  currentState: ModalFocusState;
  nextState: ModalFocusState;
}>;

// MARK: Events
// ------------

export type OnModalWillPresentEvent = 
  BubblingEventHandler<OnModalWillPresentEventPayload>;

export type OnModalDidPresentEvent = 
  BubblingEventHandler<OnModalDidPresentEventPayload>;

export type OnModalWillDismissEvent = 
  BubblingEventHandler<OnModalWillDismissEventPayload>;

export type OnModalDidDismissEvent = 
  BubblingEventHandler<OnModalDidDidDismissEventPayload>;

export type OnModalWillShowEvent = 
  BubblingEventHandler<OnModalWillShowEventPayload>;

export type OnModalDidShowEvent = 
  BubblingEventHandler<OnModalDidShowEventPayload>;

export type OnModalWillHideEvent = 
  BubblingEventHandler<OnModalWillHideEventPayload>;

export type OnModalDidHideEvent = 
  BubblingEventHandler<OnModalDidHideEventPayload>;

export type OnModalFocusChangeEvent =
  BubblingEventHandler<OnModalFocusChangeEventPayload>;