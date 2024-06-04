// Note: Created based on `example/src_old/ModalViewTest2.js`

import * as React from 'react';
import { StyleSheet, Text } from 'react-native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';
import { CardBody, CardButton } from '../components/Card';

import * as Helpers from '../functions/Helpers';

import {
  ModalView,
  ModalViewProps,
  AvailableBlurEffectStyles,
} from 'react-native-ios-modal';
import { ObjectPropertyDisplay } from '../components/ObjectPropertyDisplay';

//
const availableBlurStylesCount = AvailableBlurEffectStyles?.length ?? 0;

function deriveBlurEffectStyleStringFromCounter(counter: number) {
  const currentIndex = counter % availableBlurStylesCount;
  return AvailableBlurEffectStyles[currentIndex];
}

const TestModal = React.forwardRef<
  ModalView,
  {
    counter: number;
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
        <ObjectPropertyDisplay
          object={{
            counter: props.counter,
            blurEffectStyle: {
              [`${props.counter % availableBlurStylesCount}`]:
                deriveBlurEffectStyleStringFromCounter(props.counter),
            },
          }}
        />
      </CardBody>
    </React.Fragment>
  </ModalView>
));

type Test02State = {
  counter: number;
};

export class Test02 extends React.PureComponent<ExampleProps, Test02State> {
  // Properties
  // ----------

  modalRef01: ModalView;
  modalRef02: ModalView;
  modalRef03: ModalView;
  modalRef04: ModalView;
  modalRef05: ModalView;
  modalRef06: ModalView;
  modalRef07: ModalView;
  modalRef08: ModalView;
  modalRef09: ModalView;

  // Lifecycle
  // ---------

  constructor(props) {
    super(props);

    this.state = {
      counter: 0,
    };
  }

  // Methods
  // -------

  getModalRefForIndex = (index: number): ModalView | undefined => {
    const modalRefsMap = {
      modalRef01: this.modalRef01,
      modalRef02: this.modalRef02,
      modalRef03: this.modalRef03,
      modalRef04: this.modalRef04,
      modalRef05: this.modalRef05,
      modalRef06: this.modalRef06,
      modalRef07: this.modalRef07,
      modalRef08: this.modalRef08,
      modalRef09: this.modalRef09,
    };

    const indexPrefix = index < 10 ? '0' : '';
    return modalRefsMap[`modalRef${indexPrefix + index}`];
  };

  beginCyclingBlurEffectStyles = async () => {
    for (let index = 0; index < availableBlurStylesCount; index++) {
      await Promise.all([
        Helpers.setStateAsync(this, (prevState: Test02State) => ({
          counter: prevState.counter + 1,
        })),
        Helpers.timeout(250),
      ]);
    }
  };

  beginShowingModals = async () => {
    await this.modalRef01.setVisibility(true);
    await this.beginCyclingBlurEffectStyles();

    for (let index = 2; index < 10; index++) {
      const modalRef = this.getModalRefForIndex(index);
      await modalRef?.setVisibility(true);
    }

    await this.beginCyclingBlurEffectStyles();

    for (let index = 9; index > 0; index--) {
      const modalRef = this.getModalRefForIndex(index);
      await modalRef?.setVisibility(false);
    }
  };

  // Render
  // -----

  render() {
    const props = this.props;
    const state = this.state;

    const currentBlurEffectStyle = deriveBlurEffectStyleStringFromCounter(
      state.counter
    );

    const sharedModalProps = {
      containerStyle: styles.modalContainer,
      modalBGBlurEffectStyle: currentBlurEffectStyle,
      isModalInPresentation: true,
      enableSwipeGesture: false,
    };

    let modalCount = 0;

    return (
      <ExampleCard
        style={props.style}
        index={props.index}
        title={'Test02'}
        subtitle={''}
        description={[
          // prettier-ignore
          // eslint-disable-next-line prettier/prettier
            'Cycle through `modalBGBlurEffectStyle` styles, and show/hide '
          + 'multiple modals one after the other',

          // prettier-ignore
          // eslint-disable-next-line prettier/prettier
            'Test for checking if async `setVisibility` resolves properly after a'
          + 'modal is shown or hidden',
        ]}
      >
        <React.Fragment>
          <TestModal
            ref={(ref) => {
              this.modalRef01 = ref;
            }}
            emoji={'😊'}
            title={'Hello #' + ++modalCount}
            counter={state.counter}
            modalProps={sharedModalProps}
          />
          <TestModal
            ref={(ref) => {
              this.modalRef02 = ref;
            }}
            emoji={'😄'}
            title={'Hello There #' + ++modalCount}
            counter={state.counter}
            modalProps={sharedModalProps}
          />
          <TestModal
            ref={(ref) => {
              this.modalRef03 = ref;
            }}
            emoji={'💖'}
            title={'ModalView Test #' + ++modalCount}
            counter={state.counter}
            modalProps={sharedModalProps}
          />
          <TestModal
            ref={(ref) => {
              this.modalRef04 = ref;
            }}
            emoji={'🥺'}
            title={'PageSheet Modal #' + ++modalCount}
            counter={state.counter}
            modalProps={sharedModalProps}
          />
          <TestModal
            ref={(ref) => {
              this.modalRef05 = ref;
            }}
            emoji={'🥰'}
            title={'Hello World Modal #' + ++modalCount}
            counter={state.counter}
            modalProps={sharedModalProps}
          />
          <TestModal
            ref={(ref) => {
              this.modalRef06 = ref;
            }}
            emoji={'😙'}
            title={'Hello World #' + ++modalCount}
            counter={state.counter}
            modalProps={sharedModalProps}
          />
          <TestModal
            ref={(ref) => {
              this.modalRef07 = ref;
            }}
            emoji={'🤩'}
            title={'Heyyy There #' + ++modalCount}
            counter={state.counter}
            modalProps={sharedModalProps}
          />
          <TestModal
            ref={(ref) => {
              this.modalRef08 = ref;
            }}
            emoji={'😃'}
            title={'Another Modal #' + ++modalCount}
            counter={state.counter}
            modalProps={sharedModalProps}
          />
          <TestModal
            ref={(ref) => {
              this.modalRef09 = ref;
            }}
            emoji={'🏳️‍🌈'}
            title={'And Another Modal #' + ++modalCount}
            counter={state.counter}
            modalProps={sharedModalProps}
          />
        </React.Fragment>
        <CardButton
          title={'Show Modal'}
          onPress={() => {
            this.beginShowingModals();
          }}
        />
      </ExampleCard>
    );
  }
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
    fontSize: 36,
    alignSelf: 'center',
  },
  testLabelTitle: {
    fontSize: 18,
    fontWeight: '600',
    marginTop: 3,
    alignSelf: 'center',
  },
});
