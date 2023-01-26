import * as React from 'react';
import { Alert } from 'react-native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleButtonCard } from '../components/ExampleButtonCard';
import { ContextMenuCardButton } from '../components/ContextMenuCardButton';


export function Example01(props: ContextMenuExampleProps) {
  return (
    <ExampleButtonCard
      style={props.style}
      index={props.index}
      title={'ContextMenuButtonExample01'}
      subtitle={'actions text-only'}
      description={[
        `Context menu button with 3 actions (no icon, just text).`,
        `Long press on the button to show the context menu.`
      ]}
    >
      <ContextMenuButton
        menuConfig={{
          menuTitle: 'ContextMenuButtonSimpleExample01',
          menuItems: [{
            actionKey  : 'key-01',
            actionTitle: 'Action #1',
          }, {
            actionKey  : 'key-02'   ,
            actionTitle: 'Action #2',
          }, {
            actionKey  : 'key-03'   ,
            actionTitle: 'Action #3',
          }],
        }}
        onPressMenuItem={({nativeEvent}) => {
          Alert.alert(
            'onPressMenuItem Event',
            `actionKey: ${nativeEvent.actionKey} - actionTitle: ${nativeEvent.actionTitle}`
          );
        }}
      >
        <ContextMenuCardButton
          buttonTitle={'⭐️ Context Menu Button'}
        />
      </ContextMenuButton>
    </ExampleButtonCard>
  );
};