import * as React from 'react';
import { StyleSheet, View, Text, ScrollView, ViewStyle } from 'react-native';

import * as Helpers from '../../functions/Helpers';

// Section - Types - Internal
// --------------------------

type DisplayListModePropFixed = {
  listDisplayMode: 'FIXED';
  listMaxItemsToShow?: number;
};

type DisplayListModePropScroll = {
  listDisplayMode: 'SCROLL_ENABLED' | 'SCROLL_FIXED';
  listMaxItems?: number;
  listMinHeight?: number;
  scrollViewStyle?: ViewStyle;
  contentContainerStyle?: ViewStyle;
};

type DisplayListModeProp = DisplayListModePropFixed | DisplayListModePropScroll;

type CardLogDisplayBaseProps = {
  style?: ViewStyle;
  initialLogItems?: Array<CardLogDisplayItem>;
  listEmptyMessage?: string;
};

type CardLogDisplayProps = CardLogDisplayBaseProps & DisplayListModeProp;

type InternalListMode = CardLogDisplayListMode | 'EMPTY';

export type CardLogDisplayItem = {
  timestamp: number;
  title: string;
  index: number;
};

// Section - Types - Public
// ------------------------

export type CardLogDisplayListMode = DisplayListModeProp['listDisplayMode'];

export type CardLogDisplayHandle = {
  log: (title: string) => void;
  clearLogs: () => void;
  setLogs: (nextLogs: CardLogDisplayItem[]) => void;
};

// Section - Helpers
// -----------------

class HelpersInternal {
  static isDisplayListModePropScroll(
    props: CardLogDisplayProps
  ): props is CardLogDisplayProps & DisplayListModePropScroll {
    return (
      /* 1 */ props.listDisplayMode === 'SCROLL_ENABLED' ||
      /* 2 */ props.listDisplayMode === 'SCROLL_FIXED'
    );
  }

  static isDisplayListModePropFixed(
    props: CardLogDisplayProps
  ): props is CardLogDisplayProps & DisplayListModePropFixed {
    return props.listDisplayMode === 'FIXED';
  }
}

// Section - Component
// -------------------

function CardLogDisplayListRow(props: { item: CardLogDisplayItem }) {
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
      const listEmptyMessage = props.listEmptyMessage ?? 'No Items To Show...'
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
