import * as React from 'react';
import { StyleSheet, View, Text, ViewStyle } from 'react-native';

import { ModalContext } from 'react-native-ios-modal';

import * as Colors from '../../constants/Colors';

export function ModalFocusIndicatorPill() {
  const { isModalInFocus } = React.useContext(ModalContext);

  const pillContainerStyle: ViewStyle = {
    backgroundColor: isModalInFocus
      ? /* True  */ Colors.PURPLE.A700
      : /* False */ Colors.RED.A700,
  };

  // prettier-ignore
  const pillText = isModalInFocus
    ? /* True  */ 'IN FOCUS'
    : /* False */ 'BLURRED';

  return (
    <View style={[styles.modalFocusIndicatorPillContainer, pillContainerStyle]}>
      <Text style={styles.modalFocusIndicatorPillText}>
        {/* Focus Pill Label: Focus/Blur */}
        {pillText}
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
