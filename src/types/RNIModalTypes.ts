/* eslint-disable prettier/prettier */

import type { RNIComputableOffset } from "./RNIComputable";

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

export type RNIModalFocusState =
  | 'INITIAL'
  | 'FOCUSING'
  | 'FOCUSED'
  | 'BLURRING'
  | 'BLURRED';
