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

import { ModalView, ModalViewEmitterEvents } from 'react-native-ios-modal';

import {
  CardLogDisplay,
  CardLogDisplayHandle,
} from '../components/Card/CardLogDisplay';

// eslint-disable-next-line @typescript-eslint/no-unused-vars
function getEventMessageForEventKey(event: ModalViewEmitterEvents) {
  switch (event) {
    case 'onModalBlur':
      return 'The modal is in focus';
    case 'onModalFocus':
      return 'The modal is blurred';
    case 'onModalShow':
      return 'The modal is visible';
    case 'onModalDismiss':
      return 'The modal is dismissed';
    case 'onModalDidDismiss':
      return 'The modal is dismissed via swipe';
    case 'onModalWillDismiss':
      return 'The modal is being swiped down';
    case 'onModalAttemptDismiss':
      return 'User attempted to swipe down while isModalInPresentation';
  }
}

export function Test03(props: ExampleProps) {
  const modalRef = React.useRef<ModalView>(null);
  const logDisplayRef = React.useRef<CardLogDisplayHandle>(null);

  const [isModalInPresentation, setIsModalInPresentation] =
    React.useState(false);

  const [isSwipeGestureEnabled, setIsSwipeGestureEnabled] =
    React.useState(true);

  const logEvent = (eventString: string) => {
    logDisplayRef.current?.log(eventString);
  };

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test03'}
      subtitle={'test - modal events'}
      description={['desc - TBA']}
    >
      <ModalView
        // TBA
        ref={modalRef}
        containerStyle={styles.modalContainer}
        isModalInPresentation={isModalInPresentation}
        // TODO - Bug: enableSwipeGesture does not apply when state changes...
        enableSwipeGesture={isSwipeGestureEnabled}
        // TODO - Bug: Currently broken...
        isModalContentLazy={true}
        onModalBlur={() => {
          logEvent('onModalBlur');
        }}
        onModalFocus={() => {
          logEvent('onModalFocus');
        }}
        onModalShow={() => {
          logEvent('onModalShow');
        }}
        onModalDismiss={() => {
          logEvent('onModalDismiss');
        }}
        onModalDidDismiss={() => {
          logEvent('onModalDidDismiss');
        }}
        onModalWillDismiss={() => {
          logEvent('onModalWillDismiss');
        }}
        onModalAttemptDismiss={() => {
          logEvent('onModalAttemptDismiss');
        }}
      >
        <React.Fragment>
          <CardBody style={styles.modalCard1}>
            <CardTitle
              title={'Event Log'}
              subtitle={'List of emitted modal events...'}
            />
            <CardLogDisplay
              ref={logDisplayRef}
              listDisplayMode={'SCROLL_ENABLED'}
              initialLogItems={[]}
            />
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
