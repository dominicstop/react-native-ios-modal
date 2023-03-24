// Note: Created based on `example/src_old/ModalViewTest8.js`

import * as React from 'react';
import { StyleSheet } from 'react-native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';

import { CardBody, CardButton, CardTitle } from '../components/Card';

import { ModalView } from 'react-native-ios-modal';
import { ObjectPropertyDisplay } from '../components/ObjectPropertyDisplay';

type ModalWrapperHandle = {
  showModal: () => void;
};

type ModalWrapperProps = {
  index: number;
  onPressOpenModal?: () => void;
};

const ModalWrapper = React.forwardRef<ModalWrapperHandle, ModalWrapperProps>(
  (props, ref) => {
    const modalRef = React.useRef<ModalView>(null);
    const [modalInfo, setModalInfo] = React.useState(null);

    // callable functions...
    React.useImperativeHandle(ref, () => ({
      showModal: () => {
        modalRef.current?.setVisibility(true);
      },
    }));

    return (
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
              title={`Modal Info #${props.index + 1}`}
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
          {props.onPressOpenModal && (
            <CardButton
              title={'⭐️ Open Next Modal'}
              onPress={() => {
                props.onPressOpenModal?.();
              }}
            />
          )}
        </React.Fragment>
      </ModalView>
    );
  }
);

export function Test07(props: ExampleProps) {
  const modalWrapperRef1 = React.useRef<ModalWrapperHandle>(null);
  const modalWrapperRef2 = React.useRef<ModalWrapperHandle>(null);
  const modalWrapperRef3 = React.useRef<ModalWrapperHandle>(null);

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test07'}
      subtitle={'getModalInfo'}
      description={['Test for `ModalView.getModalInfo` method.']}
    >
      <ModalWrapper
        ref={modalWrapperRef1}
        index={0}
        onPressOpenModal={() => {
          modalWrapperRef2.current?.showModal();
        }}
      />
      <ModalWrapper
        ref={modalWrapperRef2}
        index={1}
        onPressOpenModal={() => {
          modalWrapperRef3.current?.showModal();
        }}
      />
      <ModalWrapper ref={modalWrapperRef3} index={2} />
      <CardButton
        title={'Show Modal'}
        onPress={() => {
          modalWrapperRef1.current?.showModal();
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
