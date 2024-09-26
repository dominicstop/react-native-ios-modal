/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet, Text, TouchableOpacity } from 'react-native';

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
        onPress={async () => {
          await modalSheetViewRef.current?.presentModal();
          console.log(
            'ModalSheetViewTest01',
            '\n - present modal completed'
          );
        }}
      />
      <ModalSheetView
        ref={ref => modalSheetViewRef.current = ref}
      >
        <ModalSheetViewContent
          contentContainerStyle={styles.modalContent}
        >
          <ExampleItemCard
            title={'RNIDetachedViewTest02'}
            style={styles.modalContentCard}
          >
            <ObjectPropertyDisplay
              recursiveStyle={styles.debugDisplayInner}
              object={undefined}
            />
            <CardButton
              title={'Dismiss Modal'}
              subtitle={'Dismiss current modal'}
              onPress={async () => {
                await modalSheetViewRef.current?.dismissModal();
                console.log(
                  'ModalSheetViewTest01',
                  '\n - dismiss modal completed'
                );
              }}
            />
          </ExampleItemCard>
        </ModalSheetViewContent>
      </ModalSheetView>
    </ExampleItemCard>
  );
};

const styles = StyleSheet.create({
  debugDisplayInner: {
    backgroundColor: `${Colors.PURPLE[200]}99`,
  },
  modalContent: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 12,
    paddingVertical: 24,
  },
  modalContentCard: {
    alignSelf: 'stretch',
  },
});