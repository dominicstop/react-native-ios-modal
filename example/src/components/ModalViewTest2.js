import * as React from 'react';
import { StyleSheet, View, Text, TouchableOpacity } from 'react-native';

import { sharedStyles } from '../constants/SharedStyles';

import { ModalView, AvailableBlurEffectStyles } from 'react-native-ios-modal';
import * as Helpers from '../functions/helpers';

const availableBlurStylesCount = AvailableBlurEffectStyles?.length ?? 0;

const TestModal = React.forwardRef((props, ref) => (
  <ModalView ref={ref} {...props}>
    <React.Fragment>
      <View style={sharedStyles.titleContainer}>
        <Text style={sharedStyles.textEmoji}>
          {props.emoji ?? "😊"}
        </Text>
        <Text style={sharedStyles.textModal}>
          {props.title ?? 'Hello #1'}
        </Text>
      </View>
      <View style={sharedStyles.textModalContainer}>
        <Text style={sharedStyles.textModalSubtitle}>
          {'UIBlurEffectStyle: '}
          <Text style={{fontWeight: 'bold'}}>
            {`${props.modalBGBlurEffectStyle}`}
          </Text>
        </Text>
      </View>
    </React.Fragment>
  </ModalView>
));

export class ModalViewTest2 extends React.PureComponent {
  constructor(props){
    super(props);

    this.state = {
      counter: 0,
    };
  };

  cycleBlurStyles = async () => {
    for (let index = 0; index < availableBlurStylesCount; index++) {
      await Promise.all([
        Helpers.timeout(100),
        Helpers.setStateAsync(this, { 
          counter: index,
        }),
      ]);
    };
  };

  nextBlurStyle = async () => {
    await Promise.all([
      Helpers.timeout(200),
      Helpers.setStateAsync(this, (prevState) => ({
        counter: (prevState.counter + 1),
      })),
    ]);
  };

  triggerModals = async () => {
    await this.modal1.setVisibility(true);
    await this.cycleBlurStyles();

    for (let index = 2; index < 10; index++) {
      await this[`modal${index}`]?.setVisibility(true);
    };

    for (let index = 9; index > 0; index--) {
      await this[`modal${index}`]?.setVisibility(false);
    };
  };

  _renderModals(){
    const { counter } = this.state;
    const currentIndex = (counter % availableBlurStylesCount);

    const sharedProps = {
      containerStyle: sharedStyles.modalContainer,
      modalBGBlurEffectStyle: AvailableBlurEffectStyles[currentIndex],
      isModalInPresentation: true,
    };

    return(
      <React.Fragment>
        <TestModal
          ref={r => this.modal1 = r}
          emoji={'😊'}
          title={'Hello #1'}
          {...sharedProps}
        />
        <TestModal
          ref={r => this.modal2 = r}
          emoji={'😄'}
          title={'Hello There #2'}
          {...sharedProps}
        />
        <TestModal
          ref={r => this.modal3 = r}
          emoji={'💖'}
          title={'ModalView Test #3'}
          {...sharedProps}
        />
        <TestModal
          ref={r => this.modal4 = r}
          emoji={'🥺'}
          title={'PageSheet Modal #4'}
          {...sharedProps}
        />
        <TestModal
          ref={r => this.modal5 = r}
          emoji={'🥰'}
          title={'Hello World Modal #5'}
          {...sharedProps}
        />
        <TestModal
          ref={r => this.modal6 = r}
          emoji={'😙'}
          title={'Hello World #6'}
          {...sharedProps}
        />
        <TestModal
          ref={r => this.modal7 = r}
          emoji={'🤩'}
          title={'Heyyy There #7'}
          {...sharedProps}
        />
        <TestModal
          ref={r => this.modal8 = r}
          emoji={'😃'}
          title={'Another Modal #8'}
          {...sharedProps}
        />
        <TestModal
          ref={r => this.modal9 = r}
          emoji={'🏳️‍🌈'}
          title={'And Another Modal #9'}
          {...sharedProps}
        />
      </React.Fragment>
    );
    //#endregion
  };

  render(){
    return(
      <View style={sharedStyles.buttonContainer}>
        {this._renderModals()}
        <Text style={sharedStyles.itemTitle}>
          {'Modal Open/Close Test'}
        </Text>
        <Text style={sharedStyles.itemDescription}>
          {'Programatically open/close modals'}
        </Text>
        <TouchableOpacity 
          style={sharedStyles.button}
          onPress={() => {
            this.triggerModals();
          }}
        >
          <Text style={sharedStyles.buttonText}>
            {'⭐️ Show Modal'}
          </Text>
        </TouchableOpacity>
      </View>
    );
  };
};

const styles = StyleSheet.create({
});
