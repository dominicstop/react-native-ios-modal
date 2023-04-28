/* eslint-disable prettier/prettier */

export type RNIViewMetadata = {
  tag: number;
  reactTag?: number;
  nativeID?: string;

  width: number;
  height: number;

  parentView?: RNIViewMetadata;
  childViews?: RNIViewMetadata[];
};

export type RNIComputableValueEnvironmentFunctions = {
  getView: (view:
    | { tag: number }
    | { reactTag: number }
    | { nativeID: string }
  ) => RNIViewMetadata | null;

  getWindowSize: () => {
    width: number;
    height: number;
  };

  getScreenSize: () => {
    width: number;
    height: number;
  };
};

export type RNIComputableValueViewEnvironment = {
  parentView?: RNIViewMetadata;
  rootView?: RNIViewMetadata;
};

export type RNIComputableValueViewModeArgs =
  & RNIComputableValueEnvironmentFunctions
  & RNIComputableValueViewEnvironment;

export type RNIComputableValueNative = {
  valueFunction: string;
  extraData?: object;
};

export type RNIComputableValue<FunctionArgs, FunctionReturn> = {
  valueFunction: (args: FunctionArgs) => FunctionReturn;
  extraData?: object;
};
