import type { UIBlurEffectStyle } from 'src/types/NativeTypes';

import type {
  UIModalPresentationStyle,
  UIModalTransitionStyle,
} from 'src/types/NativeTypes';

export const UIBlurEffectStyles: {
  [T in UIBlurEffectStyle]: T;
} = {
  // Adaptable Styles
  systemUltraThinMaterial: 'systemUltraThinMaterial',
  systemThinMaterial: 'systemThinMaterial',
  systemMaterial: 'systemMaterial',
  systemThickMaterial: 'systemThickMaterial',
  systemChromeMaterial: 'systemChromeMaterial',

  // Light Styles
  systemMaterialLight: 'systemMaterialLight',
  systemThinMaterialLight: 'systemThinMaterialLight',
  systemUltraThinMaterialLight: 'systemUltraThinMaterialLight',
  systemThickMaterialLight: 'systemThickMaterialLight',
  systemChromeMaterialLight: 'systemChromeMaterialLight',

  // Dark Styles
  systemChromeMaterialDark: 'systemChromeMaterialDark',
  systemMaterialDark: 'systemMaterialDark',
  systemThickMaterialDark: 'systemThickMaterialDark',
  systemThinMaterialDark: 'systemThinMaterialDark',
  systemUltraThinMaterialDark: 'systemUltraThinMaterialDark',

  // Additional Styles
  regular: 'regular',
  prominent: 'prominent',
  light: 'light',
  extraLight: 'extraLight',
  dark: 'dark',
  extraDark: 'extraDark',
};

export const UIModalPresentationStyles: {
  [T in UIModalPresentationStyle]: T;
} = {
  automatic: 'automatic',
  fullScreen: 'fullScreen',
  pageSheet: 'pageSheet',
  formSheet: 'formSheet',
  overFullScreen: 'overFullScreen',

  // NOT SUPPORTED
  // -------------

  none: 'none',
  currentContext: 'currentContext',
  custom: 'custom',
  overCurrentContext: 'overCurrentContext',
  popover: 'popover',
  blurOverFullScreen: 'blurOverFullScreen',
};

export const UIModalTransitionStyles: {
  [T in UIModalTransitionStyle]: T;
} = {
  coverVertical: 'coverVertical',
  crossDissolve: 'crossDissolve',
  flipHorizontal: 'flipHorizontal',

  // NOT SUPPORTED
  // -------------

  partialCurl: 'partialCurl',
};
