import type { CGPoint, CGSize } from 'src/types/NativeTypes';
import type { RNIModalData } from 'src/types/RNIModalTypes';

// Event Object Types
// ------------------

/** Based on `RNIModalBaseEventData` */
export type RNIModalBaseEventData = RNIModalData & {
  reactTag: number;
  modalID?: string;
};

/** Based on `RNIOnModalFocusEventData` */
export type RNIOnModalFocusEventData = RNIModalBaseEventData & {
  senderInfo: RNIModalData;
  isInitial: boolean;
};

/** Based on `RNIModalSwipeGestureEventData` */
export type RNIModalSwipeGestureEventData = {
  position: CGPoint;
};

/** Based on `RNIModalDidSnapEventData` */
export type RNIModalDidSnapEventData = {
  selectedDetentIdentifier?: string;
  modalContentSize: CGSize;
};

/** Based on RNIModalDidChangeSelectedDetentIdentifierEventData */
export type RNIModalDidChangeSelectedDetentIdentifierEventData = {
  sheetDetentStringPrevious?: string;
  sheetDetentStringCurrent?: string;
};

/** Based on RNIModalDetentDidComputeEventData */
export type RNIModalDetentDidComputeEventData = {
  maximumDetentValue: number;
  computedDetentValue: number;
  key: string;
};
