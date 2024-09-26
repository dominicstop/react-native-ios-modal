import type { PropsWithChildren } from "react";
import type { ViewProps } from "react-native";
import type { RemapObject } from "react-native-ios-utilities";

import type { RNIModalSheetViewProps, RNIModalSheetViewRef } from "../../native_components/RNIModalSheetVIew";


export type ModalSheetViewRef = RemapObject<Pick<RNIModalSheetViewRef,
  | 'presentModal'
>, {
  presentModal: (commandArgs?: {
    isAnimated?: boolean;
  }) => Promise<void>;
}>;

export type ModalSheetViewInheritedProps = Pick<RNIModalSheetViewProps,
  | 'onDidSetViewID'
  | 'shouldEnableDebugBackgroundColors'
>;

export type ModalSheetViewBaseProps = {};

export type ModalSheetViewProps = PropsWithChildren<
    ModalSheetViewInheritedProps 
  & ModalSheetViewBaseProps
  & ViewProps
>;