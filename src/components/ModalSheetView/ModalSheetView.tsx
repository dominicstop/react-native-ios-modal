import * as React from 'react';
import { StyleSheet } from 'react-native';

import type { ModalSheetViewProps, ModalSheetViewRef } from './ModalSheetViewTypes';
import type { ModalSheetViewContentProps } from './ModalSheetViewContentTypes';
import type { ModalSheetContentMap } from './ModalSheetContentMap';

import { RNIModalSheetView, type RNIModalSheetViewRef } from '../../native_components/RNIModalSheetVIew';


export const ModalSheetView = React.forwardRef<
  ModalSheetViewRef,
  ModalSheetViewProps
>((props, ref) => {

  const nativeRef = React.useRef<RNIModalSheetViewRef | null>();

  const [
    modalSheetContentMap, 
    setModalSheetContentMap
  ] = React.useState<ModalSheetContentMap>({});

  React.useImperativeHandle(ref, () => ({
    presentModal: async () => {
    },
  }));

  const shouldEnableDebugBackgroundColors = 
    props.shouldEnableDebugBackgroundColors ?? false;

  const children = React.Children.map(props.children, (child) => {
    return React.cloneElement(
      child as React.ReactElement<ModalSheetViewContentProps>, 
      {
        modalSheetContentMap,
      }
    );
  });

  return (
    <RNIModalSheetView
      ref={ref => nativeRef.current = ref}
      style={styles.nativeModalSheet}
    >
      {children}
    </RNIModalSheetView>
  );
});

const styles = StyleSheet.create({
  nativeModalSheet: {
    position: 'absolute',
    pointerEvents: 'none',
    opacity: 0,
  },
});