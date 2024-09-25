import type { HostComponent, ViewProps } from 'react-native';
import type { SharedViewEvents, RemapObject, NativeComponentBaseProps } from 'react-native-ios-utilities';

import { 
  default as RNIModalSheetViewNativeComponent,
  type NativeProps as RNIModalSheetViewNativeComponentProps,
} from './RNIModalSheetViewNativeComponent';

type RNIModalSheetViewNativeComponentBaseProps = 
  NativeComponentBaseProps<RNIModalSheetViewNativeComponentProps>;

export type RNIModalSheetNativeViewBaseProps = RemapObject<RNIModalSheetViewNativeComponentBaseProps, {
  reactChildrenCount: number;
}>;

export type RNIModalSheetNativeViewProps = 
    SharedViewEvents
  & ViewProps
  & RNIModalSheetNativeViewBaseProps;

export const RNIModalSheetNativeView = 
  RNIModalSheetViewNativeComponent as unknown as HostComponent<RNIModalSheetNativeViewProps>;
