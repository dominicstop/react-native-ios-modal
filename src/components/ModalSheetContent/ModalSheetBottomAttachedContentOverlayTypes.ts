import type { ModalSheetContentProps } from './ModalSheetContentTypes';


export type ModalSheetViewBottomAttachedContentOverlayInheritedProps = Pick<ModalSheetContentProps, 
  | 'contentContainerStyle'
>;

export type ModalSheetViewBottomAttachedContentOverlayBaseProps = {
};

export type ModalSheetViewBottomAttachedContentOverlayProps = 
  & ModalSheetViewBottomAttachedContentOverlayInheritedProps
  & ModalSheetViewBottomAttachedContentOverlayBaseProps;