import type { OnDidSetViewIDEventPayload } from 'react-native-ios-utilities';

export type ModalSheetContentEntry = {
  didDetachFromOriginalParent: boolean;
};

export type ModalSheetContentMap = 
  Record<OnDidSetViewIDEventPayload['viewID'], ModalSheetContentEntry>;

export const DEFAULT_SHEET_CONTENT_ENTRY: ModalSheetContentEntry = Object.freeze({
  didDetachFromOriginalParent: false,
});