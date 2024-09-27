import * as React from 'react';
import { StyleSheet } from 'react-native';
import { Helpers } from 'react-native-ios-utilities';

import type { ModalSheetViewProps, ModalSheetViewRef } from './ModalSheetViewTypes';
import type { ModalSheetViewContentProps } from './ModalSheetViewContentTypes';
import type { ModalSheetContentMap } from './ModalSheetContentMap';

import { RNIModalSheetView, type RNIModalSheetViewRef } from '../../native_components/RNIModalSheetVIew';


export const ModalSheetView = React.forwardRef<
  ModalSheetViewRef,
  ModalSheetViewProps
>((props, ref) => {

  const nativeRef = React.useRef<RNIModalSheetViewRef | null>();

  const callbacksToInvokeOnNextRender = React.useRef<Array<() => void>>([]);
  React.useEffect(() => {
    const totalItems = callbacksToInvokeOnNextRender.current.length;

    for (let index = 0; index < totalItems; index++) {
      const callback = callbacksToInvokeOnNextRender.current.pop();
      callback!();
    };
  });

  const [
    shouldExplicitlyMountModalContents,
    setShouldExplicitlyMountModalContents
  ] = React.useState(false);

  const [
    modalSheetContentMap, 
    setModalSheetContentMap
  ] = React.useState<ModalSheetContentMap>({});

  const isModalContentLazy = props.isModalContentLazy ?? true;

  const shouldMountModalContents = 
       !isModalContentLazy
    || shouldExplicitlyMountModalContents;

  React.useImperativeHandle(ref, () => ({
    presentModal: async (commandArgs) => {
      if(nativeRef.current == null) {
        throw Error("Unable to get ref to native sheet");
      };

      const shouldWaitToMount = 
           !shouldExplicitlyMountModalContents
        && isModalContentLazy;

      setShouldExplicitlyMountModalContents(true);

      if(shouldWaitToMount){
        await Helpers.promiseWithTimeout(300, new Promise<void>(resolve => {
          callbacksToInvokeOnNextRender.current.push(resolve);
        }));
      };

      await nativeRef.current.presentModal({
        isAnimated: true,
        ...commandArgs,
      });
    },
    dismissModal: async (commandArgs) => {
      if(nativeRef.current == null) {
        throw Error("Unable to get ref to native sheet");
      };

      await nativeRef.current.dismissModal({
        isAnimated: true,
        ...commandArgs,
      });
    },
    getCachedModalMetrics: () => {
      return nativeRef.current?.getCachedModalMetrics();
    },
    getModalMetrics: async () => {
      if(nativeRef.current == null) {
        throw Error("Unable to get ref to native sheet");
      };

      return await nativeRef.current.getModalMetrics();
    },
  }));

  const shouldEnableDebugBackgroundColors = 
    props.shouldEnableDebugBackgroundColors ?? false;

  const children = React.Children.map(props.children, (child) => {
    return React.cloneElement(
      child as React.ReactElement<ModalSheetViewContentProps>, 
      {
        modalSheetContentMap,
        shouldMountModalContent: shouldMountModalContents,
      }
    );
  });

  return (
    <RNIModalSheetView
      {...props}
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
    opacity: 0.01,
  },
});