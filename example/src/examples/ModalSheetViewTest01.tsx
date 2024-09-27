/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet } from 'react-native';

import { ExampleItemCard, ObjectPropertyDisplay, CardButton, Colors } from 'react-native-ios-utilities';
import { ModalSheetView, ModalSheetViewMainContent, type ModalSheetViewRef } from 'react-native-ios-modal';

import type { ExampleItemProps } from './SharedExampleTypes';


export function ModalSheetViewTest01(props: ExampleItemProps) {
  const modalSheetViewRef = React.useRef<ModalSheetViewRef | null>(null);

  const [
    shouldMountRecursiveContent,
    setShouldMountRecursiveContent,
  ] = React.useState(false);

  const recursionLevel = 
    props.extraProps?.recursionLevel as any as number ?? 0;

  return (
    <ExampleItemCard
      style={props.style}
      index={props.index}
      title={'RNIDetachedViewTest02'}
      description={[
        "TBA",
      ]}
    >
      <ObjectPropertyDisplay
        recursiveStyle={styles.debugDisplayInner}
        object={undefined}
      />
      <CardButton
        title={'Present Sheet Modal'}
        subtitle={'Present content as sheet'}
        onPress={async () => {
          setShouldMountRecursiveContent(true);
          await modalSheetViewRef.current?.presentModal();
          console.log(
            'ModalSheetViewTest01',
            '\n - present modal completed',
            `\n - recursionLevel: ${recursionLevel}`
          );
        }}
      />
      <React.Fragment>
        {(recursionLevel != 0) && (
          <CardButton
            title={'Dismiss Modal'}
            subtitle={'Dismiss current modal'}
            onPress={async () => {
              await modalSheetViewRef.current?.dismissModal();
              console.log(
                'ModalSheetViewTest01',
                '\n - dismiss modal completed',
                `\n - recursionLevel: ${recursionLevel}`
              );
            }}
          />
        )}
      </React.Fragment>
      <ModalSheetView
        ref={ref => modalSheetViewRef.current = ref}
      >
        <ModalSheetViewMainContent
          contentContainerStyle={styles.modalContent}
        >
          <React.Fragment>
            {shouldMountRecursiveContent && (
              <ModalSheetViewTest01
                style={{
                  ...props.style,
                  ...styles.modalContentCard,
                }}
                index={props.index}
                extraProps={{
                  recursionLevel: recursionLevel + 1,
                }}
              />
            )}
          </React.Fragment>
        </ModalSheetViewMainContent>
      </ModalSheetView>
    </ExampleItemCard>
  );
};

const styles = StyleSheet.create({
  debugDisplayInner: {
    backgroundColor: `${Colors.PURPLE[200]}99`,
  },
  modalContent: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 12,
    paddingVertical: 24,
  },
  modalContentCard: {
    alignSelf: 'stretch',
  },
});