import * as React from 'react';
import { StyleSheet, View, Text, TouchableOpacity } from 'react-native';

import { ModalView } from 'react-native-ios-modal';

import * as Colors  from '../constants/Colors';

import { sharedStyles } from '../constants/SharedStyles';
import { TestListItem } from './TestListItem';


function ModalContent(props){
  const isFocused = props.isFocused? 'Focused' : 'Blurred';

  const backgroundColor = (props.isFocused
    ? Colors.BLUE.A700
    : Colors.RED .A700
  );

  return(
    <View style={styles.modalContainer}>
      <Text style={styles.textModalTitle}>
        {`${props.title} - ${isFocused}`}
      </Text>
      <View style={[styles.emojiContainer, {backgroundColor}]}>
        <Text style={styles.textModalEmoji}>
          {props.emoji}
        </Text>
      </View>
      <TouchableOpacity 
        style={sharedStyles.button}
        onPress={props.onPress}
      >
        <Text style={sharedStyles.buttonText}>
          {'⭐️ Show Modal'}
        </Text>
      </TouchableOpacity>
    </View>
  );
};

export class ModalViewTest7 extends React.PureComponent {
  constructor(props){
    super(props);

    this.state = {
      isFocusedModal1: true,
      isFocusedModal2: true,
      isFocusedModal3: true,
      isFocusedModal4: true,
    };
  };

  render(){
    const state = this.state;

    return(
      <TestListItem
        title={'Modal Scrollview Test'}
        subtitle={'Test for scrollview in modal'}
        onPress={() => {
          this.modalRef1.setVisibility(true);
        }}
      >
        <ModalView 
          ref={r => this.modalRef1 = r}
          onModalFocus={() =>  this.setState(
            { isFocusedModal1: true }
          )}
          onModalBlur={() =>  this.setState(
            { isFocusedModal1: false }
          )}
        >
          <ModalContent
            title={'Modal #1'}
            emoji={'💙'}
            isFocused={state.isFocusedModal1}
            onPress={() => {
              this.modalRef2.setVisibility(true);
            }}
          />
        </ModalView>
        <ModalView 
          ref={r => this.modalRef2 = r}
          onModalFocus={() =>  this.setState(
            { isFocusedModal2: true }
          )}
          onModalBlur={() =>  this.setState(
            { isFocusedModal2: false }
          )}
        >
          <ModalContent
            title={'Modal #2'}
            emoji={'💙'}
            isFocused={state.isFocusedModal2}
            onPress={() => {
              this.modalRef3.setVisibility(true);
            }}
          />
        </ModalView>
        <ModalView 
          ref={r => this.modalRef3 = r}
          onModalFocus={() =>  this.setState(
            { isFocusedModal3: true }
          )}
          onModalBlur={() =>  this.setState(
            { isFocusedModal3: false }
          )}
        >
          <ModalContent
            title={'Modal #3'}
            emoji={'💙'}
            isFocused={state.isFocusedModal3}
            onPress={() => {
              this.modalRef4.setVisibility(true);
            }}
          />
        </ModalView>
        <ModalView 
          ref={r => this.modalRef4 = r}
          onModalFocus={() =>  this.setState(
            { isFocusedModal4: true }
          )}
          onModalBlur={() =>  this.setState(
            { isFocusedModal4: false }
          )}
        >
          <ModalContent
            title={'Modal #4'}
            emoji={'💙'}
            isFocused={state.isFocusedModal4}
            onPress={() => {
              alert('n/a');
            }}
          />
        </ModalView>
      </TestListItem>
    );
  };
};

const styles = StyleSheet.create({
  modalContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  emojiContainer: {
    padding: 20,
    borderRadius: 25,
    margin: 15,
  },
  textModalEmoji: {
    fontSize: 128,
  },
  textModalTitle: {
    fontSize: 24,
    fontWeight: 'bold',
  },
});
