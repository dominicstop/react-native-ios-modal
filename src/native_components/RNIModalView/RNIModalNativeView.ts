import type { HostComponent, ViewProps } from 'react-native';

import { default as RNIModalViewNativeComponent } from './RNIModalViewNativeComponent';
import type { SharedViewEvents } from 'react-native-ios-utilities';

export interface RNIModalNativeViewBaseProps extends ViewProps {
};

export type RNIModalNativeViewProps = 
    SharedViewEvents
  & RNIModalNativeViewBaseProps;

export const RNIModalNativeView = 
  RNIModalViewNativeComponent as unknown as HostComponent<RNIModalNativeViewProps>;
