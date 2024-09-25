/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet, Text } from 'react-native';

import { ExampleItemCard, ObjectPropertyDisplay, CardButton, Colors } from 'react-native-ios-utilities';
import { ModalSheetView, ModalSheetViewContent, type ModalSheetViewRef } from 'react-native-ios-modal';

import type { ExampleItemProps } from './SharedExampleTypes';


export function ModalSheetViewTest01(props: ExampleItemProps) {
  const modalSheetViewRef = React.useRef<ModalSheetViewRef | null>(null);

  return (
    <ExampleItemCard
      style={props.style}
      index={props.index}
      title={'RNIDetachedViewTest02'}
      description={[
        "TBA",
      ]}
    >
      <ObjectPropertyDisplay
        recursiveStyle={styles.debugDisplayInner}
        object={undefined}
      />
      <CardButton
        title={'Present Sheet Modal'}
        subtitle={'Present content as sheet'}
        onPress={() => {
        }}
      />
      <ModalSheetView
        ref={ref => modalSheetViewRef.current = ref}
      >
        <ModalSheetViewContent
          contentContainerStyle={styles.modalContent}
        >
          <Text>
            {'Hello World'}
          </Text>
        </ModalSheetViewContent>
      </ModalSheetView>
    </ExampleItemCard>
  );
};

const styles = StyleSheet.create({
  modalContent: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  debugDisplayInner: {
    backgroundColor: `${Colors.PURPLE[200]}99`,
  },
});