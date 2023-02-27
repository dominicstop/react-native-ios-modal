import * as React from 'react';
import { View, Text, StyleSheet } from 'react-native';

import type { CardLogDisplayItem } from './CardLogDisplayTypes';

import * as Helpers from '../../../functions/Helpers';

export function CardLogDisplayListRow(props: { item: CardLogDisplayItem }) {
  const { item } = props;
  const date = new Date(item.timestamp);

  const h = Helpers.pad(date.getHours());
  const m = Helpers.pad(date.getMinutes());
  const s = Helpers.pad(date.getSeconds());
  const ms = Helpers.pad(date.getMilliseconds(), 3);

  const timeString = `${h}:${m}:${s}.${ms}`;

  return (
    <View style={styles.logListItemContainer}>
      <Text style={styles.logItemIndexText}>
        {`${Helpers.pad(item.index, 3)}`}
      </Text>
      <Text style={styles.logItemTimestampText}>{timeString}</Text>
      <Text style={styles.logItemTypeText}>{item.title}</Text>
    </View>
  );
}

// Section - Styles
// ----------------

const styles = StyleSheet.create({
  logListItemContainer: {
    flexDirection: 'row',
  },
  logItemIndexText: {
    fontVariant: ['tabular-nums'],
    fontWeight: 'bold',
    opacity: 0.4,
  },
  logItemTimestampText: {
    fontVariant: ['tabular-nums'],
    fontWeight: '700',
    marginLeft: 10,
    opacity: 0.4,
    textDecorationLine: 'underline',
    textDecorationColor: 'rgba(0,0,0,0.4)',
  },
  logItemTypeText: {
    marginLeft: 10,
    opacity: 0.9,
  },
});
