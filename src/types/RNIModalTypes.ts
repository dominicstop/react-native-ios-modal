// prettier-ignore

/** Maps to `RNIModalCustomSheetDetent` */
export type RNIModalCustomSheetDetent = {
  mode: 'relative';
  key: string;
  sizeMultiplier: number;
} | {
  mode: 'constant';
  key: string;
  sizeConstant: number;
};
