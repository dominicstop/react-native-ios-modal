import * as React from 'react';
import { StyleSheet, Text } from 'react-native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';
import { CardBody, CardButton, CardTitle } from '../components/Card';

import * as Helpers from '../functions/Helpers';

import {
  ModalView,
  ModalViewProps,
  AvailableBlurEffectStyles,
} from 'react-native-ios-modal';

//
const availableBlurStylesCount = AvailableBlurEffectStyles?.length ?? 0;

const TestModal = React.forwardRef<
  ModalView,
  {
    modalProps: ModalViewProps;
    emoji?: string;
    title?: string;
  }
>((props, ref) => (
  <ModalView ref={ref} {...props.modalProps}>
    <React.Fragment>
      <CardBody style={styles.testModalCard}>
        <Text style={styles.testLabelEmoji}>{props.emoji ?? '😊'}</Text>
        <Text style={styles.testLabelTitle}>{props.title ?? 'Hello'}</Text>
      </CardBody>
    </React.Fragment>
  </ModalView>
));

export function Test02(props: ExampleProps) {
  const modalRef01 = React.useRef<ModalView>(null);
  const modalRef02 = React.useRef<ModalView>(null);
  const modalRef03 = React.useRef<ModalView>(null);
  const modalRef04 = React.useRef<ModalView>(null);
  const modalRef05 = React.useRef<ModalView>(null);
  const modalRef06 = React.useRef<ModalView>(null);
  const modalRef07 = React.useRef<ModalView>(null);
  const modalRef08 = React.useRef<ModalView>(null);
  const modalRef09 = React.useRef<ModalView>(null);


  const [counter, setCounter] = React.useState(0);

  const currentIndex = counter % availableBlurStylesCount;
  const currentBlurEffectStyle = AvailableBlurEffectStyles[currentIndex];

  const beginCyclingBlurEffectStyles = async () => {
    for (let index = 0; index < availableBlurStylesCount; index++) {
      setCounter(counter + 1);
      await Helpers.timeout(250);
      console.log('beginCyclingBlurEffectStyles - index:', index);
      console.log('currentBlurEffectStyle:', currentBlurEffectStyle);
    }
  };

  const beginShowingModals = async () => {
    await modalRef01.current.setVisibility(true);
    await beginCyclingBlurEffectStyles();

    const modalRefsMap = {
      modalRef01,
      modalRef02,
      modalRef03,
      modalRef04,
      modalRef05,
      modalRef06,
      modalRef07,
      modalRef08,
      modalRef09,
    };

    const getModalRefForIndex = (
      index: number
    ): React.MutableRefObject<ModalView> | undefined => {
      return modalRefsMap[`modalRef${index}`];
    };

    for (let index = 2; index < 10; index++) {
      const modalRef = getModalRefForIndex(index);
      await modalRef?.current.setVisibility(true);
    }

    await beginCyclingBlurEffectStyles();

    for (let index = 9; index > 0; index--) {
      const modalRef = getModalRefForIndex(index);
      await modalRef?.current.setVisibility(false);
    }
  };


  const sharedProps = {
    containerStyle: styles.modalContainer,
    modalBGBlurEffectStyle: currentBlurEffectStyle,
    isModalInPresentation: true,
    enableSwipeGesture: false,
  };

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test02'}
      subtitle={'TBA'}
      description={['TBA']}
    >
      <React.Fragment>
        <TestModal
          ref={modalRef01}
          emoji={'😊'}
          title={'Hello #1'}
          modalProps={sharedProps}
        />
        <TestModal
          ref={modalRef02}
          emoji={'😄'}
          title={'Hello There #2'}
          modalProps={sharedProps}
        />
        <TestModal
          ref={modalRef03}
          emoji={'💖'}
          title={'ModalView Test #3'}
          modalProps={sharedProps}
        />
        <TestModal
          ref={modalRef04}
          emoji={'🥺'}
          title={'PageSheet Modal #4'}
          modalProps={sharedProps}
        />
        <TestModal
          ref={modalRef05}
          emoji={'🥰'}
          title={'Hello World Modal #5'}
          modalProps={sharedProps}
        />
        <TestModal
          ref={modalRef06}
          emoji={'😙'}
          title={'Hello World #6'}
          modalProps={sharedProps}
        />
        <TestModal
          ref={modalRef07}
          emoji={'🤩'}
          title={'Heyyy There #7'}
          modalProps={sharedProps}
        />
        <TestModal
          ref={modalRef08}
          emoji={'😃'}
          title={'Another Modal #8'}
          modalProps={sharedProps}
        />
        <TestModal
          ref={modalRef09}
          emoji={'🏳️‍🌈'}
          title={'And Another Modal #9'}
          modalProps={sharedProps}
        />
      </React.Fragment>
      <CardButton
        title={'Show Modal'}
        onPress={() => {
          beginShowingModals();
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
  testModalCard: {
    alignSelf: 'stretch',
    backgroundColor: 'white',
  },
  testLabelEmoji: {

  },
  testLabelTitle: {
    
  },
});
