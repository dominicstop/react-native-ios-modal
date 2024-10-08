import type { HostComponent, ViewProps } from 'react-native';
import type { SharedViewEvents, RemapObject, NativeComponentBaseProps } from 'react-native-ios-utilities';

import { 
  default as RNIModalSheetViewNativeComponent,
  type NativeProps as RNIModalSheetViewNativeComponentProps,
} from './RNIModalSheetViewNativeComponent';

import type { OnModalSheetStateDidChangeEvent, OnModalSheetStateWillChangeEvent, onModalSheetWillDismissViaGestureEvent, onModalSheetDidDismissViaGestureEvent, onModalSheetDidAttemptToDismissViaGestureEvent } from './RNIModalSheetViewEvents';
import type { OnModalWillPresentEvent, OnModalDidPresentEvent, OnModalWillShowEvent, OnModalDidShowEvent, OnModalWillHideEvent, OnModalDidHideEvent, OnModalWillDismissEvent, OnModalDidDismissEvent, OnModalFocusChangeEvent } from '../../types/CommonModalEvents';


type RNIModalSheetViewNativeComponentBaseProps = 
  NativeComponentBaseProps<RNIModalSheetViewNativeComponentProps>;

export type RNIModalSheetNativeViewBaseProps = RemapObject<RNIModalSheetViewNativeComponentBaseProps, {
  reactChildrenCount: number;
  shouldAllowDismissalViaGesture: boolean;

  onModalWillPresent: OnModalWillPresentEvent;
  onModalDidPresent: OnModalDidPresentEvent;

  onModalWillDismiss: OnModalWillDismissEvent;
  onModalDidDismiss: OnModalDidDismissEvent;

  onModalWillShow: OnModalWillShowEvent;
  onModalDidShow: OnModalDidShowEvent;
  
  onModalWillHide: OnModalWillHideEvent;
  onModalDidHide: OnModalDidHideEvent;

  onModalFocusChange: OnModalFocusChangeEvent;

  onModalSheetWillDismissViaGesture: onModalSheetWillDismissViaGestureEvent;
  onModalSheetDidDismissViaGesture: onModalSheetDidDismissViaGestureEvent;
  onModalSheetDidAttemptToDismissViaGesture: onModalSheetDidAttemptToDismissViaGestureEvent;

  onModalSheetStateWillChange: OnModalSheetStateWillChangeEvent;
  onModalSheetStateDidChange: OnModalSheetStateDidChangeEvent;
}>;

export type RNIModalSheetNativeViewProps = 
    SharedViewEvents
  & ViewProps
  & RNIModalSheetNativeViewBaseProps;

export const RNIModalSheetNativeView = 
  RNIModalSheetViewNativeComponent as unknown as HostComponent<RNIModalSheetNativeViewProps>;
