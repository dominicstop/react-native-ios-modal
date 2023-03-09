import * as React from 'react';
import {
  StyleSheet,
  SafeAreaView,
  FlatList,
  ListRenderItem,
} from 'react-native';

import type { ExampleProps } from '../examples/SharedExampleTypes';

import { Test00 } from '../examples/Test00';
import { Test01 } from '../examples/Test01';
import { Test02 } from '../examples/Test02';
import { Test03 } from '../examples/Test03';
import { Test04 } from '../examples/Test04';
import { Test05 } from '../examples/Test05';
import { Test06 } from '../examples/Test06';
import { Test07 } from '../examples/Test07';

import { Example01 } from '../examples/Example01';

import { DebugControls } from '../examples/DebugControls';
import { SHARED_ENV } from '../constants/SharedEnv';

type ExampleListItem = {
  id: number;
  component: React.FC<ExampleProps>;
};

type ExampleFunctionalComponentItem = (props: ExampleProps) => JSX.Element;

type ExampleClassComponentItem =
  | typeof React.PureComponent<ExampleProps, any>
  | typeof React.Component<ExampleProps, any>;

type ExampleComponentItem =
  | ExampleFunctionalComponentItem
  | ExampleClassComponentItem
  | false;

const EXAMPLE_COMPONENTS: Array<ExampleComponentItem> = [
  Test00,
  Test01,
  Test02,
  Test03,
  Test04,
  Test05,
  Test06,
  Test07,
  Example01,
  SHARED_ENV.enableReactNavigation && DebugControls,
];

const EXAMPLE_ITEMS = EXAMPLE_COMPONENTS.filter(
  (item): item is ExampleFunctionalComponentItem => item != null
).map((item, index) => ({
  id: index + 1,
  component: item,
}));

export function HomeScreen() {
  const renderItem: ListRenderItem<ExampleListItem> = ({ item }) =>
    React.createElement(item.component, {
      index: item.id,
      style: styles.exampleListItem,
    });

  return (
    <SafeAreaView>
      <FlatList
        contentContainerStyle={styles.scrollContentContainer}
        data={EXAMPLE_ITEMS}
        renderItem={renderItem}
        keyExtractor={(item) => `item-${item.id}`}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  scrollContentContainer: {
    paddingHorizontal: 10,
    paddingBottom: 100,
    paddingTop: 20,
  },
  exampleListItem: {
    marginBottom: 15,
  },
});
