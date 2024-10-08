import type { PropsWithChildren } from "react";
import type { RemapObject } from "react-native-ios-utilities";

import type { RNIModalSheetViewProps, RNIModalSheetViewRef } from "../../native_components/RNIModalSheetVIew";


type ModalSheetViewRefInherited = Pick<RNIModalSheetViewRef,
  | 'getCachedModalMetrics'
  | 'getModalMetrics'
  | 'getEventEmitter'
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
  | 'shouldAllowDismissalViaGesture'
  | 'shouldEnableDebugBackgroundColors'

  // common view events
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
>;

export type ModalSheetViewBaseProps = {
  isModalContentLazy?: boolean;
};

export type ModalSheetViewProps = PropsWithChildren<
    ModalSheetViewInheritedProps 
  & ModalSheetViewBaseProps
>;