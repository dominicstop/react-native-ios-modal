// Note: Created based on `example/src_old/ModalViewTest8.js`

import * as React from 'react';
import { StyleSheet } from 'react-native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';

import { CardBody, CardButton, CardTitle } from '../components/Card';

import { ModalView } from 'react-native-ios-modal';

export function Test07(props: ExampleProps) {
  const modalRef = React.useRef<ModalView>(null);

  const [counter, setCounter] = React.useState(0);

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test07'}
      subtitle={'test - TBA'}
      description={['desc - TBA']}
    >
      <ModalView
        // TBA
        ref={modalRef}
        containerStyle={styles.modalContainer}
      >
        <React.Fragment>
          <CardBody style={styles.modalCard}>
            <CardTitle title={'Title - TBA'} />
          </CardBody>
          <CardButton
            title={'🌼 TBA'}
            onPress={() => {
              // TBA
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
