import { ViewProps } from 'react-native';
import type { OnModalViewReactTagDidSetEvent } from './RNIModalViewEvents';

export type RNIModalViewBaseProps = {
  shouldCleanupOnComponentWillUnmount: boolean;
  onReactTagDidSet: OnModalViewReactTagDidSetEvent;
};

export type RNIModalViewProps = 
  RNIModalViewBaseProps & ViewProps;