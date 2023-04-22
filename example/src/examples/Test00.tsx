// Note: Created based on `example/src_old/ModalViewTest0.js`

import * as React from 'react';
import { StyleSheet } from 'react-native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';

import {
  CardBody,
  CardButton,
  CardTitle,
  CardToggleButton,
} from '../components/Card';

import {
  ModalView,
  UIBlurEffectStyles,
  AvailableBlurEffectStyles,
} from 'react-native-ios-modal';

import { ObjectPropertyDisplay } from '../components/ObjectPropertyDisplay';

const totalBlurStylesCount = Object.keys(UIBlurEffectStyles).length ?? 0;

const availableBlurStylesCount = AvailableBlurEffectStyles?.length ?? 0;

export function Test00(props: ExampleProps) {
  const modalRef = React.useRef<ModalView>(null);

  const [counter, setCounter] = React.useState(0);

  const [isModalBGTransparent, setIsModalBGTransparent] = React.useState(true);
  const [isModalBGBlurred, setIsModalBGBlurred] = React.useState(true);

  const currentIndex = counter % availableBlurStylesCount;
  const currentBlurEffectStyle = AvailableBlurEffectStyles[currentIndex];

  const debugObject = {
    isModalBGTransparent,
    isModalBGBlurred,
    availableBlurStylesCount,
    totalBlurStylesCount,
    counter,
    currentIndex,
    currentBlurEffectStyle: {
      _: currentBlurEffectStyle,
    },
  };

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test00'}
      subtitle={'test - UIBlurEffectStyles'}
      description={['Test for modal background + blur effects']}
    >
      <ModalView
        ref={modalRef}
        containerStyle={styles.modalContainer}
        modalBGBlurEffectStyle={currentBlurEffectStyle}
        isModalBGTransparent={isModalBGTransparent}
        isModalBGBlurred={isModalBGBlurred}
      >
        <React.Fragment>
          <CardBody style={styles.modalCard}>
            <CardTitle title={'Test for modal blur effects'} />
            <ObjectPropertyDisplay object={debugObject} />
          </CardBody>
          <CardButton
            title={'🌼 Next Blur Style'}
            onPress={() => {
              setCounter((prevCount) => prevCount + 1);
            }}
          />
          <CardToggleButton
            title={'Toggle isModalBGTransparent'}
            value={isModalBGTransparent}
            onPress={(value) => {
              setIsModalBGTransparent(value);
            }}
          />
          <CardToggleButton
            title={'Toggle isModalBGBlurred'}
            value={isModalBGBlurred}
            onPress={(value) => {
              setIsModalBGBlurred(value);
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
