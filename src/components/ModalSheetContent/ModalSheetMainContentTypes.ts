import type { ModalSheetContentProps } from './ModalSheetContentTypes';


export type ModalSheetMainContentInheritedProps = Pick<ModalSheetContentProps, 
  | 'contentContainerStyle'
>;

export type ModalSheetMainContentBaseProps = {
};

export type ModalSheetMainContentProps = 
  & ModalSheetMainContentInheritedProps
  & ModalSheetMainContentBaseProps;