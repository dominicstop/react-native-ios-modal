import React from 'react';
import type { ModalSheetViewRef } from '../components/ModalSheetView';

export type ModalSheetViewContextType = {
  getModalSheetViewRef: () => ModalSheetViewRef;
};

export const ModalSheetViewContext = 
  React.createContext<ModalSheetViewContextType | undefined>(undefined);
