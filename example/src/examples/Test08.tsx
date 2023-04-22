import * as React from 'react';
import { StyleSheet } from 'react-native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';

import { CardBody, CardButton, CardTitle } from '../components/Card';

import { ModalView } from 'react-native-ios-modal';
import { ObjectPropertyDisplay } from '../components/ObjectPropertyDisplay';

export function Test08(props: ExampleProps) {
  const modalRef = React.useRef<ModalView>(null);

  const [shouldUseMediumDetent, setShouldUseMediumDetent] =
    React.useState(true);

  const [debugObject, setDebugObject] = React.useState({
    detentCurrent: null,
    detentPrev: null,
  });

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test08'}
      subtitle={'System Sheet Detent Test'}
      description={['Test for using the system-defined detents']}
    >
      <ModalView
        ref={modalRef}
        containerStyle={styles.modalContainer}
        modalSheetDetents={['medium', 'large']}
        sheetPreferredCornerRadius={30}
        sheetShouldAnimateChanges={true}
        sheetSelectedDetentIdentifier={
          shouldUseMediumDetent ? 'medium' : 'large'
        }
        onModalDidChangeSelectedDetentIdentifier={({ nativeEvent }) => {
          setDebugObject((prev) => ({
            ...prev,
            detentCurrent: nativeEvent.sheetDetentStringCurrent,
            detentPrev: nativeEvent.sheetDetentStringPrevious,
          }));
        }}
      >
        <React.Fragment>
          <CardBody style={styles.modalCard}>
            <CardTitle title={'System Detents Test'} />
            <ObjectPropertyDisplay
              object={{
                shouldUseMediumDetent,
                ...debugObject,
              }}
            />
          </CardBody>
          <CardButton
            title={'🌼 Change Current Detent'}
            onPress={() => {
              setShouldUseMediumDetent((prevValue) => !prevValue);
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
