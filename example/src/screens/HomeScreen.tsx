import * as React from 'react';
import { StyleSheet, SafeAreaView, FlatList, ListRenderItem } from 'react-native';


import type { ExampleProps } from '../examples/SharedExampleTypes';


import { DebugControls } from '../examples/DebugControls';
import { SHARED_ENV } from '../constants/SharedEnv';


type ExampleListItem = {
  id: number;
  component: React.FC<ExampleProps>;
};

const EXAMPLE_COMPONENTS = [
  SHARED_ENV.enableReactNavigation && DebugControls,
];

const EXAMPLE_ITEMS: ExampleListItem[] = EXAMPLE_COMPONENTS.map((item, index) => ({
  id: index + 1,
  component: item
}));

export function HomeScreen() {
  const renderItem: ListRenderItem<ExampleListItem>  = ({ item })  => (
    React.createElement(item.component, {
      index: item.id,
      style: styles.exampleListItem
    })
  );

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
};

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