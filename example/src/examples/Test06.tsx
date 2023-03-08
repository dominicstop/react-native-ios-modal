// Note: Created based on `example/src_old/ModalViewTest7.js`

// TODO - See TODO:2023-03-08-03-48-33
// * Enable `ModalView.isModalContentLazy` prop

import * as React from 'react';
import { StyleSheet, View, Text, ViewStyle } from 'react-native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';

import { CardBody, CardButton, CardTitle } from '../components/Card';

import { ModalContext, ModalView } from 'react-native-ios-modal';

import {
  CardLogDisplay,
  CardLogDisplayHandle,
} from '../components/Card/CardLogDisplay';

import * as Colors from '../constants/Colors';

function ModalFocusIndicatorPill() {
  const { isModalInFocus } = React.useContext(ModalContext);

  const pillContainerStyle: ViewStyle = {
    backgroundColor: isModalInFocus
      ? /* True  */ Colors.PURPLE.A700
      : /* False */ Colors.RED.A700,
  };

  // prettier-ignore
  const pillText = isModalInFocus
    ? /* True  */ 'IN FOCUS'
    : /* False */ 'BLURRED';

  return (
    <View style={[styles.modalFocusIndicatorPillContainer, pillContainerStyle]}>
      <Text style={styles.modalFocusIndicatorPillText}>
        {/* Focus Pill Label: Focus/Blur */}
        {pillText}
      </Text>
    </View>
  );
}

function ModalGroupItemContent(props: {
  modalIndex: number;
  onPressOpenNextModal: (modalIndex: number) => void;
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
      </CardBody>
    </React.Fragment>
  );
}

// Section: ModalGroup
// -------------------

type ModalGroupHandle = {
  showModal: () => void;
};

type ModalGroupProps = {};

export const ModalGroup = React.forwardRef<ModalGroupHandle, ModalGroupProps>(
  (_, ref) => {
    const [currentModalIndex, setCurrentModalIndex] = React.useState(0);

    const modalRefs = React.useRef<Record<string, ModalView | undefined>>({});

    const modalGroupItems: JSX.Element[] = [];

    // callable functions...
    React.useImperativeHandle(ref, () => ({
      showModal: () => {
        const targetModalIndex = 0;

        const modalRef = modalRefs.current[`${targetModalIndex}`];

        // guard
        if (modalRef == null) {
          return;
        }

        // open first modal
        modalRef.setVisibility(true);
        setCurrentModalIndex(targetModalIndex + 1);
      },
    }));

    // render next modal in advance
    const modalsToMountCount = currentModalIndex + 1;

    for (let index = 0; index <= modalsToMountCount; index++) {
      modalGroupItems.push(
        <ModalView
          key={`ModalView-${index}`}
          containerStyle={styles.modalGroupModal}
          ref={(_ref) => {
            console.log(`ModalView-${index} - ref: `, _ref);
            modalRefs.current[`${index}`] = _ref;
          }}
        >
          <ModalGroupItemContent
            modalIndex={index}
            onPressOpenNextModal={(modalIndex) => {
              const nextModalIndex = modalIndex + 1;

              const modalRef = modalRefs.current[`${nextModalIndex}`];

              console.log('modalIndex: ', modalIndex);
              console.log('nextModalIndex: ', nextModalIndex);
              console.log('modalRefs - keys: ', Object.keys(modalRefs.current));
              console.log('modalRefs: ', modalRefs.current);
              console.log('modalRef: ', modalRef);

              // guard
              if (modalRef == null) {
                return;
              }

              // open next modal
              setCurrentModalIndex(nextModalIndex);
              modalRef.setVisibility(true);
            }}
          />
        </ModalView>
      );
    }

    return <React.Fragment>{modalGroupItems}</React.Fragment>;
  }
);

// Section: Test06
// --------------

export function Test06(props: ExampleProps) {
  const modalGroupRef = React.useRef<ModalGroupHandle>(null);

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test06'}
      subtitle={'test - TBA'}
      description={['desc - TBA']}
    >
      <ModalGroup ref={modalGroupRef} />
      <CardButton
        title={'Show Modal'}
        onPress={() => {
          modalGroupRef.current?.showModal();
        }}
      />
    </ExampleCard>
  );
}

export const styles = StyleSheet.create({
  modalGroupModal: {
    justifyContent: 'center',
  },
  modalGroupItemCard: {
    backgroundColor: 'white',
  },

  modalFocusIndicatorPillContainer: {
    alignSelf: 'center',
    alignItems: 'center',
    width: 200,
    paddingVertical: 12,
    borderRadius: 15,
    marginBottom: 7,
  },
  modalFocusIndicatorPillText: {
    fontSize: 24,
    fontWeight: '900',
    color: 'white',
  },
});
