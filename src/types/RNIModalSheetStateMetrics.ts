import type { ModalSheetState } from "./ModalSheetState";


export type RNIModalSheetStateMetrics = {
  state: ModalSheetState;
  simplified: ModalSheetState;
  
  isPresenting: boolean;
  isPresented: boolean;
  isDismissing: boolean;
  isDismissed: boolean;
};