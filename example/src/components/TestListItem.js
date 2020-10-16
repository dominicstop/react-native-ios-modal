import * as React from 'react';
import { StyleSheet, View, Text, TouchableOpacity } from 'react-native';
import PropTypes from 'prop-types';

import * as Colors from "../constants/Colors";

export class TestListItem extends React.PureComponent {
  render(){
    const props = this.props;

    return(
      <View style={styles.rootContainer}>
        <Text style={styles.itemTitle}>
          {props.title}
        </Text>
        <Text style={styles.itemDescription}>
          {props.subtitle}
        </Text>
        <TouchableOpacity 
          style={styles.button}
          onPress={props.onPress}
        >
          <Text style={styles.buttonText}>
            {props.buttonText ?? '⭐️ Show Modal'}
          </Text>
        </TouchableOpacity>
        {this.props.children}
      </View>
    );
  };
};

const styles = StyleSheet.create({
  rootContainer: {
    padding: 10,
    alignItems: 'center',
  },
  itemTitle: {
    fontSize: 16,
    fontWeight: '600',
  },
  itemDescription: {
    fontSize: 16,
    fontWeight: '300',
    color: Colors.GREY[700]
  },
  button: {
    marginTop: 10,
    backgroundColor: Colors.BLUE.A700,
    paddingHorizontal: 15,
    paddingVertical: 10,
    borderRadius: 10,
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '500',
  },
});