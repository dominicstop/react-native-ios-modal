/* eslint-disable prettier/prettier */

import type { RNIComputableOffset } from './RNIComputableOffset';


type RNIComputableValueShared = {
  offset?: RNIComputableOffset;
  minValue?: number;
  maxValue?: number;
};

type RNIComputableValueModeBase = {
  mode: 'current';
} | {
  mode: 'stretch';
} | {
  mode: 'constant';
  constantValue: number;
} | {
  mode: 'percent';
  percentValue: number;
};


export type RNIComputableValue =
  | RNIComputableValueModeBase
  & RNIComputableValueShared;
