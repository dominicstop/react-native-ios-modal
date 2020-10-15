import * as React from 'react';
import { StyleSheet, View, Text, TouchableOpacity, ScrollView } from 'react-native';

import { ModalView, withModalLifecycle } from 'react-native-ios-modal';
import { ModalEventKeys } from '../../../src/constants/Enums';

import { sharedStyles } from '../constants/SharedStyles';
import * as Helpers from '../functions/helpers';


const pad = (num, places = 2) => String(num).padStart(places, '0');

function handleEvent(that, event){
  const date = new Date();


  const h = pad(date.getHours  ());
  const m = pad(date.getMinutes());
  const s = pad(date.getSeconds());

  const ms = pad(date.getMilliseconds(), 3);
  
  that.setState((prevState) => ({
    events: [...prevState.events, {
      timestamp: `${h}:${m}:${s}.${ms}`,
      type: event
    }]
  }));
};

class ModalContents extends React.PureComponent {
  constructor(props){
    super(props);

    this.state = {
      events: [],
    };
  };

  onModalBlur = (event) => {
    handleEvent(this, ModalEventKeys.onModalBlur);
  };

  onModalFocus = (event) => {
    handleEvent(this, ModalEventKeys.onModalFocus);
  };

  onModalShow = (event) => {
    handleEvent(this, ModalEventKeys.onModalShow);
  };

  onModalDismiss = (event) => {
    handleEvent(this, ModalEventKeys.onModalDismiss);
  };

  onModalDidDismiss = (event) => {
    handleEvent(this, ModalEventKeys.onModalDidDismiss);
  };

  onModalWillDismiss = (event) => {
    handleEvent(this, ModalEventKeys.onModalWillDismiss);
  };

  onModalAttemptDismiss = (event) => {
    handleEvent(this, ModalEventKeys.onModalAttemptDismiss);
  };

  render(){
    const { events } = this.state;

    const items = events.map((event, index) => (
      <View
        key={`item-${index}`}
      >
        <Text>
          {`${pad(index, 3)} - ${event.timestamp} - `}
          <Text style={{fontWeight: 'bold'}}>
            {event.type}
          </Text>
        </Text>
      </View>
    ));

    return(
      <ScrollView contentContainerStyle={{padding: 15}}>
        <Text style={sharedStyles.textModal}>
          {'Modal Events'}
        </Text>
        <Text style={[sharedStyles.textModalSubtitle, {marginBottom: 15}]}>
          {'Note: When a modal is closed, the child gets unmounted. Since the events state is stored in the child comp., when the modal is closed the state gets reset.'}
        </Text>
        {items}
      </ScrollView>
    );
  };

};

const ModalContentsWithModalLifecycle =
  withModalLifecycle(ModalContents);

export class ModalViewTest5 extends React.PureComponent {

  render(){
    return(
      <View style={sharedStyles.buttonContainer}>
        <ModalView ref={r => this.modalRef = r}>
          <ModalContentsWithModalLifecycle/>
        </ModalView>
        <Text style={sharedStyles.itemTitle}>
          {'withModalLifecycle HOC Tester'}
        </Text>
        <Text style={sharedStyles.itemDescription}>
          {'Test for listening to modal events via HOC'}
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
