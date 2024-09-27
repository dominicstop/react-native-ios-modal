import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypes';


// MARK: Event Objects
// -------------------

export type OnModalWillPresentPayload = Readonly<{
  isAnimated: boolean;
}>;

export type OnModalDidPresentEventPayload = Readonly<{
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

// MARK: Events
// ------------

export type OnModalWillPresentEvent = 
  BubblingEventHandler<OnModalWillPresentPayload>;

export type OnModalDidPresentEvent = 
  BubblingEventHandler<OnModalDidPresentEventPayload>;

export type OnModalWillShowEvent = 
  BubblingEventHandler<OnModalWillShowEventPayload>;

export type OnModalDidShowEvent = 
  BubblingEventHandler<OnModalDidShowEventPayload>;

export type OnModalWillHideEvent = 
  BubblingEventHandler<OnModalWillHideEventPayload>;

export type OnModalDidHideEvent = 
  BubblingEventHandler<OnModalDidHideEventPayload>;

