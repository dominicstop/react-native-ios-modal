import * as React from 'react';
import { StyleSheet } from 'react-native';

import { CardBody, CardButton, CardTitle } from '../../components/Card';

import { ModalContext } from 'react-native-ios-modal';

import {
  CardLogDisplay,
  CardLogDisplayHandle,
} from '../../components/Card/CardLogDisplay';

import { ModalFocusIndicatorPill } from './ModalFocusIndicatorPill';

export function ModalGroupItemContent(props: {
  modalIndex: number;
  onPressOpenNextModal: (modalIndex: number) => void;
  onPressClosePrevModal: (modalIndex: number) => void;
  onPressCloseModal: (modalIndex: number) => void;
}) {
  const logDisplayRef = React.useRef<CardLogDisplayHandle>(null);

  const modalContext = React.useContext(ModalContext);

  // Lifecycle: componentDidMount
  React.useEffect(() => {
    const modalEmitter = modalContext.getEmitterRef();

    const listenerOnModalWillFocus = modalEmitter.addListener(
      'onModalWillFocus',
      () => {
        logDisplayRef.current?.log('onModalWillFocus');
      }
    );

    const listenerOnModalDidFocus = modalEmitter.addListener(
      'onModalDidFocus',
      () => {
        logDisplayRef.current?.log('onModalDidFocus');
      }
    );

    const listenerOnModalWillBlur = modalEmitter.addListener(
      'onModalWillBlur',
      () => {
        logDisplayRef.current?.log('onModalWillBlur');
      }
    );

    const listenerOnModalDidBlur = modalEmitter.addListener(
      'onModalDidBlur',
      () => {
        logDisplayRef.current?.log('onModalDidBlur');
      }
    );

    return () => {
      // Lifecycle: componentWillUnmount
      listenerOnModalWillFocus.unsubscribe();
      listenerOnModalDidFocus.unsubscribe();
      listenerOnModalWillBlur.unsubscribe();
      listenerOnModalDidBlur.unsubscribe();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <React.Fragment>
      <ModalFocusIndicatorPill />
      <CardBody style={styles.modalGroupItemCard}>
        <CardTitle title={`Modal #${props.modalIndex}`} />
        <CardLogDisplay
          listDisplayMode={'SCROLL_ENABLED'}
          initialLogItems={[]}
          ref={logDisplayRef}
        />
        <CardButton
          title={'🌼 Open Next Modal'}
          onPress={() => {
            props.onPressOpenNextModal(props.modalIndex);
          }}
        />
        <CardButton
          title={'🚫 Close Modal'}
          onPress={() => {
            props.onPressCloseModal(props.modalIndex);
          }}
        />
        {props.modalIndex > 0 && (
          <CardButton
            title={'🚫 Close Prev. Modal'}
            onPress={() => {
              // TODO: See TODO:2023-03-09-17-36-51
              props.onPressClosePrevModal(props.modalIndex);
            }}
          />
        )}
      </CardBody>
    </React.Fragment>
  );
}

const styles = StyleSheet.create({
  modalGroupModal: {
    justifyContent: 'center',
  },
  modalGroupItemCard: {
    backgroundColor: 'white',
  },
});
