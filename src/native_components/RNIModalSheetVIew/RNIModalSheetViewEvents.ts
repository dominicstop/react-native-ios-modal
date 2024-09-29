
import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypes';
import type { RNIModalSheetStateMetrics } from '../../types/RNIModalSheetStateMetrics';


// MARK: Event Objects
// -------------------

export type OnModalSheetStateWillChangeEventPayload = Readonly<{
  prevState?: RNIModalSheetStateMetrics;
  currentState: RNIModalSheetStateMetrics;
  nextState: RNIModalSheetStateMetrics;
}>;

export type OnModalSheetStateDidChangeEventPayload = Readonly<{
  prevState: RNIModalSheetStateMetrics;
  currentState: RNIModalSheetStateMetrics;
}>;

// MARK: Events
// ------------

export type OnModalSheetStateWillChangeEvent = 
  BubblingEventHandler<OnModalSheetStateWillChangeEventPayload>;

export type OnModalSheetStateDidChangeEvent = 
  BubblingEventHandler<OnModalSheetStateDidChangeEventPayload>;
