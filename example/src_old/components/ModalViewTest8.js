import * as React from 'react';
import { View, Text, TouchableOpacity, ScrollView } from 'react-native';

import { ModalView } from 'react-native-ios-modal';

import { sharedStyles } from '../constants/SharedStyles';
import { TestListItem } from './TestListItem';

import * as Helpers from '../functions/helpers';


export class ModalViewTest8 extends React.PureComponent {
  constructor(props){
    super(props);

    this.modalEmitter = null;

    this.state = {
      modalInfo: {},
    };
  };

  _renderModal(){
    const { modalInfo } = this.state;
    const modalInfoKeys = Object.keys(modalInfo);

    const items = modalInfoKeys.map((key, index) => (
      <View key={`item-${index}`}>
        <Text numberOfLines={1}>
          {`${Helpers.pad(index, 2)} - `}
          <Text style={{fontWeight: 'bold'}}>
            {`${key}: `}
          </Text>
           <Text>
            {`${modalInfo[key]}`}
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
            {'Modal Info: '}
          </Text>
          <TouchableOpacity 
            style={[sharedStyles.button, {alignSelf: 'flex-start', marginBottom: 10}]}
            onPress={async () => {
              const modalInfo = await this.modalRef.getModalInfo();
              this.setState({modalInfo});
            }}
          >
            <Text style={sharedStyles.buttonText}>
              {'Get Modal Info'}
            </Text>
          </TouchableOpacity>
          {items}
        </ScrollView>
      </ModalView>
    );
  };

  render(){
    return(
      <TestListItem
        title={'getModalInfo Test'}
        subtitle={'Test for requestModalInfo'}
        onPress={() => {
          this.modalRef.setVisibility(true);
        }}
      >
        {this._renderModal()}
      </TestListItem>
    );
  };
};

