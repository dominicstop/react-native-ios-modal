import { StyleSheet, Text, View } from 'react-native';

import * as ReactNativeIosModal from 'react-native-ios-modal';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{ReactNativeIosModal.hello()}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
