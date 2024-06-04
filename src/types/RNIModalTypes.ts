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


/** Based on `RNIModalFocusStateMachine.asDictionary` */
export type RNIModalFocusStateMachine = {
  state: ModalFocusState;
  statePrev: ModalFocusState;
  isFocused: boolean;
  isBlurred: boolean;
  isTransitioning: boolean;
  wasBlurCancelled: boolean;
  wasFocusCancelled: boolean;
};

/** Based on `RNIModalPresentationStateMachine.asDictionary` */
export type RNIModalPresentationStateMachine = {
  state: ModalPresentationState;
  statePrev: ModalPresentationState;
  isInitialPresent: boolean;
  isPresented: boolean;
  isDismissed: boolean;
  wasCancelledDismiss: boolean;
  wasCancelledPresent: boolean;
  wasCancelledDismissViaGesture: boolean;
};

/** Based on `RNIModalData` */
export type RNIModalData = {
  modalNativeID: string;

  modalIndex: number;
  modalIndexPrev: number;
  currentModalIndex: number;

  modalFocusState: RNIModalFocusStateMachine;
  modalPresentationState: RNIModalPresentationStateMachine;

  computedIsModalInFocus: boolean;
  computedIsModalPresented: boolean;
  computedModalIndex: number;
  computedViewControllerIndex: number;
  computedCurrentModalIndex: number;

  synthesizedWindowID?: string;
};
