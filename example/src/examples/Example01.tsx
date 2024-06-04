import * as React from 'react';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleCard } from '../components/ExampleCard';
import { CardButton } from '../components/Card';

export function Example01(props: ExampleProps) {
  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Example01'}
      subtitle={'TBA'}
      description={['TBA', 'TBA']}
    >
      <CardButton
        title={'Show Modal'}
        onPress={() => {
          // TBA
        }}
      />
    </ExampleCard>
  );
}
