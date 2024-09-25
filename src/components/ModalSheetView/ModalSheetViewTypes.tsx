import type { PropsWithChildren } from "react";
import type { ViewProps } from "react-native";

import type { RNIModalSheetViewProps } from "../../native_components/RNIModalSheetVIew";


export type ModalSheetViewRef = {
  presentModal: () => Promise<void>;
};

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