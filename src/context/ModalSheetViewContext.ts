import React from 'react';

import type { ModalSheetViewRef } from '../components/ModalSheetView/ModalSheetViewTypes';
import type { RNIModalSheetStateMetrics } from '../types/RNIModalSheetStateMetrics';


export type ModalSheetViewContextType = {
  prevModalSheetStateMetrics: RNIModalSheetStateMetrics | undefined;
  currentModalSheetStateMetrics: RNIModalSheetStateMetrics;
  
  getModalSheetViewRef: () => ModalSheetViewRef;
};

export const ModalSheetViewContext = 
  React.createContext<ModalSheetViewContextType | undefined>(undefined);
