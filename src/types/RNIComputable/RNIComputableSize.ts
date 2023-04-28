/* eslint-disable prettier/prettier */

import type { RNIComputableOffset } from './RNIComputableOffset';


type RNIComputableSizeShared = {
  offsetWidth?: RNIComputableOffset;
  offsetHeight?: RNIComputableOffset;
};

type RNIComputableSizeModeBase = {
  mode: 'current';
} | {
  mode: 'stretch';
} | {
  mode: 'constant';
  constantWidth: number;
  constantHeight: number;
} | {
  mode: 'percent';
  percentWidth: number;
  percentHeight: number;
};


export type RNIComputableSize =
  | RNIComputableSizeModeBase
  & RNIComputableSizeShared;
