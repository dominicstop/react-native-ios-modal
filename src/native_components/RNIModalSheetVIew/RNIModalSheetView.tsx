import * as React from 'react';
import { StyleSheet } from 'react-native';
import { Helpers, type StateViewID, type StateReactTag } from 'react-native-ios-utilities';

import { RNIModalSheetNativeView } from './RNIModalSheetNativeView';
import type { RNIModalSheetViewProps, RNIModalSheetViewRef, } from './RNIModalSheetViewTypes';


export const RNIModalSheetView = React.forwardRef<
  RNIModalSheetViewRef, 
  RNIModalSheetViewProps
>((props, ref) => {
  const [viewID, setViewID] = React.useState<StateViewID>();
  const [reactTag, setReactTag] = React.useState<StateReactTag>();

  React.useImperativeHandle(ref, () => ({
    getReactTag: () => {
      return reactTag;
    },
    getViewID: () => {
      return viewID;
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
  }));

  const reactChildrenCount = React.Children.count(props.children);

  return (
    <RNIModalSheetNativeView
      {...props}
      style={[
        styles.detachedView,
        props.style,
      ]}
      reactChildrenCount={reactChildrenCount}
      onDidSetViewID={(event) => {
        setViewID(event.nativeEvent.viewID);
        setReactTag(event.nativeEvent.reactTag);

        props.onDidSetViewID?.(event);
        event.stopPropagation();
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