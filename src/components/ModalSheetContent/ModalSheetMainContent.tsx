import * as React from 'react';

import { ModalSheetContent } from './ModalSheetContent';
import type { ModalSheetMainContentProps } from './ModalSheetMainContentTypes';
import { ModalSheetViewNativeIDKeys } from '../ModalSheetView/ModalSheetViewNativeIDKeys';


export function ModalSheetMainContent(
  props: React.PropsWithChildren<ModalSheetMainContentProps>
) {
  const { children, ...otherProps } = props;
  return (
    <ModalSheetContent
      {...otherProps}
      nativeID={ModalSheetViewNativeIDKeys.mainSheetContent}
    >
      {children}
    </ModalSheetContent>
  );
};