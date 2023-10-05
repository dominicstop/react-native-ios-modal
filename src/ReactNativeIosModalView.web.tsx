import * as React from 'react';

import { ReactNativeIosModalViewProps } from './ReactNativeIosModal.types';

export default function ReactNativeIosModalView(props: ReactNativeIosModalViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
