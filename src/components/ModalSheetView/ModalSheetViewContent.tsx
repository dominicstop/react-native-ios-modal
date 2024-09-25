import * as React from 'react';
import { StyleSheet, View, type StyleProp, type ViewStyle } from 'react-native';

import { RNIWrapperView, type StateViewID } from 'react-native-ios-utilities';

import { DEFAULT_SHEET_CONTENT_ENTRY } from './ModalSheetContentMap';
import type { ModalSheetViewContentProps } from './ModalSheetViewContentTypes';

import { IS_USING_NEW_ARCH } from '../../constants/LibEnv';


export function ModalSheetViewContent(
  props: React.PropsWithChildren<ModalSheetViewContentProps>
) {
  const [viewID, setViewID] = React.useState<StateViewID>();
  
  const wrapperStyle: StyleProp<ViewStyle> = [
    props.shouldEnableDebugBackgroundColors && styles.wrapperViewDebug,
    props.contentContainerStyle,
  ];

  const detachedSubviewEntry = 
       (viewID != null ? props.modalSheetContentMap?.[viewID] : undefined ) 
    ?? DEFAULT_SHEET_CONTENT_ENTRY;

  const didDetach = 
       (props.isParentDetached ?? false)
    || detachedSubviewEntry.didDetachFromOriginalParent;

  return (
    <RNIWrapperView
      {...props}
      style={[
        ...(IS_USING_NEW_ARCH 
          ? wrapperStyle 
          : []
        ),
        (didDetach 
          ? styles.wrapperViewDetached
          : styles.wrapperViewAttached
        ),
        props.style,
      ]}
      onDidSetViewID={(event) => {
        props.onDidSetViewID?.(event);
        setViewID(event.nativeEvent.viewID);

        props.onDidSetViewID?.(event);
        event.stopPropagation();
      }}
    >
      {IS_USING_NEW_ARCH ? (
        props.children
      ) : (
        <View style={[
          styles.innerWrapperContainerForPaper,
          ...wrapperStyle,
        ]}>
          {props.children}
        </View>
      )}
    </RNIWrapperView>
  );
};

const styles = StyleSheet.create({
  wrapperViewAttached: {
  },
  wrapperViewDetached: {
  },
  wrapperViewDebug: {
    backgroundColor: 'rgba(255,0,255,0.3)',
  },
  innerWrapperContainerForPaper: {
    flex: 1,
  },
});
