import * as React from 'react';
import { StyleSheet } from 'react-native';

import { ModalView } from 'react-native-ios-modal';
import { ModalGroupItemContent } from './ModalGroupItemContent';

export type ModalGroupHandle = {
  showModal: () => void;
};

export type ModalGroupProps = {};

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
            modalRefs.current[`${index}`] = _ref;
          }}
        >
          <ModalGroupItemContent
            modalIndex={index}
            onPressOpenNextModal={(modalIndex) => {
              const nextModalIndex = modalIndex + 1;

              const modalRef = modalRefs.current[`${nextModalIndex}`];

              // guard
              if (modalRef == null) {
                return;
              }

              // open next modal
              setCurrentModalIndex(nextModalIndex);
              modalRef.setVisibility(true);
            }}
            onPressClosePrevModal={(modalIndex) => {
              const prevModalIndex = modalIndex - 1;

              const prevModalRef = modalRefs.current[`${prevModalIndex}`];

              // guard
              if (prevModalRef == null) {
                return;
              }

              prevModalRef.setVisibility(false);
            }}
          />
        </ModalView>
      );
    }

    return <React.Fragment>{modalGroupItems}</React.Fragment>;
  }
);

export const styles = StyleSheet.create({
  modalGroupModal: {
    justifyContent: 'center',
  },
});
