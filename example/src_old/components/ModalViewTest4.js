import * as React from 'react';
import { View, Text, ScrollView } from 'react-native';

import { ModalView } from 'react-native-ios-modal';

import { sharedStyles } from '../constants/SharedStyles';
import { TestListItem } from './TestListItem';

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

    this._handleOnModalBlur           = () => handleEvent(this, 'onModalBlur'          );
    this._handleOnModalFocus          = () => handleEvent(this, 'onModalFocus'         );
    this._handleOnModalShow           = () => handleEvent(this, 'onModalShow'          );
    this._handleOnModalDismiss        = () => handleEvent(this, 'onModalDismiss'       );
    this._handleOnModalDidDismiss     = () => handleEvent(this, 'onModalDidDismiss'    );
    this._handleOnModalWillDismiss    = () => handleEvent(this, 'onModalWillDismiss'   );
    this._handleOnModalAttemptDismiss = () => handleEvent(this, 'onModalAttemptDismiss');

    this.modalEmitter.addListener('onModalBlur'          , this._handleOnModalBlur          );
    this.modalEmitter.addListener('onModalFocus'         , this._handleOnModalFocus         );
    this.modalEmitter.addListener('onModalShow'          , this._handleOnModalShow          );
    this.modalEmitter.addListener('onModalDismiss'       , this._handleOnModalDismiss       );
    this.modalEmitter.addListener('onModalDidDismiss'    , this._handleOnModalDidDismiss    );
    this.modalEmitter.addListener('onModalWillDismiss'   , this._handleOnModalWillDismiss   );
    this.modalEmitter.addListener('onModalAttemptDismiss', this._handleOnModalAttemptDismiss);
  };

  componentWillUnmount(){
    this.modalEmitter.removeListener('onModalBlur'          , this._handleOnModalBlur          );
    this.modalEmitter.removeListener('onModalFocus'         , this._handleOnModalFocus         );
    this.modalEmitter.removeListener('onModalShow'          , this._handleOnModalShow          );
    this.modalEmitter.removeListener('onModalDismiss'       , this._handleOnModalDismiss       );
    this.modalEmitter.removeListener('onModalDidDismiss'    , this._handleOnModalDidDismiss    );
    this.modalEmitter.removeListener('onModalWillDismiss'   , this._handleOnModalWillDismiss   );
    this.modalEmitter.removeListener('onModalAttemptDismiss', this._handleOnModalAttemptDismiss);

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
      <TestListItem
        title={'EventEmitter Tester'}
        subtitle={'Test for subscibing to modal events'}
        onPress={() => {
          this.modalRef.setVisibility(true);
        }}
      >
        {this._renderModal()}
      </TestListItem>
    );
  };
};
