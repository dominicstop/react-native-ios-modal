import { requireNativeViewManager } from 'expo-modules-core';
import type { RNIModalViewProps } from './RNIModalViewTypes';

export const RNIModalView: React.ComponentType<RNIModalViewProps> =
  requireNativeViewManager('RNIModalView');