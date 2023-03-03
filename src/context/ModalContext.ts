import React from 'react';
import type { ModalView, ModalViewState } from 'src/components/ModalView';

// prettier-ignore
export type ModalContextType = Partial<
  // `ModalView` Methods #1
  Pick<
      ModalView,
      | 'getEmitterRef'
      | 'setVisibility'
      | 'setEnableSwipeGesture'
      | 'setIsModalInPresentation'
    >
  // `ModalView` State
  & Pick<
      ModalViewState,
      | 'isModalInFocus'
      | 'isModalVisible'
    >
  // `ModalView` Methods #2
  & {
    getModalRef: ModalView['_handleGetModalRef'];
  }
>;

export const ModalContext = React.createContext<ModalContextType>({});
