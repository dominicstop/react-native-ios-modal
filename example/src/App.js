import * as React from 'react';
import { StyleSheet, ScrollView, SafeAreaView, View, Text } from 'react-native';

import { ModalViewTest0 } from './components/ModalViewTest0';
import { ModalViewTest1 } from './components/ModalViewTest1';

export default function App() {
  return (
    <SafeAreaView style={styles.rootContainer}>
      <ScrollView>
        <ModalViewTest0/>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  rootContainer: {
    flex: 1,
  },
});
