import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ReactNativeIosModalViewProps } from './ReactNativeIosModal.types';

const NativeView: React.ComponentType<ReactNativeIosModalViewProps> =
  requireNativeViewManager('ReactNativeIosModal');

export default function ReactNativeIosModalView(props: ReactNativeIosModalViewProps) {
  return <NativeView {...props} />;
}
