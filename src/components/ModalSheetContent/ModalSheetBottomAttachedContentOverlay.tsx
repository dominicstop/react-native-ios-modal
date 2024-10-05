import * as React from 'react';

import { ModalSheetContent } from './ModalSheetContent';
import { ModalSheetViewNativeIDKeys } from '../ModalSheetView/ModalSheetViewNativeIDKeys';

import type { ModalSheetBottomAttachedContentOverlayProps } from './ModalSheetBottomAttachedContentOverlayTypes';


export function ModalSheetBottomAttachedContentOverlay(
  props: React.PropsWithChildren<ModalSheetBottomAttachedContentOverlayProps>
) {
  const { children, ...otherProps } = props;
  return (
    <ModalSheetContent
      {...otherProps}
      nativeID={ModalSheetViewNativeIDKeys.bottomAttachedSheetOverlay}
    >
      {children}
    </ModalSheetContent>
  );
};