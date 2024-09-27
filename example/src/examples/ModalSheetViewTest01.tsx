/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet } from 'react-native';

import { ExampleItemCard, ObjectPropertyDisplay, CardButton, Colors } from 'react-native-ios-utilities';
import { ModalSheetView, ModalSheetViewMainContent, type ModalSheetViewRef } from 'react-native-ios-modal';

import type { ExampleItemProps } from './SharedExampleTypes';
import type { ModalMetrics } from '../../../src/types/ModalMetrics';


export function ModalSheetViewTest01(props: ExampleItemProps) {
  const modalSheetViewRef = React.useRef<ModalSheetViewRef | null>(null);

  const [
    modalMetrics,
    setModalMetrics
  ] = React.useState<ModalMetrics | undefined>();

  const [
    shouldMountRecursiveContent,
    setShouldMountRecursiveContent,
  ] = React.useState(false);

  const recursionLevel = 
    props.extraProps?.recursionLevel as any as number ?? 0;

  let dataForDebugDisplay = {
  };
  
  if(modalMetrics != null) {
    const modalMetricsUpdated = {
      ...modalMetrics,
      modalViewControllerMetrics: {
        ...modalMetrics.modalViewControllerMetrics,
        instanceID: [
          modalMetrics.modalViewControllerMetrics.instanceID
        ],
      },
      presentationControllerMetrics: {
        ...modalMetrics.presentationControllerMetrics,
        instanceID: [
          modalMetrics.presentationControllerMetrics?.instanceID
        ],
      },
    };

    dataForDebugDisplay = {
      ...dataForDebugDisplay,
      ...modalMetricsUpdated
    };
  };

  const hasDataForDebugDisplay = 
    Object.keys(dataForDebugDisplay).length > 0;

  const isFirstRecursion = (recursionLevel == 0);

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
        object={hasDataForDebugDisplay 
          ? dataForDebugDisplay 
          : undefined
        }
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
        {!isFirstRecursion && (
          <CardButton
            title={'Dismiss Modal'}
            subtitle={'Dismiss current modal'}
            onPress={async () => {
              const modalSheetViewRefPrev: ModalSheetViewRef | null = 
                props.extraProps?.modalSheetViewRefPrev as any;
              
              if(modalSheetViewRefPrev == null){
                return;
              };

              await modalSheetViewRefPrev.dismissModal();
              console.log(
                'ModalSheetViewTest01',
                '\n - dismiss modal completed',
                `\n - recursionLevel: ${recursionLevel}`
              );
            }}
          />
        )}
        {!isFirstRecursion && (
          <CardButton
            title={'Get modal metrics for prev. modal'}
            subtitle={'invoke `getModalMetrics`'}
            onPress={async () => {

              const modalSheetViewRefPrev: ModalSheetViewRef | null = 
                props.extraProps?.modalSheetViewRefPrev as any;
              
              if(modalSheetViewRefPrev == null){
                return;
              };

              const modalMetrics = 
                await modalSheetViewRefPrev.getModalMetrics();

              setModalMetrics(modalMetrics);
              console.log(
                'ModalSheetViewTest01',
                '\n - invoked getModalMetrics',
                '\n',
                modalMetrics,
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
                  modalSheetViewRefPrev: modalSheetViewRef.current,
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