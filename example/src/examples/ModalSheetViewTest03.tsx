/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet } from 'react-native';

import { ExampleItemCard, CardButton, Colors } from 'react-native-ios-utilities';
import { ModalSheetView, ModalSheetViewContext, ModalSheetViewMainContent, useModalSheetViewEvents, type ModalSheetViewRef } from 'react-native-ios-modal';

import { LogListDisplay, type LogListDisplayRef } from '../components/LogListDisplay';
import type { ExampleItemProps } from './SharedExampleTypes';


function ModalContent(props: {
  recursionLevel?: number
}){
  const nextModalRef = React.useRef<ModalSheetViewRef | null>(null);
  const presentationEventsLogListDisplayRef = React.useRef<LogListDisplayRef | null>(null);
  const focusStateLogListDisplayRef = React.useRef<LogListDisplayRef | null>(null);

  const modalContext = React.useContext(ModalSheetViewContext);
  const recursionLevel = props.recursionLevel ?? 0;

  useModalSheetViewEvents('onModalWillPresent', () => {
    presentationEventsLogListDisplayRef.current?.addItem('onModalWillPresent');
  });

  useModalSheetViewEvents('onModalDidPresent', () => {
    presentationEventsLogListDisplayRef.current?.addItem('onModalDidPresent');
  });

  useModalSheetViewEvents('onModalWillDismiss', () => {
    presentationEventsLogListDisplayRef.current?.addItem('onModalWillDismiss');
  });

  useModalSheetViewEvents('onModalDidDismiss', () => {
    presentationEventsLogListDisplayRef.current?.addItem('onModalDidDismiss');
  });

  useModalSheetViewEvents('onModalWillShow', () => {
    presentationEventsLogListDisplayRef.current?.addItem('onModalWillShow');
  });

  useModalSheetViewEvents('onModalDidShow', () => {
    presentationEventsLogListDisplayRef.current?.addItem('onModalDidShow');
  });

  useModalSheetViewEvents('onModalWillHide', () => {
    presentationEventsLogListDisplayRef.current?.addItem('onModalWillHide');
  });

  useModalSheetViewEvents('onModalDidHide', () => {
    presentationEventsLogListDisplayRef.current?.addItem('onModalDidHide');
  });

  useModalSheetViewEvents('onModalFocusChange', (eventPayload) => {
    presentationEventsLogListDisplayRef.current?.addItem('onModalFocusChange');
    focusStateLogListDisplayRef.current?.addItem(eventPayload.nextState);
  });

  useModalSheetViewEvents('onModalSheetStateWillChange', () => {
    presentationEventsLogListDisplayRef.current?.addItem('onModalSheetStateWillChange');
  });

  useModalSheetViewEvents('onModalSheetStateDidChange', () => {
    presentationEventsLogListDisplayRef.current?.addItem('onModalSheetStateDidChange');
  });

  return (
    <ModalSheetViewMainContent
      // temp fix
      {...{...props}}
      contentContainerStyle={styles.modalContentContainer}
    >
    <ExampleItemCard
      style={styles.modalContentCard}
      title={`Modal #${recursionLevel}`}
    >
      <LogListDisplay
        ref={ref => presentationEventsLogListDisplayRef.current = ref}
      />
      <LogListDisplay
        ref={ref => focusStateLogListDisplayRef.current = ref}
      />
      <CardButton
        title={'Present Sheet Modal'}
        subtitle={'Present content as sheet'}
        onPress={async () => {
          await nextModalRef.current?.presentModal();
        }}
      />
      <CardButton
        title={'Dismiss Modal'}
        subtitle={'Dismiss current modal'}
        onPress={async () => {
          const prevModalRef = modalContext?.getModalSheetViewRef();
          
          if(prevModalRef == null){
            return;
          };

          await prevModalRef.dismissModal();
        }}
      />
    </ExampleItemCard>
    <ModalSheetView
      ref={ref => nextModalRef.current = ref}
    >
      <ModalContent
        recursionLevel={recursionLevel + 1}
      />
    </ModalSheetView>
    </ModalSheetViewMainContent>
  );
};

export function ModalSheetViewTest03(props: ExampleItemProps) {
  const modalSheetViewRef = React.useRef<ModalSheetViewRef | null>(null);

  return (
    <ExampleItemCard
      style={props.style}
      index={props.index}
      title={'ModalSheetViewTest02'}
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
        <ModalContent/>
      </ModalSheetView>
    </ExampleItemCard>
  );
};

const styles = StyleSheet.create({
  debugDisplayInner: {
    backgroundColor: `${Colors.PURPLE[200]}99`,
  },
  modalContentContainer: {
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