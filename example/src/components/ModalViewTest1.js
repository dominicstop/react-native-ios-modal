import * as React from 'react';
import { StyleSheet, View, Text, TouchableOpacity } from 'react-native';

import { ModalView, UIModalPresentationStyles } from 'react-native-ios-modal';

import { TestListItem } from './TestListItem';
import { sharedStyles } from '../constants/SharedStyles';

const availablePresentationStyles  = Object.keys(UIModalPresentationStyles);
const totalPresentationStylesCount = availablePresentationStyles.length ?? 0;

export class ModalViewTest1 extends React.PureComponent {
  constructor(props){
    super(props);

    this.state = {
      counter: 1,
    };
  };

  _renderModal(){
    const { counter } = this.state;
    const currentIndex = (counter % totalPresentationStylesCount);
    const currentPresentationStyle = availablePresentationStyles[currentIndex];

    return(
      <ModalView 
        containerStyle={sharedStyles.modalContainer}
        modalPresentationStyle={currentPresentationStyle}
        ref={r => this.modalRef = r}
      >
        <React.Fragment>
          <View style={sharedStyles.titleContainer}>
            <Text style={sharedStyles.textEmoji}>
              {"😊"}
            </Text>
            <Text style={sharedStyles.textModal}>
              {'Test for modal transition styles'}
            </Text>
              <Text style={[sharedStyles.textModalSubtitle, { marginTop: 5 }]}>
              {'Available Styles: '}
              <Text style={{fontWeight: 'bold'}}>
                {`${totalPresentationStylesCount}`}
              </Text>
            </Text>
          </View>
          <View style={sharedStyles.textModalContainer}>
            <Text style={sharedStyles.textModalSubtitle}>
              {'UIModalPresentationStyle: '}
              <Text style={{fontWeight: 'bold'}}>
                {`${currentPresentationStyle}`}
              </Text>
            </Text>
          </View>
          <TouchableOpacity 
            style={sharedStyles.button}
            onPress={() => {
              this.setState((prevState) => ({
                counter: (prevState.counter + 1)
              }));
            }}
          >
            <Text style={sharedStyles.buttonText}>
              {'🌼 Next Presentation Style'}
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
        title={'UIModalPresentationStyle Modal Test'}
        subtitle={'Cycle through presentation styles'}
        onPress={() => {
          this.modalRef.setVisibility(true);
        }}
      >
        {this._renderModal()}
      </TestListItem>
    );
  };
};

const styles = StyleSheet.create({
  rootContainer: {
    flex: 1,
    padding: 40,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
