/* eslint-disable prettier/prettier */

export type CGSize = {
  width: number;
  height: number;
};

export type CGPoint = {
  x: number;
  y: number;
};

export type TUIModalTransitionStyle =
  | 'coverVertical'
  | 'flipHorizontal'
  | 'crossDissolve'
  | 'partialCurl';

export type TUIModalPresentationStyle =
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
export type TUISheetPresentationControllerDetents =
  | 'medium'
  | 'large';

/** Maps to `UIBlurEffect.Style` */
export type TUIBlurEffectStyles =
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
