/* eslint-disable prettier/prettier */

import type { RNIComputableOffset } from './RNIComputableOffset';
import type { RNIComputableValue, RNIComputableValueNative, RNIComputableValueViewModeArgs } from './RNIComputableValue';

type Size = {
  width: number;
  height: number;
};

type RNIComputableSizeFunctionMode = RNIComputableValue<
  RNIComputableValueViewModeArgs,
  Size
> & {
  mode: 'function';
};

type RNIComputableSizeFunctionModeNative = RNIComputableValueNative & {
  mode: 'function';
};

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
  | RNIComputableSizeFunctionMode
  & RNIComputableSizeShared;

export type RNIComputableSizeNative =
  | RNIComputableSizeModeBase
  | RNIComputableSizeFunctionModeNative
  & RNIComputableSizeShared;

export function parseRNIComputableSize(
  value: RNIComputableSize
): RNIComputableSizeNative {

  if (value.mode === 'function'){
    return {
      ...value,
      valueFunction: value.valueFunction?.toString(),
    };
  }
  return value;
}
