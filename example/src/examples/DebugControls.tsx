import * as React from 'react';

import { useNavigation } from '@react-navigation/native';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';
import { CardButton } from '../components/Card/CardButton';
import { SHARED_ENV } from '../constants/SharedEnv';

export function DebugControls(props: ExampleProps) {
  const navigation =
    // eslint-disable-next-line react-hooks/rules-of-hooks
    SHARED_ENV.enableReactNavigation && useNavigation();

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Debug Controls'}
      subtitle={'For testing and stuff'}
    >
      <CardButton
        title={'Push: Home'}
        subtitle={'Navigate to "Home" screen...'}
        onPress={() => {
          // @ts-ignore
          navigation.push('Home');
        }}
      />
      <CardButton
        title={'Push: Test 01'}
        subtitle={'Navigate to "Test" screen...'}
        onPress={() => {
          // @ts-ignore
          navigation.push('Test01');
        }}
      />
    </ExampleCard>
  );
}
