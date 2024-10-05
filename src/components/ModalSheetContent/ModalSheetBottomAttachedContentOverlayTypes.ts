import type { ModalSheetContentProps } from './ModalSheetContentTypes';


export type ModalSheetBottomAttachedContentOverlayInheritedProps = Pick<ModalSheetContentProps, 
  | 'contentContainerStyle'
>;

export type ModalSheetBottomAttachedContentOverlayBaseProps = {
};

export type ModalSheetBottomAttachedContentOverlayProps = 
  & ModalSheetBottomAttachedContentOverlayInheritedProps
  & ModalSheetBottomAttachedContentOverlayBaseProps;