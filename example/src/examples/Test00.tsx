import * as React from 'react';

import { StyleSheet, View, Text, TouchableOpacity } from 'react-native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';
import { CardButton } from '../components/Card';

import * as Colors from '../constants/Colors';

import {
  ModalView,
  UIBlurEffectStyles,
  AvailableBlurEffectStyles,
} from 'react-native-ios-modal';
import { ObjectPropertyDisplay } from '../components/ObjectPropertyDisplay';

const totalBlurStylesCount = Object.keys(UIBlurEffectStyles).length ?? 0;

const availableBlurStylesCount = AvailableBlurEffectStyles?.length ?? 0;

export function Test00(props: ExampleProps) {
  const modalRef = React.useRef<ModalView>(null);

  const [counter, setCounter] = React.useState(0);

  const [isModalBGTransparent, setIsModalBGTransparent] = React.useState(true);
  const [isModalBGBlurred, setIsModalBGBlurred] = React.useState(true);

  const currentIndex = counter % availableBlurStylesCount;
  const currentBlurEffectStyle = AvailableBlurEffectStyles[currentIndex];

  const debugObject = {
    isModalBGTransparent,
    isModalBGBlurred,
    availableBlurStylesCount,
    totalBlurStylesCount,
    counter,
    currentIndex,
    currentBlurEffectStyle: {
      _: currentBlurEffectStyle,
    },
  };

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test00'}
      subtitle={'Modal Test 00'}
      description={[
        'Test for modal blur effects',
        `total blur styles - totalBlurStylesCount: ${totalBlurStylesCount}`,
        `total available blur styles - availableBlurStylesCount: ${availableBlurStylesCount}`,
      ]}
    >
      <ModalView
        ref={modalRef}
        containerStyle={styles.modalContainer}
        modalBGBlurEffectStyle={currentBlurEffectStyle}
        isModalBGTransparent={isModalBGTransparent}
        isModalBGBlurred={isModalBGBlurred}
      >
        <React.Fragment>
          <View style={styles.titleContainer}>
            <Text style={styles.textModal}>
              {'Test for modal blur effects'}
            </Text>
            <ObjectPropertyDisplay object={debugObject} />
          </View>
          <TouchableOpacity
            style={styles.button}
            onPress={() => {
              setCounter((prevCount) => prevCount + 1);
            }}
          >
            <Text style={styles.buttonText}>{'🌼 Next Blur Style'}</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.button}
            onPress={() => {
              setIsModalBGTransparent((prev) => !prev);
            }}
          >
            <Text style={styles.buttonText}>
              {`${
                isModalBGTransparent ? '☀️' : '🌙'
              } Toggle isModalBGTransparent`}
            </Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.button}
            onPress={() => {
              setIsModalBGBlurred((prev) => !prev);
            }}
          >
            <Text style={styles.buttonText}>
              {`${isModalBGBlurred ? '☀️' : '🌙'} Toggle isModalBGBlurred`}
            </Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.button}
            onPress={() => {
              modalRef.current.setVisibility(false);
            }}
          >
            <Text style={styles.buttonText}>{'🚫 Close Modal'}</Text>
          </TouchableOpacity>
        </React.Fragment>
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
  modalContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  titleContainer: {
    backgroundColor: 'white',
    padding: 15,
    borderRadius: 15,
    marginBottom: 10,
  },
  textEmoji: {
    fontSize: 64,
    marginBottom: 10,
  },
  textModal: {
    fontSize: 24,
    fontWeight: '800',
  },
});
