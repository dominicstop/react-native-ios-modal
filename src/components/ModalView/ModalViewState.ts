import type { ModalFocusState } from 'src/types/RNIModalTypes';

export type ModalViewState = {
  isModalVisible: boolean;
  childProps: unknown;
  enableSwipeGesture: boolean;
  isModalInPresentation: boolean;
  isModalInFocus: boolean;

  focusState: ModalFocusState;
};
