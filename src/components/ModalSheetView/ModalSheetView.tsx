import * as React from 'react';
import { StyleSheet } from 'react-native';
import { Helpers } from 'react-native-ios-utilities';

import type { ModalSheetViewProps, ModalSheetViewRef } from './ModalSheetViewTypes';
import type { ModalSheetViewContentProps } from './ModalSheetViewContentTypes';
import type { ModalSheetContentMap } from './ModalSheetContentMap';

import { RNIModalSheetView, type RNIModalSheetViewRef } from '../../native_components/RNIModalSheetVIew';
import { ModalSheetViewContext, type ModalSheetViewContextType } from '../../context/ModalSheetViewContext';
import { useLazyRef } from '../../hooks/useLazyRef';

import { DEFAULT_MODAL_SHEET_VIEW_METRICS as MODAL_SHEET_STATE_METRICS_DEFAULT } from './ModalSheetViewConstants';
import type { RNIModalSheetStateMetrics } from '../../types/RNIModalSheetStateMetrics';


export const ModalSheetView = React.forwardRef<
  ModalSheetViewRef,
  ModalSheetViewProps
>((props, ref) => {

  const nativeRef = React.useRef<RNIModalSheetViewRef | null>();

  const [
    prevModalSheetStateMetrics,
    setPrevModalSheetStateMetrics,
  ] = React.useState<RNIModalSheetStateMetrics | undefined>();

  const [
    currentModalSheetStateMetrics,
    setCurrentModalSheetStateMetrics,
  ] = React.useState<RNIModalSheetStateMetrics>(MODAL_SHEET_STATE_METRICS_DEFAULT);

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

  const rawRef = useLazyRef<ModalSheetViewRef>(() => ({
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

      const eventEmitter = nativeRef.current!.getEventEmitter();

      await Promise.all([
        nativeRef.current.presentModal({
          isAnimated: true,
          ...commandArgs,
        }),
        new Promise<void>(resolve => {
          eventEmitter.once('onModalDidShow', () => {
            resolve();
          });
        }),
      ]);
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
    getEventEmitter: () => {
      return nativeRef.current!.getEventEmitter();
    },
  }));

  React.useImperativeHandle(ref, () => rawRef.current!);

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

  const contextValue: ModalSheetViewContextType = {
    prevModalSheetStateMetrics,
    currentModalSheetStateMetrics,
    getModalSheetViewRef: () => rawRef.current!
  };

  return (
    <ModalSheetViewContext.Provider value={contextValue}>
      <RNIModalSheetView
        {...props}
        ref={ref => nativeRef.current = ref}
        style={styles.nativeModalSheet}
        onModalDidDismiss={(event) => {
          setShouldExplicitlyMountModalContents(false);

          props.onModalDidDismiss?.(event);
          event.stopPropagation();
        }}
        onModalSheetStateDidChange={(event) => {
          setPrevModalSheetStateMetrics(event.nativeEvent.prevState);
          setCurrentModalSheetStateMetrics(event.nativeEvent.currentState);

          props.onModalSheetStateDidChange?.(event);
          event.stopPropagation();
        }}
      >
        {children}
      </RNIModalSheetView>
    </ModalSheetViewContext.Provider>
  );
});

const styles = StyleSheet.create({
  nativeModalSheet: {
    position: 'absolute',
    opacity: 0.01,
  },
});