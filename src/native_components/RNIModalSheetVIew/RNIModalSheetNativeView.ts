import type { HostComponent, ViewProps } from 'react-native';
import type { SharedViewEvents, RemapObject, NativeComponentBaseProps } from 'react-native-ios-utilities';

import { 
  default as RNIModalSheetViewNativeComponent,
  type NativeProps as RNIModalSheetViewNativeComponentProps,
} from './RNIModalSheetViewNativeComponent';

import type { OnModalWillPresentEvent, OnModalDidPresentEvent, OnModalWillShowEvent, OnModalDidShowEvent, OnModalWillHideEvent, OnModalDidHideEvent } from '../../types/CommonModalEvents';


type RNIModalSheetViewNativeComponentBaseProps = 
  NativeComponentBaseProps<RNIModalSheetViewNativeComponentProps>;

export type RNIModalSheetNativeViewBaseProps = RemapObject<RNIModalSheetViewNativeComponentBaseProps, {
  reactChildrenCount: number;

  onModalWillPresent: OnModalWillPresentEvent;
  onModalDidPresent: OnModalDidPresentEvent;

  onModalWillShow: OnModalWillShowEvent;
  onModalDidShow: OnModalDidShowEvent;
  
  onModalWillHide: OnModalWillHideEvent;
  onModalDidHide: OnModalDidHideEvent;
}>;

export type RNIModalSheetNativeViewProps = 
    SharedViewEvents
  & ViewProps
  & RNIModalSheetNativeViewBaseProps;

export const RNIModalSheetNativeView = 
  RNIModalSheetViewNativeComponent as unknown as HostComponent<RNIModalSheetNativeViewProps>;
