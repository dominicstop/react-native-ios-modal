import * as React from 'react';
import { StyleSheet, View, Text, TouchableOpacity, ScrollView } from 'react-native';

import { ModalView, withModalLifecycle, ModalEventKeys } from 'react-native-ios-modal';

import { TestListItem } from './TestListItem';
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
      <View key={`item-${index}`}>
        <Text>
          {`${Helpers.pad(index, 3)} - ${event.timestamp} - `}
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
      <TestListItem
        title={'withModalLifecycle HOC Tester'}
        subtitle={'Test for listening to modal events via HOC'}
        onPress={() => {
          this.modalRef.setVisibility(true);
        }}
      >
        <ModalView ref={r => this.modalRef = r}>
          <ModalContentsWithModalLifecycle/>
        </ModalView>
      </TestListItem>
    );
  };
};


const styles = StyleSheet.create({

});
