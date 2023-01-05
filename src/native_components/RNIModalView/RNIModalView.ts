import {
  View,
  UIManager,
  requireNativeComponent,
  Platform,
  HostComponent,
} from 'react-native';

import type {
  RNIModalViewCommandMap,
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

export const RNIModalViewCommands = UIManager[nativeViewName]
  ?.Commands as RNIModalViewCommandMap;

export const RNIModalViewConstants = UIManager[nativeViewName]
  ?.Constants as RNIModalViewConstantMap;

export const AvailableBlurEffectStyles =
  RNIModalViewConstants?.availableBlurEffectStyles ?? [];

export const AvailablePresentationStyles =
  RNIModalViewConstants?.availablePresentationStyles ?? [];
