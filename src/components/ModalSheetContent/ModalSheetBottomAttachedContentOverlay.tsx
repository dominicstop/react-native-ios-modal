import * as React from 'react';

import { ModalSheetContent } from './ModalSheetContent';
import { ModalSheetViewNativeIDKeys } from '../ModalSheetView/ModalSheetViewNativeIDKeys';

import type { ModalSheetViewBottomAttachedContentOverlayProps } from './ModalSheetBottomAttachedContentOverlayTypes';


export function ModalSheetViewBottomAttachedContentOverlay(
  props: React.PropsWithChildren<ModalSheetViewBottomAttachedContentOverlayProps>
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