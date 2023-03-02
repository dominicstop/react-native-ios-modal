import * as React from 'react';
import { ScrollView, StyleSheet, View, Text } from 'react-native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';

import { CardBody, CardButton, CardTitle } from '../components/Card';

import { ModalView } from 'react-native-ios-modal';

import * as Colors from '../constants/Colors';

function DummyItems() {
  let items: JSX.Element[] = [];

  for (let index = 0; index < 30; index++) {
    // prettier-ignore
    const backgroundColor = (
      (index % 4 === 0) ? Colors.RED   [900] :
      (index % 4 === 1) ? Colors.BLUE  [900] :
      (index % 4 === 2) ? Colors.YELLOW[900] :
      (index % 4 === 3) ? Colors.PURPLE[900] :
      /* default */ Colors.GREEN[900]
    );

    const dummyItemLeftSquareStyle = {
      backgroundColor,
    };

    items.push(
      <View
        //
        key={`item-${index}`}
        style={styles.dummyItemContainer}
      >
        <View style={[styles.dummyItemLeftSquare, dummyItemLeftSquareStyle]} />
        <View style={styles.dummyItemRightContainer}>
          <Text style={styles.dummyItemLabel}>
            {/* Label */ `Item #${index}`}
          </Text>
          <Text style={styles.dummyItemDesc}>
            {/* Desc */ `Item Description - lorum ipsum sit #${index}`}
          </Text>
        </View>
      </View>
    );
  }

  return items;
}

export function Test05(props: ExampleProps) {
  const modalRef = React.useRef<ModalView>(null);

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test05'}
      subtitle={'Modal + ScrollView Test'}
      description={['Test for ScrollView in modal']}
    >
      <ModalView
        // TBA
        ref={modalRef}
        containerStyle={styles.modalContainer}
      >
        <ScrollView
          style={styles.scroll}
          contentContainerStyle={styles.scrollContentContainer}
        >
          <CardBody style={styles.modalCard}>
            <CardTitle title={'Modal + ScrollView Test'} />
          </CardBody>
          {DummyItems()}
          <CardButton
            style={styles.modalCloseButton}
            title={'Close Modal'}
            onPress={() => {
              modalRef.current?.setVisibility(false);
            }}
          />
        </ScrollView>
      </ModalView>
      <CardButton
        title={'Show Modal'}
        onPress={() => {
          modalRef.current.setVisibility(true);
        }}
      />
    </ExampleCard>
  );
}

export const styles = StyleSheet.create({
  scroll: {
    flex: 1,
    marginTop: 25,
  },
  scrollContentContainer: {
    paddingBottom: 15,
  },
  modalContainer: {},
  modalCard: {
    backgroundColor: 'white',
    alignSelf: 'center',
    marginBottom: 20,
  },
  modalCloseButton: {
    marginVertical: 20,
    marginHorizontal: 12,
  },

  dummyItemContainer: {
    flexDirection: 'row',
  },
  dummyItemLeftSquare: {
    aspectRatio: 1,
    width: 75,
  },
  dummyItemRightContainer: {
    marginLeft: 10,
    flex: 1,
    justifyContent: 'center',
  },
  dummyItemLabel: {
    fontWeight: '600',
    fontSize: 20,
  },
  dummyItemDesc: {
    color: Colors.GREY[800],
    marginTop: 2,
  },
});
