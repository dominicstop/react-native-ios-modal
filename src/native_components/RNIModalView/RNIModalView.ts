import {
  View,
  UIManager,
  requireNativeComponent,
  Platform,
  HostComponent,
} from 'react-native';

import type {
  RNIModalViewConstantMap,
  RNIModalViewProps,
} from './RNIModalViewTypes';

const nativeViewName = 'RNIModalView';

/**
 * Do not use `RNIModalView` if platform is not iOS.
 */
export const RNIModalView: HostComponent<RNIModalViewProps> = Platform.select({
  ios: () => requireNativeComponent(nativeViewName) as any,
  default: () => View,
})();

export const RNIModalViewConstants: Partial<RNIModalViewConstantMap> =
  (UIManager as Record<string, any>)[nativeViewName]?.Constants ?? {};

export const AvailableBlurEffectStyles =
  RNIModalViewConstants?.availableBlurEffectStyles ?? [];

export const AvailablePresentationStyles =
  RNIModalViewConstants?.availablePresentationStyles ?? [];
