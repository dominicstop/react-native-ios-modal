/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet } from 'react-native';

import { ExampleItemCard, ObjectPropertyDisplay, CardButton, Colors } from 'react-native-ios-utilities';
import { ModalSheetView, ModalSheetViewContext, ModalSheetViewMainContent, useModalSheetViewEvents, type ModalSheetViewRef, type OnModalFocusChangeEventPayload } from 'react-native-ios-modal';

import type { ExampleItemProps } from './SharedExampleTypes';
import type { OnModalSheetStateWillChangeEventPayload } from '../../../src/native_components/RNIModalSheetVIew';


function ModalContent(props: {
  recursionLevel?: number
}){
  const nextModalRef = React.useRef<ModalSheetViewRef | null>(null);

  const [
    onModalSheetStateWillChangeEventPayload,
    setOModalSheetStateWillChangeEventPayload,
  ] = React.useState<OnModalSheetStateWillChangeEventPayload | null>(null);
  
  const [
    focusChangeEventPayload,
    setFocusChangeEventPayload
  ] = React.useState<OnModalFocusChangeEventPayload | null>(null);

  const modalContext = React.useContext(ModalSheetViewContext);
  const recursionLevel = props.recursionLevel ?? 0;
  
  useModalSheetViewEvents('onModalFocusChange', (eventPayload) => {
    setFocusChangeEventPayload(eventPayload);
  });

  useModalSheetViewEvents('onModalSheetStateWillChange', (eventPayload) => {
    setOModalSheetStateWillChangeEventPayload(eventPayload);
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
          viewControllerInstanceID: [
            onModalSheetStateWillChangeEventPayload?.viewControllerInstanceID,
          ],
          prevState: {
            state: modalContext?.prevModalSheetStateMetrics?.state,
            simplified: modalContext?.prevModalSheetStateMetrics?.simplified,
            isPresenting: modalContext?.prevModalSheetStateMetrics?.isPresenting,
            isPresented: modalContext?.prevModalSheetStateMetrics?.isPresented,
            isDismissing: modalContext?.prevModalSheetStateMetrics?.isDismissing,
            isDismissed: modalContext?.prevModalSheetStateMetrics?.isDismissed,
            isIdle: modalContext?.prevModalSheetStateMetrics?.isIdle,
            ...modalContext?.prevModalSheetStateMetrics,
          },
          currentState: {
            state: modalContext?.currentModalSheetStateMetrics.state,
            simplified: modalContext?.currentModalSheetStateMetrics.simplified,
            isPresenting: modalContext?.currentModalSheetStateMetrics.isPresenting,
            isPresented: modalContext?.currentModalSheetStateMetrics.isPresented,
            isDismissing: modalContext?.currentModalSheetStateMetrics.isDismissing,
            isDismissed: modalContext?.currentModalSheetStateMetrics.isDismissed,
            isIdle: modalContext?.currentModalSheetStateMetrics.isIdle,
            ...modalContext?.currentModalSheetStateMetrics,
          },
        }}
      />
      <ObjectPropertyDisplay
        recursiveStyle={styles.debugDisplayInner}
        object={{
          viewControllerInstanceID: [
            focusChangeEventPayload?.viewControllerInstanceID
          ],
          modalLevel: focusChangeEventPayload?.modalLevel,
          prevState: focusChangeEventPayload?.prevState,
          currentState: focusChangeEventPayload?.currentState,
          nextState: focusChangeEventPayload?.nextState,
        }}
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