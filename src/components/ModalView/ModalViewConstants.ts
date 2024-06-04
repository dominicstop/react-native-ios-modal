import React from 'react';
import { ScrollView } from 'react-native';

export const NATIVE_ID_KEYS = {
  modalViewContent: 'modalViewContent',
};

export const VirtualizedListContext = React.createContext(null);

// fix for react-native 0.60
export const hasScrollViewContext: boolean =
  (ScrollView as any).Context?.Provider != null;
