import * as React from 'react';
import { StyleSheet, ScrollView, SafeAreaView } from 'react-native';

import { ModalViewTest0 } from './components/ModalViewTest0';
import { ModalViewTest1 } from './components/ModalViewTest1';
import { ModalViewTest2 } from './components/ModalViewTest2';
import { ModalViewTest3 } from './components/ModalViewTest3';
import { ModalViewTest4 } from './components/ModalViewTest4';
import { ModalViewTest6 } from './components/ModalViewTest6';
import { ModalViewTest7 } from './components/ModalViewTest7';
import { ModalViewTest8 } from './components/ModalViewTest8';


export default function App() {
  return (
    <SafeAreaView style={styles.rootContainer}>
      <ScrollView>
        <ModalViewTest0/>
        <ModalViewTest1/>
        <ModalViewTest2/>
        <ModalViewTest3/>
        <ModalViewTest4/>
        <ModalViewTest6/>
        <ModalViewTest7/>
        <ModalViewTest8/>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  rootContainer: {
    flex: 1,
  },
});
