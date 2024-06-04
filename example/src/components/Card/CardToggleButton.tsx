import * as React from 'react';

import { CardButton } from './CardButton';

export function CardToggleButton(props: {
  title: string;
  subtitle?: string;
  value: boolean;
  indicatorOn?: string;
  indicatorOff?: string;
  onPress: (value: boolean) => void;
}) {
  const prefix = props.value
    ? props.indicatorOn ?? '☀️'
    : props.indicatorOff ?? '🌙';

  return (
    <CardButton
      title={`${prefix} ${props.title}`}
      subtitle={props.subtitle}
      onPress={() => {
        props.onPress(!props.value);
      }}
    />
  );
}
