import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypes';


// MARK: Event Objects
// -------------------

export type OnModalWillPresentPayload = Readonly<{}>;

export type OnModalDidPresentEventPayload = Readonly<{}>;

export type OnModalWillShowEventPayload = Readonly<{}>;

export type OnModalDidShowEventPayload = Readonly<{}>;

export type OnModalWillHideEventPayload = Readonly<{}>;

export type OnModalDidHideEventPayload = Readonly<{}>;

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

