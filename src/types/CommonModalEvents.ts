import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypes';
import type { ModalFocusState } from './ModalFocusState';


// MARK: Event Objects
// -------------------

export type OnModalWillPresentEventPayload = Readonly<{
  isAnimated: boolean;
}>;

export type OnModalDidPresentEventPayload = Readonly<{
  isAnimated: boolean;
}>;

export type OnModalWillDismissEventPayload = Readonly<{
  isAnimated: boolean;
}>;

export type OnModalDidDidDismissEventPayload = Readonly<{
  isAnimated: boolean;
}>;

export type OnModalWillShowEventPayload = Readonly<{
  isAnimated: boolean;
  isFirstAppearance: boolean;
}>;

export type OnModalDidShowEventPayload = Readonly<{
  isAnimated: boolean;
  isFirstAppearance: boolean;
}>;

export type OnModalWillHideEventPayload = Readonly<{
  isAnimated: boolean;
}>;

export type OnModalDidHideEventPayload = Readonly<{
  isAnimated: boolean;
}>;

export type OnModalFocusChangeEventPayload = Readonly<{
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