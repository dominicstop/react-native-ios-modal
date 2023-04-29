// Note: Created based on `example/src_old/ModalViewTest1.js`

import * as React from 'react';
import { StyleSheet } from 'react-native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';

import { CardBody, CardButton, CardTitle } from '../components/Card';

import {
  ModalView,
  TUIModalPresentationStyle,
  UIModalPresentationStyles,
} from 'react-native-ios-modal';

import { ObjectPropertyDisplay } from '../components/ObjectPropertyDisplay';

const availablePresentationStyles = Object.keys(
  UIModalPresentationStyles
) as Array<TUIModalPresentationStyle>;

const totalPresentationStylesCount = availablePresentationStyles.length ?? 0;

export function Test01(props: ExampleProps) {
  const modalRef = React.useRef<ModalView>(null);

  const [counter, setCounter] = React.useState(0);

  const currentIndex = counter % totalPresentationStylesCount;
  const currentPresentationStyle = availablePresentationStyles[currentIndex];

  const debugObject = {
    currentIndex,
    totalPresentationStylesCount,
    currentPresentationStyle: {
      _: currentPresentationStyle,
    },
  };

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test01'}
      subtitle={'test - UIModalPresentationStyles'}
      description={['Test for modal transition styles']}
    >
      <ModalView
        ref={modalRef}
        containerStyle={styles.modalContainer}
        modalPresentationStyle={currentPresentationStyle}
        modalContentPreferredContentSize={{
          mode: 'percent',
          percentWidth: 0.8,
          percentHeight: 0.8,
        }}
      >
        <React.Fragment>
          <CardBody style={styles.modalCard}>
            <CardTitle title={'Test for modal transition styles'} />
            <ObjectPropertyDisplay object={debugObject} />
          </CardBody>
          <CardButton
            title={'🌼 Next Presentation Style'}
            onPress={() => {
              setCounter((prevCount) => prevCount + 1);
            }}
          />
          <CardButton
            title={'🚫 Close Modal'}
            onPress={() => {
              modalRef.current.setVisibility(false);
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
