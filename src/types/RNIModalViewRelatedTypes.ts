/** Maps to `RNIModalFocusState` */
export type ModalFocusState =
  | 'INITIAL'
  | 'FOCUSING'
  | 'FOCUSED'
  | 'BLURRING'
  | 'BLURRED';

/** Maps to `RNIModalPresentationState` */
export type ModalPresentationState =
  | 'INITIAL'
  | 'PRESENTING_PROGRAMMATIC'
  | 'PRESENTING_UNKNOWN'
  | 'PRESENTED'
  | 'PRESENTED_UNKNOWN'
  | 'DISMISSING_GESTURE'
  | 'DISMISSING_PROGRAMMATIC'
  | 'DISMISSING_UNKNOWN'
  | 'DISMISS_GESTURE_CANCELLING'
  | 'DISMISSED';
