import * as React from 'react';
import { StyleSheet, View, Text, ScrollView, ViewStyle } from 'react-native';

import type {
  CardLogDisplayItem,
  CardLogDisplayProps,
  CardLogDisplayHandle,
  InternalListMode,
} from './CardLogDisplayTypes';

import { CardLogDisplayListRow } from './CardLogDisplayListRow';

import * as HelpersInternal from './CardLogDisplayHelpers';

export const CardLogDisplay = React.forwardRef<
  CardLogDisplayHandle,
  CardLogDisplayProps
>((props, ref) => {
  const [logList, setLogList] = React.useState<CardLogDisplayItem[]>(
    props.initialLogItems
  );

  // callable functions...
  React.useImperativeHandle(ref, () => ({
    log: (title) => {
      setLogList((prevItems) => [
        ...prevItems,
        {
          title,
          timestamp: Date.now(),
          index: prevItems.length,
        },
      ]);
    },
    clearLogs: () => {
      setLogList([]);
    },
    setLogs: (nextLogs) => {
      setLogList(nextLogs);
    },
  }));

  const listMode: InternalListMode =
    logList.length === 0
      ? /* true  */ 'EMPTY'
      : /* false */ props.listDisplayMode;

  // prettier-ignore
  const listMaxItems =
    props.listDisplayMode === 'FIXED' ? (props.listMaxItemsToShow ?? 10) :
    props.listDisplayMode === 'SCROLL_ENABLED' ? props.listMaxItems :
    /* default */ 20;

  const logListTruncated = logList
    .slice() // make a copy
    .reverse()
    .slice(-listMaxItems);

  switch (listMode) {
    case 'EMPTY':
      const listEmptyMessage = props.listEmptyMessage ?? 'No Items To Show...';
      return (
        <View
          style={[
            props.style,
            styles.logRootContainer,
            styles.logContainerEmpty,
          ]}
        >
          <Text style={styles.logEmptyText}>{listEmptyMessage}</Text>
        </View>
      );

    case 'FIXED':
      // guard
      if (!HelpersInternal.isDisplayListModePropFixed(props)) {
        break;
      }

      return (
        <View>
          {logListTruncated.map((item) => (
            <CardLogDisplayListRow
              key={`event-${item.timestamp}-${item.title}`}
              item={item}
            />
          ))}
        </View>
      );

    case 'SCROLL_ENABLED': /* fallthrough */
    case 'SCROLL_FIXED':
      const isScrollEnabled = listMode === 'SCROLL_ENABLED';

      // guard
      if (!HelpersInternal.isDisplayListModePropScroll(props)) {
        break;
      }

      const scrollViewHeight = props.listMinHeight ?? 150;

      const logRootContainerStyle: ViewStyle = {
        height: scrollViewHeight,
      };

      return (
        <ScrollView
          style={[
            props.scrollViewStyle,
            styles.logRootContainer,
            logRootContainerStyle,
          ]}
          scrollEnabled={isScrollEnabled}
          contentContainerStyle={[props.contentContainerStyle]}
        >
          {logListTruncated.map((item) => (
            <CardLogDisplayListRow
              key={`event-${item.timestamp}-${item.title}`}
              item={item}
            />
          ))}
        </ScrollView>
      );
  }

  return null;
});

// Section - Styles
// ----------------

const styles = StyleSheet.create({
  logRootContainer: {
    marginTop: 15,
    height: 150,
    backgroundColor: 'rgba(0,0,0,0.04)',
    borderRadius: 10,
    paddingHorizontal: 12,
    paddingVertical: 7,
  },
  logContainerEmpty: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  logEmptyText: {
    fontWeight: '600',
    fontSize: 16,
    color: 'rgba(0,0,0,0.35)',
  },
});
