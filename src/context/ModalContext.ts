import React from 'react';
import type { ModalView } from 'src/components/ModalView';

export type ModalContextType = Partial<
  Pick<
    ModalView,
    | 'getEmitterRef'
    | 'setVisibility'
    | 'setEnableSwipeGesture'
    | 'setIsModalInPresentation'
  > & {
    getModalRef: ModalView['_handleGetModalRef'];
  }
>;

export const ModalContext = React.createContext<ModalContextType>({});
