import type { PropsWithChildren } from "react";
import type { ViewProps } from "react-native";
import type { StateReactTag, StateViewID } from "react-native-ios-utilities";

import type { RNIModalSheetNativeViewProps } from "./RNIModalSheetNativeView";


export type RNIModalSheetViewRef = {
  getViewID: () => StateViewID;
  getReactTag: () => StateReactTag;
  
  presentModal: (commandArgs: {
    isAnimated: boolean;
  }) => Promise<void>;

  dismissModal: (commandArgs: {
    isAnimated: boolean;
  }) => Promise<void>;
};

export type RNIModalSheetViewInheritedOptionalProps = Partial<Pick<RNIModalSheetNativeViewProps,
  // shared/internal events
  | 'onDidSetViewID'
>>;

export type RNIModalSheetViewBaseProps = {
  shouldEnableDebugBackgroundColors?: boolean;
  contentContainerStyle?: ViewProps['style'];
};

export type RNIModalSheetViewProps = PropsWithChildren<
    RNIModalSheetViewInheritedOptionalProps 
  & RNIModalSheetViewBaseProps
  & ViewProps
>;