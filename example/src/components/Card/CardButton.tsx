import * as React from 'react';
import {
  StyleSheet,
  Text,
  TouchableOpacity,
  GestureResponderEvent,
  ViewStyle,
} from 'react-native';

import * as Colors from '../../constants/Colors';

/**
 * ```
 * ┌─────────────────────────────┐
 * │ Title                       │
 * │ Subtitle                    │
 * └─────────────────────────────┘
 * ```
 */
export function CardButton(props: {
  title: string;
  subtitle?: string;
  onPress: (event: GestureResponderEvent) => void;
}) {
  // prettier-ignore
  const hasSubtitle = (
    props.subtitle != null ||
    props.subtitle === ''
  );

  const buttonContainer: ViewStyle = {
    alignItems: hasSubtitle ? 'flex-start' : 'center',
  };

  return (
    <TouchableOpacity
      style={[styles.cardButtonContainer, buttonContainer]}
      onPress={props.onPress}
    >
      <React.Fragment>
        <Text style={styles.cardButtonTitleText}>
          {props.title}
        </Text>
        {hasSubtitle && (
          <Text style={styles.cardButtonSubtitleText}>
            {props.subtitle}
          </Text>
        )}
      </React.Fragment>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  cardButtonContainer: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    backgroundColor: Colors.PURPLE.A200,
    borderRadius: 10,
    marginTop: 12,
  },
  cardButtonTitleText: {
    color: 'white',
    fontSize: 15,
    fontWeight: '700',
  },
  cardButtonSubtitleText: {
    color: 'white',
    fontWeight: '400',
  },
});
