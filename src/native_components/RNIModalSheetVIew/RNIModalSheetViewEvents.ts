
import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypes';


// MARK: Event Objects
// -------------------

export type OnModalSheetStateWillChangeEventPayload = Readonly<{
}>;

export type OnModalSheetStateDidChangeEventPayload = Readonly<{
}>;

// MARK: Events
// ------------

export type OnModalSheetStateWillChangeEvent = 
  BubblingEventHandler<OnModalSheetStateWillChangeEventPayload>;

export type OnModalSheetStateDidChangeEvent = 
  BubblingEventHandler<OnModalSheetStateDidChangeEventPayload>;
