/* eslint-disable prettier/prettier */

export type CGSize = {
  width: number;
  height: number;
};

export type CGPoint = {
  x: number;
  y: number;
};

export type UIModalTransitionStyle =
  | 'coverVertical'
  | 'flipHorizontal'
  | 'crossDissolve'
  | 'partialCurl';

export type UIModalPresentationStyle =
  | 'automatic'
  | 'none'
  | 'fullScreen'
  | 'pageSheet'
  | 'formSheet'
  | 'currentContext'
  | 'custom'
  | 'overFullScreen'
  | 'overCurrentContext'
  | 'popover'
  | 'blurOverFullScreen';

/** Maps to `UISheetPresentationController.Detents` */
export type UISheetPresentationControllerDetents =
  | 'medium'
  | 'large';

/** Maps to `UIBlurEffect.Style` */
export type UIBlurEffectStyle =
  | 'systemUltraThinMaterial'
  | 'systemThinMaterial'
  | 'systemMaterial'
  | 'systemThickMaterial'
  | 'systemChromeMaterial'
  | 'systemUltraThinMaterialLight'
  | 'systemThinMaterialLight'
  | 'systemMaterialLight'
  | 'systemThickMaterialLight'
  | 'systemChromeMaterialLight'
  | 'systemUltraThinMaterialDark'
  | 'systemThinMaterialDark'
  | 'systemMaterialDark'
  | 'systemThickMaterialDark'
  | 'systemChromeMaterialDark'
  | 'extraLight'
  | 'light'
  | 'dark'
  | 'extraDark'
  | 'regular'
  | 'prominent';
