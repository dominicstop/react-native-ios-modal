import type { PropsWithChildren } from "react";
import type { ViewProps } from "react-native";
import type { RemapObject } from "react-native-ios-utilities";

import type { RNIModalSheetViewProps, RNIModalSheetViewRef } from "../../native_components/RNIModalSheetVIew";


type ModalSheetViewRefInheritedRaw = Pick<RNIModalSheetViewRef,
  | 'presentModal'
  | 'dismissModal'
>;

export type ModalSheetViewRef = RemapObject<ModalSheetViewRefInheritedRaw, {
  presentModal: (commandArgs?: {
    isAnimated?: boolean;
  }) => Promise<void>;

  dismissModal: (commandArgs?: {
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