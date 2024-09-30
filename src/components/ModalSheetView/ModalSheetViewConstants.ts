import type { RNIModalSheetStateMetrics } from "../../types/RNIModalSheetStateMetrics";

export const DEFAULT_MODAL_SHEET_VIEW_METRICS: RNIModalSheetStateMetrics = {
  state: 'dismissed',
  simplified: 'dismissed',
  
  isPresenting: false,
  isPresented: false,
  isDismissing: false,
  isDismissed: true,
  isIdle: true,
};