import * as React from 'react';
import { StyleSheet, View, Text, ScrollView } from 'react-native';

import { ModalView } from 'react-native-ios-modal';

import { TestListItem } from './TestListItem';

import * as Colors  from '../constants/Colors';
import * as Helpers from '../functions/helpers';


export class ModalViewTest6 extends React.PureComponent {

  _renderItems = () => {
    let items = [];

    for (let index = 0; index < 30; index++) {
      const backgroundColor = (
        (index % 4 == 0)? Colors.RED   [900] :
        (index % 4 == 1)? Colors.BLUE  [900] :
        (index % 4 == 2)? Colors.YELLOW[900] : 
        (index % 4 == 3)? Colors.PURPLE[900] : Colors.GREEN[900]
      );

      items.push(
        <View
          key={`item-${index}`}
          style={styles.itemContainer}
        >
          <View style={[styles.square, {backgroundColor}]}/>
          <View style={styles.itemRightContainer}>
            <Text style={styles.textItemTitle}>
              {`Item #${index}`}
            </Text>
            <Text style={styles.textItemDesc}>
              {`Item Description - lorum ipsum sit #${index}`}
            </Text>
          </View>
        </View>
      );
    };

    return items
  };

  render(){
    return(
      <TestListItem
        title={'Modal Scrollview Test'}
        subtitle={'Test for scrollview in modal'}
        onPress={() => {
          this.modalRef.setVisibility(true);
        }}
      >
        <ModalView ref={r => this.modalRef = r}>
          <ScrollView>
            {this._renderItems()}
          </ScrollView>
        </ModalView>
      </TestListItem>
    );
  };
};


const styles = StyleSheet.create({
  itemContainer: {
    flexDirection: 'row',
  },
  square: {
    aspectRatio: 1,
    width: 75,
  },
  itemRightContainer: {
    marginLeft: 10,
    flex: 1,
    justifyContent: 'center',
  },
  textItemTitle: {
    fontWeight: '600',
    fontSize: 20,
  },
  textItemDesc: {
    color: Colors.GREY[800],
    marginTop: 2,
  },
});
