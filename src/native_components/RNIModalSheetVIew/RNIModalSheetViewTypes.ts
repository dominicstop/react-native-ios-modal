import type { PropsWithChildren } from "react";
import type { ViewProps } from "react-native";
import type { StateReactTag, StateViewID } from "react-native-ios-utilities";

import type { RNIModalSheetNativeViewProps } from "./RNIModalSheetNativeView";

import type { ModalMetrics } from "../../types/ModalMetrics";
import type { ModalSheetViewEventEmitter } from "../../types/ModalSheetViewEventEmitter";


export type RNIModalSheetViewRef = {
  getViewID: () => StateViewID;
  getReactTag: () => StateReactTag;
  
  getEventEmitter: () => ModalSheetViewEventEmitter;
  
  presentModal: (commandArgs: {
    isAnimated: boolean;
  }) => Promise<void>;

  dismissModal: (commandArgs: {
    isAnimated: boolean;
  }) => Promise<void>;

  getCachedModalMetrics: () => ModalMetrics | undefined;
  getModalMetrics: () => Promise<ModalMetrics>;
};

export type RNIModalSheetViewInheritedOptionalProps = Partial<Pick<RNIModalSheetNativeViewProps,
  // props
  | 'shouldAllowDismissalViaGesture'
  
  // shared/internal events
  | 'onDidSetViewID'
  
  // common modal presentation events
  | 'onModalWillPresent'
  | 'onModalDidPresent'
  | 'onModalWillDismiss'
  | 'onModalDidDismiss'
  | 'onModalWillShow'
  | 'onModalDidShow'
  | 'onModalWillHide'
  | 'onModalDidHide'
  | 'onModalFocusChange'

  // presentation controller delegate events
  | 'onModalSheetWillDismissViaGesture'
  | 'onModalSheetDidDismissViaGesture'
  | 'onModalSheetDidAttemptToDismissViaGesture'

  // modal sheet events
  | 'onModalSheetStateWillChange'
  | 'onModalSheetStateDidChange'
>>;

export type RNIModalSheetViewBaseProps = {
  shouldEnableDebugBackgroundColors?: boolean;
};

export type RNIModalSheetViewProps = PropsWithChildren<
    RNIModalSheetViewInheritedOptionalProps 
  & RNIModalSheetViewBaseProps
  & ViewProps
>;