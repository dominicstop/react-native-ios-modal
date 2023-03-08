// Note: Created based on `example/src_old/ModalViewTest7.js`

// TODO - See TODO:2023-03-08-03-48-33
// * Enable `ModalView.isModalContentLazy` prop

import * as React from 'react';

import type { ExampleProps } from '../SharedExampleTypes';

import { ExampleCard } from '../../components/ExampleCard';

import { CardButton } from '../../components/Card';

import { ModalGroup, ModalGroupHandle } from './ModalGroup';

// Section: Test06
// --------------

export function Test06(props: ExampleProps) {
  const modalGroupRef = React.useRef<ModalGroupHandle>(null);

  return (
    <ExampleCard
      style={props.style}
      index={props.index}
      title={'Test06'}
      subtitle={'test - TBA'}
      description={['desc - TBA']}
    >
      <ModalGroup ref={modalGroupRef} />
      <CardButton
        title={'Show Modal'}
        onPress={() => {
          modalGroupRef.current?.showModal();
        }}
      />
    </ExampleCard>
  );
}
