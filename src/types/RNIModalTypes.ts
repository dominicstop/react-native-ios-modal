/* eslint-disable prettier/prettier */

import type { RNIComputableOffset } from './RNIComputable';

/** Maps to `RNIModalCustomSheetDetent` */
export type RNIModalCustomSheetDetent = Partial<RNIComputableOffset> & {
  mode: 'relative';
  key: string;
  sizeMultiplier: number;
} | {
  mode: 'constant';
  key: string;
  sizeConstant: number;
};

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

/** Based on `RNIModalData` */
export type RNIModalData = {
  modalNativeID: string;
  modalIndex: number;
  modalIndexPrev: number;
  currentModalIndex: number;
  modalFocusState: ModalFocusState;
  modalFocusStatePref: ModalFocusState;
  wasBlurCancelled: boolean;
  wasFocusCancelled: boolean;
  modalPresentationState: ModalPresentationState;
  modalPresentationStatePrev: ModalPresentationState;
  isInitialPresent: boolean;
  wasCancelledPresent: boolean;
  wasCancelledDismiss: boolean;
  wasCancelledDismissViaGesture: boolean;
  isModalPresented: boolean;
  isModalInFocus: boolean;
  computedIsModalInFocus: boolean;
  computedIsModalPresented: boolean;
  computedModalIndex: number;
  computedViewControllerIndex: number;
  computedCurrentModalIndex: number;
  synthesizedWindowID?: string;
};