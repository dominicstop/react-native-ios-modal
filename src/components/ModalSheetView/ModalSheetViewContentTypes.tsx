import type { ViewStyle } from 'react-native';

import type { RNIWrapperViewProps } from 'react-native-ios-utilities';

import type { RNIModalSheetViewProps } from "../../native_components/RNIModalSheetVIew";
import type { ModalSheetContentMap } from "./ModalSheetContentMap";


export type ModalSheetViewContentInheritedProps = Pick<RNIModalSheetViewProps, 
  | 'shouldEnableDebugBackgroundColors'
>;

export type ModalSheetViewContentBaseProps = {
  contentContainerStyle?: ViewStyle;
  isParentDetached?: boolean;
  modalSheetContentMap?: ModalSheetContentMap;
};

export type ModalSheetViewContentProps = 
    RNIWrapperViewProps
  & ModalSheetViewContentInheritedProps
  & ModalSheetViewContentBaseProps;