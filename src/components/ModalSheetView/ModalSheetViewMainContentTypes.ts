import type { ModalSheetViewContentProps } from './ModalSheetViewContentTypes';


export type ModalSheetViewMainContentInheritedProps = Pick<ModalSheetViewContentProps, 
  | 'contentContainerStyle'
>;

export type ModalSheetViewMainContentBaseProps = {
};

export type ModalSheetViewMainContentProps = 
  & ModalSheetViewMainContentInheritedProps
  & ModalSheetViewMainContentBaseProps;