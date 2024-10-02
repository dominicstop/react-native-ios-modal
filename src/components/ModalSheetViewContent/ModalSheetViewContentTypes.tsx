import type { ViewStyle } from 'react-native';
import type { RNIWrapperViewProps } from 'react-native-ios-utilities';

import type { RNIModalSheetViewProps } from "../../native_components/RNIModalSheetVIew";
import type { ModalSheetContentMap } from "../ModalSheetView/ModalSheetContentMap";


export type ModalSheetViewContentInheritedProps = Pick<RNIModalSheetViewProps, 
  | 'shouldEnableDebugBackgroundColors'
> & Pick<RNIWrapperViewProps,
  | 'onDidSetViewID'
  | 'nativeID'
>;

export type ModalSheetViewContentBaseProps = {
  contentContainerStyle?: ViewStyle;
  isParentDetached?: boolean;
  modalSheetContentMap?: ModalSheetContentMap;
  shouldMountModalContent?: boolean;
};

export type ModalSheetViewContentProps = 
  & ModalSheetViewContentInheritedProps
  & ModalSheetViewContentBaseProps;