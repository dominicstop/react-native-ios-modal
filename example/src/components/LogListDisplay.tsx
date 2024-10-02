
import * as React from 'react';
import { StyleSheet, View, Text, ScrollView, type ViewProps, type TextStyle } from 'react-native';

import { Helpers } from 'react-native-ios-utilities';


export type LogListDisplayItem = {
  timestamp: string;
  itemTitle: string;
  index: number;
};

export type LogListDisplayRef = {
  addItem: (itemTitle: string) => void;
};

export type LogListDisplayProps = ViewProps & {
  maxItemsToShow?: number;
  logItemIndexTextStyle?: TextStyle;
  logItemTimestampTextStyle?: TextStyle;
  logItemTitleTextStyle?: TextStyle;
};

export const LogListDisplay = React.forwardRef<
  LogListDisplayRef,
  LogListDisplayProps
>((props, ref) => {
  const [events, setEvents] = React.useState<Array<LogListDisplayItem>>([]);
  
  const hasEvents = (events.length > 0);
  const maxItemsToShow = props.maxItemsToShow ?? 15;

  const recentEventsSorted = events.sort((a, b) =>  a.index - b.index);
  const recentEvents = recentEventsSorted.slice(-maxItemsToShow);

  React.useImperativeHandle(ref, () => ({
    addItem: (itemTitle) => {
      const date = new Date();

      const h = Helpers.pad(date.getHours  ());
      const m = Helpers.pad(date.getMinutes());
      const s = Helpers.pad(date.getSeconds());

      const ms = Helpers.pad(date.getMilliseconds(), 3);
      
      setEvents((prevValue) => ([ 
        ...prevValue, 
        {
          timestamp: `${h}:${m}:${s}.${ms}`,
          itemTitle: itemTitle,
          index: prevValue.length
        }
      ]));
    },
  }));

  return (  
    <View style={[
      styles.eventContainer,
      !hasEvents && styles.eventContainerEmpty, 
      props.style, 
    ]}>
      {hasEvents? (
        <ScrollView 
          nestedScrollEnabled={true}
        >
          {recentEvents.map((item) => (
            <View 
              key={`${item.index}-event-${item.timestamp}-${item.itemTitle}`}
              style={styles.eventListItemContainer}
            >
              <Text 
                style={[
                  styles.logItemText,
                  styles.logItemIndexText,
                  props.logItemIndexTextStyle
                ]}
                numberOfLines={1}
              >
                {`${Helpers.pad(item.index, 3)}`}
              </Text>
              <Text 
                style={[
                  styles.logItemText,
                  styles.logItemTimestampText,
                  props.logItemTimestampTextStyle
                ]}
                numberOfLines={1}
              >
                {`${item.timestamp}`}
              </Text>
              <Text style={[
                styles.logItemText,
                styles.logItemTitleText,
                props.logItemTitleTextStyle,
              ]}>
                {item.itemTitle}
              </Text>
            </View>
          ))}
        </ScrollView>
      ):(
        <Text style={styles.eventEmptyText}>
          {'No Events To Show'}
        </Text>
      )}
    </View>
  );
});

const styles = StyleSheet.create({
  eventContainer: {
    marginTop: 15,
    height: 150,
    backgroundColor: 'rgba(255,255,255,0.3)',
    borderRadius: 10,
    paddingHorizontal: 12,
    paddingVertical: 7,
  },
  eventContainerEmpty: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  eventEmptyText: {
    fontWeight: '600',
    fontSize: 16,
    color: 'rgba(0,0,0,0.4)',
  },
  eventListItemContainer: {
    flexDirection: 'row',
  },
  logItemText: {
    fontSize: 12,
    fontVariant: ['tabular-nums'],
  },
  logItemIndexText: {
    minWidth: 30,
    fontWeight: '600',
    color: 'rgba(0,0,0,0.3)',
  },
  logItemTimestampText: {
    minWidth: 80,
    fontWeight: '300',
    color: 'rgba(0,0,0,0.75)',
  },
  logItemTitleText: {
    fontWeight: '400',
    color: 'rgba(0,0,0,0.9)',
  },
});