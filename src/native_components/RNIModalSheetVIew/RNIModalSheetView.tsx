import * as React from 'react';
import { StyleSheet } from 'react-native';

import { Helpers, type StateViewID, type StateReactTag } from 'react-native-ios-utilities';
import { TSEventEmitter } from '@dominicstop/ts-event-emitter';

import { RNIModalSheetNativeView } from './RNIModalSheetNativeView';
import { useLazyRef } from '../../hooks/useLazyRef';

import type { RNIModalSheetViewProps, RNIModalSheetViewRef, } from './RNIModalSheetViewTypes';
import type { ModalMetrics } from '../../types/ModalMetrics';
import type { ModalSheetViewEventEmitter } from '../../functions/ModalSheetViewEventEmitter';


export const RNIModalSheetView = React.forwardRef<
  RNIModalSheetViewRef, 
  RNIModalSheetViewProps
>((props, ref) => {
  const [viewID, setViewID] = React.useState<StateViewID>();
  const [reactTag, setReactTag] = React.useState<StateReactTag>();

  const modalEventEmitterRef = 
    useLazyRef<ModalSheetViewEventEmitter>(() => new TSEventEmitter());
  
  const [
    cachedModalMetrics, 
    setCachedModalMetrics
  ] = React.useState<ModalMetrics | undefined>();

  React.useImperativeHandle(ref, () => ({
    getReactTag: () => {
      return reactTag;
    },
    getViewID: () => {
      return viewID;
    },
    getEventEmitter: () => {
      return modalEventEmitterRef.current!;
    },
    presentModal: async (commandArgs) => {
      if(viewID == null) return;
      const module = Helpers.getRNIUtilitiesModule();

      await module.viewCommandRequest(
        /* viewID     : */ viewID,
        /* commandName: */ 'presentModal',
        /* commandArgs: */ commandArgs,
      );
    },
    dismissModal: async (commandArgs) => {
      if(viewID == null) return;
      const module = Helpers.getRNIUtilitiesModule();

      await module.viewCommandRequest(
        /* viewID     : */ viewID,
        /* commandName: */ 'dismissModal',
        /* commandArgs: */ commandArgs,
      );
    },
    getCachedModalMetrics: () => {
      return cachedModalMetrics;
    },
    getModalMetrics: async () => {
      if(viewID == null) return;
      const module = Helpers.getRNIUtilitiesModule();

      const result = await module.viewCommandRequest(
        /* viewID     : */ viewID,
        /* commandName: */ 'getModalMetrics',
        /* commandArgs: */ {},
      );

      setCachedModalMetrics(result as any);
      return result as any;
    },
  }));

  const reactChildrenCount = React.Children.count(props.children);

  return (
    <RNIModalSheetNativeView
      {...props}
      style={[
        styles.detachedView,
        styles.detachedViewDebug,
        props.style,
      ]}
      reactChildrenCount={reactChildrenCount}
      onDidSetViewID={(event) => {
        setViewID(event.nativeEvent.viewID);
        setReactTag(event.nativeEvent.reactTag);

        props.onDidSetViewID?.(event);
        event.stopPropagation();
      }}
      onModalWillPresent={(event) => {
        props.onModalWillPresent?.(event);
        event.stopPropagation();

        modalEventEmitterRef.current!.emit(
          'onModalWillPresent',
          event.nativeEvent
        );
      }}
      onModalDidPresent={(event) => {
        props.onModalDidPresent?.(event);
        event.stopPropagation();

        modalEventEmitterRef.current!.emit(
          'onModalDidPresent',
          event.nativeEvent
        );
      }}
      onModalWillShow={(event) => {
        props.onModalWillShow?.(event);
        event.stopPropagation();

        modalEventEmitterRef.current!.emit(
          'onModalWillShow',
          event.nativeEvent
        );
      }}
      onModalDidShow={(event) => {
        props.onModalDidShow?.(event);
        event.stopPropagation();

        modalEventEmitterRef.current!.emit(
          'onModalDidShow',
          event.nativeEvent
        );
      }}
      onModalWillHide={(event) => {
        props.onModalWillHide?.(event);
        event.stopPropagation();

        modalEventEmitterRef.current!.emit(
          'onModalWillHide',
          event.nativeEvent
        );
      }}
      onModalDidHide={(event) => {
        props.onModalDidHide?.(event);
        event.stopPropagation();

        modalEventEmitterRef.current!.emit(
          'onModalDidHide',
          event.nativeEvent
        );
      }}
    >
      {props.children}
    </RNIModalSheetNativeView>
  );
});

const styles = StyleSheet.create({
  detachedView: {
    position: 'absolute',
    pointerEvents: 'none',
    opacity: 0,
  },
  detachedViewDebug: {
    backgroundColor: 'rgba(255,0,0,0.3)',
  },
});