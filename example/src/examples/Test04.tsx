// Note: Created based on `example/src_old/ModalViewTest4.js`

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

import { ModalContext, ModalView } from 'react-native-ios-modal';

import {
  CardLogDisplay,
  CardLogDisplayHandle,
} from '../components/Card/CardLogDisplay';

function ModalEventLogger() {
  const modalContext = React.useContext(ModalContext);
  const logDisplayRef = React.useRef<CardLogDisplayHandle>(null);

  React.useEffect(() => {
    // componentDidMount
    const modalEmitter = modalContext.getEmitterRef();

    modalEmitter.addListener('onModalBlur', () =>
      logDisplayRef.current?.log('onModalBlur')
    );
    modalEmitter.addListener('onModalFocus', () =>
      logDisplayRef.current?.log('onModalFocus')
    );
    modalEmitter.addListener('onModalShow', () =>
      logDisplayRef.current?.log('onModalShow')
    );
    modalEmitter.addListener('onModalDismiss', () =>
      logDisplayRef.current?.log('onModalDismiss')
    );
    modalEmitter.addListener('onModalDidDismiss', () =>
      logDisplayRef.current?.log('onModalDidDismiss')
    );
    modalEmitter.addListener('onModalWillDismiss', () =>
      logDisplayRef.current?.log('onModalWillDismiss')
    );
    modalEmitter.addListener('onModalAttemptDismiss', () =>
      logDisplayRef.current?.log('onModalAttemptDismiss')
    );
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <CardLogDisplay
      ref={logDisplayRef}
      listDisplayMode={'SCROLL_ENABLED'}
      initialLogItems={[]}
    />
  );
}

export function Test04(props: ExampleProps) {
  const modalRef = React.useRef<ModalView>(null);

  const [isModalInPresentation, setIsModalInPresentation] =
    React.useState(false);

  const [isSwipeGestureEnabled, setIsSwipeGestureEnabled] =
    React.useState(true);

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test04'}
      subtitle={'EventEmitter Tester'}
      description={['Modal EventEmitter test']}
    >
      <ModalView
        // TBA
        ref={modalRef}
        containerStyle={styles.modalContainer}
        isModalInPresentation={isModalInPresentation}
        enableSwipeGesture={isSwipeGestureEnabled}
        // TODO: See TODO:2023-03-04-12-50-04 - Fix:
        // `isModalContentLazy` Prop
        //
        // * Currently broken...
        isModalContentLazy={true}
      >
        <React.Fragment>
          <CardBody style={styles.modalCard1}>
            <CardTitle
              title={'Modal EventEmitter Tester'}
              subtitle={
                'Same as `Test03`, but use the event emitter object to listen for events'
              }
            />
            <ModalEventLogger />
          </CardBody>
          <CardBody style={styles.modalCard2}>
            <CardTitle title={'Controls'} />
            <CardToggleButton
              title={'Toggle isModalInPresentation'}
              value={isModalInPresentation}
              onPress={() => {
                setIsModalInPresentation((prev) => !prev);
              }}
            />
            <CardToggleButton
              title={'Toggle enableSwipeGesture'}
              value={isSwipeGestureEnabled}
              onPress={() => {
                setIsSwipeGestureEnabled((prev) => !prev);
              }}
            />
            <CardButton
              title={'🚫 Close Modal'}
              onPress={() => {
                modalRef.current.setVisibility(false);
              }}
            />
          </CardBody>
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
  modalCard1: {
    alignSelf: 'stretch',
    backgroundColor: 'rgba(255,255,255,0.8)',
  },
  modalCard2: {
    alignSelf: 'stretch',
    backgroundColor: 'rgba(255,255,255,0.8)',
  },
});
