// Note: Created based on `example/src_old/ModalViewTest8.js`

import * as React from 'react';
import { StyleSheet } from 'react-native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';

import { CardBody, CardButton, CardTitle } from '../components/Card';

import { ModalView } from 'react-native-ios-modal';
import { ObjectPropertyDisplay } from '../components/ObjectPropertyDisplay';

export function Test07(props: ExampleProps) {
  const modalRef = React.useRef<ModalView>(null);

  const [modalInfo, setModalInfo] = React.useState(null);

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test07'}
      subtitle={'getModalInfo'}
      description={['Test for `ModalView.getModalInfo` method.']}
    >
      <ModalView
        ref={modalRef}
        containerStyle={styles.modalContainer}
        onModalDidDismiss={() => {
          setModalInfo(null);
        }}
      >
        <React.Fragment>
          <CardBody style={styles.modalCard}>
            <CardTitle
              title={'Modal Info'}
              subtitle={'Show return value of `getModalInfo` method'}
            />
            <ObjectPropertyDisplay object={modalInfo} />
          </CardBody>
          <CardButton
            title={'🌼 Get Modal Info'}
            onPress={async () => {
              const results = await modalRef.current.getModalInfo();
              setModalInfo(results);
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
