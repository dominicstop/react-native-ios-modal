
import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypes';
import type { RNIModalSheetStateMetrics } from '../../types/RNIModalSheetStateMetrics';


// MARK: Event Objects
// -------------------

export type OnModalSheetStateWillChangeEventPayload = Readonly<{
  viewControllerInstanceID: string;
  prevState?: RNIModalSheetStateMetrics;
  currentState: RNIModalSheetStateMetrics;
  nextState: RNIModalSheetStateMetrics;
}>;

export type OnModalSheetStateDidChangeEventPayload = Readonly<{
  viewControllerInstanceID: string;
  prevState: RNIModalSheetStateMetrics;
  currentState: RNIModalSheetStateMetrics;
}>;

export type onModalSheetWillDismissViaGestureEventPayload = Readonly<{
  viewControllerInstanceID: string;
}>;

export type onModalSheetDidDismissViaGestureEventPayload = Readonly<{
  viewControllerInstanceID: string;
}>;

export type onModalSheetDidAttemptToDismissViaGestureEventPayload = Readonly<{
  viewControllerInstanceID: string;
}>;

// MARK: Events
// ------------

export type onModalSheetWillDismissViaGestureEvent = 
  BubblingEventHandler<onModalSheetWillDismissViaGestureEventPayload>;

export type onModalSheetDidDismissViaGestureEvent = 
  BubblingEventHandler<onModalSheetDidDismissViaGestureEventPayload>;

export type onModalSheetDidAttemptToDismissViaGestureEvent = 
  BubblingEventHandler<onModalSheetDidAttemptToDismissViaGestureEventPayload>;

export type OnModalSheetStateWillChangeEvent = 
  BubblingEventHandler<OnModalSheetStateWillChangeEventPayload>;

export type OnModalSheetStateDidChangeEvent = 
  BubblingEventHandler<OnModalSheetStateDidChangeEventPayload>;
