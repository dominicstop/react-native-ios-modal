import * as React from 'react';
import { StyleSheet, View, Text, TouchableOpacity } from 'react-native';

import { ModalView, AvailableBlurEffectStyles, UIBlurEffectStyles } from 'react-native-ios-modal';

import { sharedStyles } from '../constants/SharedStyles';
import { TestListItem } from './TestListItem';


const totalBlurStylesCount = Object.keys(UIBlurEffectStyles).length ?? 0;
const availableBlurStylesCount = AvailableBlurEffectStyles?.length ?? 0;


export class ModalViewTest0 extends React.PureComponent {
  constructor(props){
    super(props);

    this.state = {
      counter: 0,
      isModalBGTransparent: true,
      isModalBGBlurred: true,
    };
  };

  _renderModal(){
    const { counter, isModalBGTransparent, isModalBGBlurred } = this.state;
    
    const currentIndex = (counter % availableBlurStylesCount);
    const currentBlurEffectStyle = AvailableBlurEffectStyles[currentIndex];

    return (
      <ModalView 
        ref={r => this.modalRef = r}
        containerStyle={sharedStyles.modalContainer}
        modalBGBlurEffectStyle={currentBlurEffectStyle}
        {...{isModalBGTransparent, isModalBGBlurred}}
      >
        <React.Fragment>
          <View style={sharedStyles.titleContainer}>
            <Text style={sharedStyles.textEmoji}>
              {"😊"}
            </Text>
            <Text style={sharedStyles.textModal}>
              {'Test for modal blur effects'}
            </Text>
              <Text style={[sharedStyles.textModalSubtitle, { marginTop: 5 }]}>
              {'Available Styles: '}
              <Text style={{fontWeight: 'bold'}}>
                {`${availableBlurStylesCount}`}
              </Text>
            </Text>
              <Text style={[sharedStyles.textModalSubtitle, { marginTop: 5 }]}>
              {'Total Available Styles: '}
              <Text style={{fontWeight: 'bold'}}>
                {`${totalBlurStylesCount}`}
              </Text>
            </Text>
          </View>
          <View style={sharedStyles.textModalContainer}>
            <Text style={sharedStyles.textModalSubtitle}>
              {'UIBlurEffectStyle: '}
              <Text style={{fontWeight: 'bold'}}>
                {`${currentBlurEffectStyle}`}
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
              {'🌼 Next Blur Style'}
            </Text>
          </TouchableOpacity>
          <TouchableOpacity 
            style={sharedStyles.button}
            onPress={() => {
              this.setState((prevState) => ({
                isModalBGTransparent: !prevState.isModalBGTransparent
              }))
            }}
          >
            <Text style={sharedStyles.buttonText}>
              {`${isModalBGTransparent? '☀️' : '🌙'} Toggle isModalBGTransparent`}
            </Text>
          </TouchableOpacity>
          <TouchableOpacity 
            style={sharedStyles.button}
            onPress={() => {
              this.setState((prevState) => ({
                isModalBGBlurred: !prevState.isModalBGBlurred
              }))
            }}
          >
            <Text style={sharedStyles.buttonText}>
              {`${isModalBGBlurred? '☀️' : '🌙'} Toggle isModalBGBlurred`}
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
    const { counter } = this.state;

    return (
      <React.Fragment>
        <TestListItem
          title={'UIBlurEffectStyle Modal Test'}
          subtitle={'Cycle through blur styles'}
          onPress={() => {
            this.modalRef.setVisibility(true);
          }}
        />
        {this._renderModal()}
      </React.Fragment>
    );
  };
};