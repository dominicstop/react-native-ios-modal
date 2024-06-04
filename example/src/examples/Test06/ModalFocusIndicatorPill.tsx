import * as React from 'react';
import { StyleSheet, View, Text, ViewStyle } from 'react-native';

import { ModalContext } from 'react-native-ios-modal';

import * as Colors from '../../constants/Colors';

export function ModalFocusIndicatorPill() {
  const { focusState } = React.useContext(ModalContext);

  const pillContainerStyle: ViewStyle = {
    // prettier-ignore
    backgroundColor: (
      focusState === 'INITIAL'  ? Colors.GREY[900]   :
      focusState === 'FOCUSING' ? Colors.BLUE.A700   :
      focusState === 'FOCUSED'  ? Colors.PURPLE.A700 :
      focusState === 'BLURRING' ? Colors.PINK.A700  :
      focusState === 'BLURRED'  ? Colors.RED.A700
      // default
      : ''
    ),
  };

  return (
    <View style={[styles.modalFocusIndicatorPillContainer, pillContainerStyle]}>
      <Text style={styles.modalFocusIndicatorPillText}>
        {/* Focus Pill Label: Focus/Blur */}
        {focusState}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  modalFocusIndicatorPillContainer: {
    alignSelf: 'center',
    alignItems: 'center',
    width: 200,
    paddingVertical: 12,
    borderRadius: 15,
    marginBottom: 7,
  },
  modalFocusIndicatorPillText: {
    fontSize: 24,
    fontWeight: '900',
    color: 'white',
  },
});
