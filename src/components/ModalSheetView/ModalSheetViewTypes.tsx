import type { PropsWithChildren } from "react";
import type { ViewProps } from "react-native";
import type { RemapObject } from "react-native-ios-utilities";

import type { RNIModalSheetViewProps, RNIModalSheetViewRef } from "../../native_components/RNIModalSheetVIew";


type ModalSheetViewRefInherited = Pick<RNIModalSheetViewRef,
  | 'getModalMetrics'
>;

type ModalSheetViewRefInheritedRaw = Pick<RNIModalSheetViewRef,
  | 'presentModal'
  | 'dismissModal'
>;

type ModalSheetViewRefInheritedRemapped = RemapObject<ModalSheetViewRefInheritedRaw, {
  presentModal: (commandArgs?: {
    isAnimated?: boolean;
  }) => Promise<void>;

  dismissModal: (commandArgs?: {
    isAnimated?: boolean;
  }) => Promise<void>;
}>;


export type ModalSheetViewRef =
    ModalSheetViewRefInherited
  & ModalSheetViewRefInheritedRemapped;

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