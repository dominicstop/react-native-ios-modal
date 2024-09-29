/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet } from 'react-native';

import { ExampleItemCard, ObjectPropertyDisplay, CardButton, Colors } from 'react-native-ios-utilities';
import { ModalSheetView, ModalSheetViewContext, ModalSheetViewMainContent, useModalSheetViewEvents, type ModalSheetViewRef } from 'react-native-ios-modal';

import { LogListDisplay, type LogListDisplayRef } from '../components/LogListDisplay';
import type { ExampleItemProps } from './SharedExampleTypes';


function ModalContent(props: {
  recursionLevel?: number
}){
  const nextModalRef = React.useRef<ModalSheetViewRef | null>(null);
  const logListDisplayRef = React.useRef<LogListDisplayRef | null>(null);

  const modalContext = React.useContext(ModalSheetViewContext);
  const recursionLevel = props.recursionLevel ?? 0;

  useModalSheetViewEvents('onModalWillPresent', () => {
    logListDisplayRef.current?.addItem('onModalWillPresent');
  });

  useModalSheetViewEvents('onModalDidPresent', () => {
    logListDisplayRef.current?.addItem('onModalDidPresent');
  });

  useModalSheetViewEvents('onModalWillShow', () => {
    logListDisplayRef.current?.addItem('onModalWillShow');
  });

  useModalSheetViewEvents('onModalDidShow', () => {
    logListDisplayRef.current?.addItem('onModalDidShow');
  });

  useModalSheetViewEvents('onModalWillHide', () => {
    logListDisplayRef.current?.addItem('onModalWillHide');
  });

  useModalSheetViewEvents('onModalDidHide', () => {
    logListDisplayRef.current?.addItem('onModalDidHide');
  });

  useModalSheetViewEvents('onModalSheetStateWillChange', () => {
    logListDisplayRef.current?.addItem('onModalSheetStateWillChange');
  });

  useModalSheetViewEvents('onModalSheetStateDidChange', () => {
    logListDisplayRef.current?.addItem('onModalSheetStateDidChange');
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
      <ObjectPropertyDisplay
        recursiveStyle={styles.debugDisplayInner}
        object={{
          prevState: {
            state: modalContext?.prevModalSheetStateMetrics?.state,
            simplified: modalContext?.prevModalSheetStateMetrics?.simplified,
            isPresenting: modalContext?.prevModalSheetStateMetrics?.isPresenting,
            isPresented: modalContext?.prevModalSheetStateMetrics?.isPresented,
            isDismissing: modalContext?.prevModalSheetStateMetrics?.isDismissing,
            isDismissed: modalContext?.prevModalSheetStateMetrics?.isDismissed,
            ...modalContext?.prevModalSheetStateMetrics,
          },
          currentState: {
            state: modalContext?.currentModalSheetStateMetrics.state,
            simplified: modalContext?.currentModalSheetStateMetrics.simplified,
            isPresenting: modalContext?.currentModalSheetStateMetrics.isPresenting,
            isPresented: modalContext?.currentModalSheetStateMetrics.isPresented,
            isDismissing: modalContext?.currentModalSheetStateMetrics.isDismissing,
            isDismissed: modalContext?.currentModalSheetStateMetrics.isDismissed,
            ...modalContext?.currentModalSheetStateMetrics,
          },
        }}
      />
      <LogListDisplay
        ref={ref => logListDisplayRef.current = ref}
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

export function ModalSheetViewTest02(props: ExampleItemProps) {
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