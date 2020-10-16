import * as React from 'react';
import { StyleSheet, ScrollView, SafeAreaView, View, Text } from 'react-native';

import { ModalViewTest0 } from './components/ModalViewTest0';
import { ModalViewTest1 } from './components/ModalViewTest1';
import { ModalViewTest2 } from './components/ModalViewTest2';
import { ModalViewTest3 } from './components/ModalViewTest3';
import { ModalViewTest4 } from './components/ModalViewTest4';
import { ModalViewTest5 } from './components/ModalViewTest5';
import { ModalViewTest6 } from './components/ModalViewTest6';


export default function App() {
  return (
    <SafeAreaView style={styles.rootContainer}>
      <ScrollView>
        <ModalViewTest0/>
        <ModalViewTest1/>
        <ModalViewTest2/>
        <ModalViewTest3/>
        <ModalViewTest4/>
        <ModalViewTest5/>
        <ModalViewTest6/>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  rootContainer: {
    flex: 1,
  },
});
