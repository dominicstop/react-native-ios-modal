/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet, Text, View } from 'react-native';

import { ExampleItemCard, CardButton, Colors } from 'react-native-ios-utilities';
import { ModalSheetView, ModalSheetViewContext, ModalSheetMainContent, type ModalSheetViewRef, ModalSheetBottomAttachedContentOverlay } from 'react-native-ios-modal';

import type { ExampleItemProps } from './SharedExampleTypes';


export function ModalSheetViewTest04(props: ExampleItemProps) {
  const modalSheetViewRef = React.useRef<ModalSheetViewRef | null>(null);
  const modalContext = React.useContext(ModalSheetViewContext);


  return (
    <ExampleItemCard
      style={props.style}
      index={props.index}
      title={'ModalSheetViewTest04'}
      description={[
        "TBA",
      ]}
    >
      <CardButton
        title={'Present Sheet Modal'}
        subtitle={'Present content as sheet'}
        onPress={async () => {
          await modalSheetViewRef.current?.presentModal();
        }}
      />
      <ModalSheetView
        ref={ref => modalSheetViewRef.current = ref}
      >
        <ModalSheetMainContent
          contentContainerStyle={styles.modalContent}
        >
          <View style={styles.modalContentDummy}>
            <Text style={styles.modalContentDummyLabel}>
              {'Main Content'}
            </Text>
          </View>
        </ModalSheetMainContent>
        <ModalSheetBottomAttachedContentOverlay
          contentContainerStyle={styles.modalBottomOverlayContent}
        >
          <View style={styles.bottomContentDummy}>
            <Text>
              {'Bottom Content'}
            </Text>
          </View>
        </ModalSheetBottomAttachedContentOverlay>
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
  modalContentDummy: {
    padding: 32,
    backgroundColor: Colors.PURPLE[100],
    borderRadius: 12,
  },
  modalContentDummyLabel: {
    fontSize: 16,
  },
  modalBottomOverlayContent: {
    backgroundColor: Colors.PURPLE[100],
  },
  bottomContentDummy: {
  },
});