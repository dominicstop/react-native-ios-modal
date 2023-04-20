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
export type TUISheetPresentationControllerDetents = 'medium' | 'large';
