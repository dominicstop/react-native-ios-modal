import * as React from 'react';

import type { ExampleProps } from './SharedExampleTypes';

import { ExampleButtonCard } from '../components/ExampleButtonCard';


export function Example01(props: ExampleProps) {
  return (
    <ExampleButtonCard
      style={props.style}
      index={props.index}
      title={'Example01'}
      subtitle={'TBA'}
      description={[
        `TBA`,
        `TBA`
      ]}
    >
      {/** TBA */}
    </ExampleButtonCard>
  );
};