import * as React from 'react';

import { ModalSheetViewContent } from './ModalSheetViewContent';
import type { ModalSheetViewMainContentProps } from './ModalSheetViewMainContentTypes';
import { ModalSheetViewNativeIDKeys } from '../ModalSheetView/ModalSheetViewNativeIDKeys';


export function ModalSheetViewMainContent(
  props: React.PropsWithChildren<ModalSheetViewMainContentProps>
) {
  const { children, ...otherProps } = props;
  return (
    <ModalSheetViewContent
      {...otherProps}
      nativeID={ModalSheetViewNativeIDKeys.mainSheetContent}
    >
      {children}
    </ModalSheetViewContent>
  );
};