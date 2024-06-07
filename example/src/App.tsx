import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { RNIModalView } from 'react-native-ios-modal';

export default function App() {
  return (
    <View style={styles.container}>
      <RNIModalView style={{backgroundColor: 'red'}}>
        <View>
          <Text>Hello World</Text>
        </View>
      </RNIModalView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
