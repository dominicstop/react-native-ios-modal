import * as React from 'react';
import { StyleSheet } from 'react-native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';

import * as Helpers from '../functions/Helpers';

import { CardBody, CardButton, CardTitle } from '../components/Card';

import { ModalView, RNIModalCustomSheetDetent } from 'react-native-ios-modal';
import { ObjectPropertyDisplay } from '../components/ObjectPropertyDisplay';

const CUSTOM_DETENTS: RNIModalCustomSheetDetent[] = [
  {
    key: 'custom_small',
    mode: 'constant',
    sizeConstant: 375,
  },
  {
    key: 'custom_75%',
    mode: 'relative',
    sizeMultiplier: 0.75,
  },
  {
    key: 'custom_100%',
    mode: 'relative',
    sizeMultiplier: 1,
  },
];

export function Test09(props: ExampleProps) {
  const modalRef = React.useRef<ModalView>(null);

  const [counter, setCounter] = React.useState(0);
  const [eventData, setEventData] = React.useState(null);

  const currentDetent = Helpers.getNextItemInCyclicArray(
    counter,
    CUSTOM_DETENTS
  );

  const objectToDisplay = {
    counter,
    currentDetent,
    eventData,
  };

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test09'}
      subtitle={'Custom Sheet Detent Test'}
      description={['Test for using custom detents iOS 16 API']}
    >
      <ModalView
        // TBA
        ref={modalRef}
        containerStyle={styles.modalContainer}
        modalSheetDetents={CUSTOM_DETENTS}
        sheetSelectedDetentIdentifier={currentDetent.key}
        onModalDidChangeSelectedDetentIdentifier={({ nativeEvent }) => {
          setEventData((prev) => ({
            ...prev,
            detentCurrent: nativeEvent.sheetDetentStringCurrent,
            detentPrev: nativeEvent.sheetDetentStringPrevious,
          }));
        }}
        onModalDetentDidCompute={({ nativeEvent }) => {
          setEventData((prev) => ({
            ...prev,
            detentHeight: nativeEvent.maximumDetentValue,
          }));
        }}
      >
        <React.Fragment>
          <CardBody style={styles.modalCard}>
            <CardTitle title={'Custom Detents Test'} />
            <ObjectPropertyDisplay object={objectToDisplay} />
          </CardBody>
          <CardButton
            title={'🌼 Change Current Detent'}
            onPress={() => {
              setCounter((prevCount) => prevCount + 1);
            }}
          />
        </React.Fragment>
      </ModalView>
      <CardButton
        title={'Show Modal'}
        onPress={() => {
          modalRef.current.setVisibility(true);
        }}
      />
    </ExampleCard>
  );
}

export const styles = StyleSheet.create({
  modalContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  modalCard: {
    alignSelf: 'stretch',
    backgroundColor: 'white',
  },
});
