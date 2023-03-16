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
}) {
  const logDisplayRef = React.useRef<CardLogDisplayHandle>(null);

  const modalContext = React.useContext(ModalContext);

  // Lifecycle: componentDidMount
  React.useEffect(() => {
    const modalEmitter = modalContext.getEmitterRef();

    const listenerHandleOnModalShow = modalEmitter.addListener(
      'onModalShow',
      () => {
        logDisplayRef.current?.log('onModalShow');
      }
    );

    const listenerHandleOnModalDidDismiss = modalEmitter.addListener(
      'onModalDidDismiss',
      () => {
        logDisplayRef.current?.log('onModalDidDismiss');
      }
    );

    const listenerHandleOnModalFocus = modalEmitter.addListener(
      'onModalFocus',
      () => {
        logDisplayRef.current?.log('onModalFocus');
      }
    );

    const listenerHandleOnModalBlur = modalEmitter.addListener(
      'onModalBlur',
      () => {
        logDisplayRef.current?.log('onModalBlur');
      }
    );

    return () => {
      // Lifecycle: componentWillUnmount
      listenerHandleOnModalShow.unsubscribe();
      listenerHandleOnModalDidDismiss.unsubscribe();
      listenerHandleOnModalFocus.unsubscribe();
      listenerHandleOnModalBlur.unsubscribe();
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
            modalContext.setVisibility(false);
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
