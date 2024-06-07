import type { PropsWithChildren } from "react";
import type { ViewProps } from "react-native";

import type { OnDidSetViewIDEventPayload } from "react-native-ios-utilities";
import type { RNIModalNativeViewProps } from "./RNIModalNativeView";

export type StateViewID = OnDidSetViewIDEventPayload['viewID'] | undefined;
export type StateReactTag = OnDidSetViewIDEventPayload['reactTag'] | undefined;

export type RNIModalViewRef = {
  getViewID: () => StateViewID;
  getReactTag: () => StateReactTag;
};

export type RNIModalViewInheritedOptionalProps = Partial<Pick<RNIModalNativeViewProps,
  | 'onDidSetViewID'
>>;

export type RNIModalViewInheritedRequiredProps = {};

export type RNIModalViewInheritedProps =
    RNIModalViewInheritedOptionalProps
  & RNIModalViewInheritedRequiredProps;

export type RNIModalViewBaseProps = {
  // TBA
};

export type RNIContextMenuViewProps = PropsWithChildren<
    RNIModalViewInheritedProps 
  & RNIModalViewBaseProps
  & ViewProps
>;