import * as React from 'react';
import { StyleSheet, View, Text, TouchableOpacity, ScrollView } from 'react-native';

import { ModalView, ModalEventKeys } from 'react-native-ios-modal';

import { sharedStyles } from '../constants/SharedStyles';
import * as Helpers from '../functions/helpers';


function handleEvent(that, event){
  const date = new Date();

  const h = Helpers.pad(date.getHours  ());
  const m = Helpers.pad(date.getMinutes());
  const s = Helpers.pad(date.getSeconds());

  const ms = Helpers.pad(date.getMilliseconds(), 3);
  
  that.setState((prevState) => ({
    events: [...prevState.events, {
      timestamp: `${h}:${m}:${s}.${ms}`,
      type: event
    }]
  }));
};

export class ModalViewTest4 extends React.PureComponent {
  constructor(props){
    super(props);

    this.modalEmitter = null;

    this.state = {
      events: [],
    };
  };

  componentDidMount(){
    this.modalEmitter = this.modalRef.getEmitterRef();

    this._handleOnModalBlur           = () => handleEvent(this, ModalEventKeys.onModalBlur          );
    this._handleOnModalFocus          = () => handleEvent(this, ModalEventKeys.onModalFocus         );
    this._handleOnModalShow           = () => handleEvent(this, ModalEventKeys.onModalShow          );
    this._handleOnModalDismiss        = () => handleEvent(this, ModalEventKeys.onModalDismiss       );
    this._handleOnModalDidDismiss     = () => handleEvent(this, ModalEventKeys.onModalDidDismiss    );
    this._handleOnModalWillDismiss    = () => handleEvent(this, ModalEventKeys.onModalWillDismiss   );
    this._handleOnModalAttemptDismiss = () => handleEvent(this, ModalEventKeys.onModalAttemptDismiss);

    this.modalEmitter.addListener(ModalEventKeys.onModalBlur          , this._handleOnModalBlur          );
    this.modalEmitter.addListener(ModalEventKeys.onModalFocus         , this._handleOnModalFocus         );
    this.modalEmitter.addListener(ModalEventKeys.onModalShow          , this._handleOnModalShow          );
    this.modalEmitter.addListener(ModalEventKeys.onModalDismiss       , this._handleOnModalDismiss       );
    this.modalEmitter.addListener(ModalEventKeys.onModalDidDismiss    , this._handleOnModalDidDismiss    );
    this.modalEmitter.addListener(ModalEventKeys.onModalWillDismiss   , this._handleOnModalWillDismiss   );
    this.modalEmitter.addListener(ModalEventKeys.onModalAttemptDismiss, this._handleOnModalAttemptDismiss);
  };

  componentWillUnmount(){
    this.modalEmitter.removeListener(ModalEventKeys.onModalBlur          , this._handleOnModalBlur          );
    this.modalEmitter.removeListener(ModalEventKeys.onModalFocus         , this._handleOnModalFocus         );
    this.modalEmitter.removeListener(ModalEventKeys.onModalShow          , this._handleOnModalShow          );
    this.modalEmitter.removeListener(ModalEventKeys.onModalDismiss       , this._handleOnModalDismiss       );
    this.modalEmitter.removeListener(ModalEventKeys.onModalDidDismiss    , this._handleOnModalDidDismiss    );
    this.modalEmitter.removeListener(ModalEventKeys.onModalWillDismiss   , this._handleOnModalWillDismiss   );
    this.modalEmitter.removeListener(ModalEventKeys.onModalAttemptDismiss, this._handleOnModalAttemptDismiss);

    this.modalEmitter = null;
  };

  _renderModal(){
    const { events } = this.state;

    const items = events.map((event, index) => (
      <View
        key={`item-${index}`}
      >
        <Text>
          {`${Helpers.pad(index, 3)} - ${event.timestamp} - `}
          <Text style={{fontWeight: 'bold'}}>
            {event.type}
          </Text>
        </Text>
      </View>
    ));

    return(
      <ModalView 
        ref={r => this.modalRef = r}
      >
        <ScrollView contentContainerStyle={{padding: 15}}>
          <Text style={sharedStyles.textModal}>
            {'Modal Events'}
          </Text>
          {items}
        </ScrollView>
      </ModalView>
    );
  };

  render(){
    return(
      <View style={sharedStyles.buttonContainer}>
        {this._renderModal()}
        <Text style={sharedStyles.itemTitle}>
          {'EventEmitter Tester'}
        </Text>
        <Text style={sharedStyles.itemDescription}>
          {'Test for subscibing to modal events'}
        </Text>
        <TouchableOpacity 
          style={sharedStyles.button}
          onPress={() => {
            this.modalRef.setVisibility(true);
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
