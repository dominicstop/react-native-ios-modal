import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';

import { ModalViewTest1 } from './components/ModalViewTest1';

export default function App() {
  return (
    <ModalViewTest1/>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
