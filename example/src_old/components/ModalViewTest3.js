import * as React from 'react';
import { View, Text, TouchableOpacity, Alert } from 'react-native';

import { ModalView } from 'react-native-ios-modal';

import { sharedStyles } from '../constants/SharedStyles';
import { TestListItem } from './TestListItem';


async function delayedAlert(that, msg){
  const title = `ModalView Event: ${msg}`;
  const subitle = (() => {
    switch (msg) {
      case 'onModalBlur'          : return "The modal is in focus";
      case 'onModalFocus'         : return "The modal is blurred";
      case 'onModalShow'          : return "The modal is visible";
      case 'onModalDismiss'       : return "The modal is dismissed";
      case 'onModalDidDismiss'    : return "The modal is dismissed via swipe";
      case 'onModalWillDismiss'   : return "The modal is being swiped down";
      case 'onModalAttemptDismiss': return "User attempted to swipe down while isModalInPresentation";
    };
  })();

  Alert.alert(title, subitle);
  that.setState(prevProps => ({
    event: msg,
    eventCount: (prevProps.eventCount + 1),
  }));
};


export class ModalViewTest3 extends React.PureComponent {
  constructor(props){
    super(props);

    this.state = {
      isModalInPresentation: false,
      enableSwipeGesture: true,
      eventCount: 0,
      event: null,
    };
  };

  _renderModal(){
    const state = this.state;

    return(
      <ModalView 
        ref={r => this.modalRef = r}
        containerStyle={sharedStyles.modalContainer}
        isModalInPresentation={state.isModalInPresentation}
        enableSwipeGesture={state.enableSwipeGesture}
        onModalBlur          ={() => delayedAlert(this, 'onModalBlur'          )}
        onModalFocus         ={() => delayedAlert(this, 'onModalFocus'          )}
        onModalShow          ={() => delayedAlert(this, 'onModalShow'          )}
        onModalDismiss       ={() => delayedAlert(this, 'onModalDismiss'       )}
        onModalDidDismiss    ={() => delayedAlert(this, 'onModalDidDismiss'    )}
        onModalWillDismiss   ={() => delayedAlert(this, 'onModalWillDismiss'   )}
        onModalAttemptDismiss={() => delayedAlert(this, 'onModalAttemptDismiss')}
      >
        <React.Fragment>
          <View style={sharedStyles.titleContainer}>
            <Text style={sharedStyles.textEmoji}>
              {"😊"}
            </Text>
            <Text style={sharedStyles.textModal}>
              {'Toggle isModalInPresentation'}
            </Text>
          </View>
          <View style={sharedStyles.textModalContainer}>
            <Text style={sharedStyles.textModalSubtitle}>
              {'isModalInPresentation: '}
              <Text style={{fontWeight: 'bold'}}>
                {state.isModalInPresentation? 'ON' : 'OFF'}
              </Text>
            </Text>
            <Text style={[sharedStyles.textModalSubtitle, {marginTop: 10}]}>
              {'enableSwipeGesture: '}
              <Text style={{fontWeight: 'bold'}}>
                {state.enableSwipeGesture? 'ON' : 'OFF'}
              </Text>
            </Text>
            <Text style={[sharedStyles.textModalSubtitle, {marginTop: 10}]}>
              {'Current Event: '}
              <Text style={{fontWeight: 'bold'}}>
                {state.event ?? 'N/A'}
              </Text>
            </Text>
            <Text style={[sharedStyles.textModalSubtitle, {marginTop: 10}]}>
              {'Event Count: '}
              <Text style={{fontWeight: 'bold'}}>
                {state.eventCount}
              </Text>
            </Text>
          </View>
          <TouchableOpacity 
            style={sharedStyles.button}
            onPress={() => {
              this.setState((prevState) => ({
                isModalInPresentation: !prevState.isModalInPresentation
              }))
            }}
          >
            <Text style={sharedStyles.buttonText}>
              {`${state.isModalInPresentation? '☀️' : '🌙'} Toggle isModalInPresentation`}
            </Text>
          </TouchableOpacity>
          <TouchableOpacity 
            style={sharedStyles.button}
            onPress={() => {
              this.setState((prevState) => ({
                enableSwipeGesture: !prevState.enableSwipeGesture
              }))
            }}
          >
            <Text style={sharedStyles.buttonText}>
              {`${state.enableSwipeGesture? '☀️' : '🌙'} Toggle enableSwipeGesture`}
            </Text>
          </TouchableOpacity>
          <TouchableOpacity 
          style={sharedStyles.button}
          onPress={() => {
            this.modalRef.setVisibility(false);
          }}
        >
          <Text style={sharedStyles.buttonText}>
            {'🚫 Close Modal'}
          </Text>
        </TouchableOpacity>
        </React.Fragment>
      </ModalView>
    );
  };

  render(){
    return (
      <TestListItem
        title={'isModalInPresentation Test'}
        subtitle={'Programatically toggle swipe gesture'}
        onPress={() => {
          this.modalRef.setVisibility(true);
        }}
      >
        {this._renderModal()}
      </TestListItem>
    );
  };
};

