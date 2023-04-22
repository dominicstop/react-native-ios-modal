import React from 'react';

import {
  findNodeHandle,
  StyleSheet,
  View,
  ScrollView,
  Platform,
  ViewProps,
  NativeSyntheticEvent,
} from 'react-native';

import { RNIWrapperView } from '../../temp';

import { TSEventEmitter } from '@dominicstop/ts-event-emitter';

import * as Helpers from '../../functions/helpers';

import { ModalContext } from '../../context/ModalContext';

import {
  OnModalWillPresentEvent,
  OnModalDidPresentEvent,
  OnModalWillDismissEvent,
  OnModalDidDismissEvent,
  OnModalWillShowEvent,
  OnModalDidShowEvent,
  OnModalWillHideEvent,
  OnModalDidHideEvent,
  OnModalWillFocusEvent,
  OnModalDidFocusEvent,
  OnModalWillBlurEvent,
  OnModalDidBlurEvent,
  OnPresentationControllerWillDismissEvent,
  OnPresentationControllerDidDismissEvent,
  OnPresentationControllerDidAttemptToDismissEvent,
  RNIModalView,
  RNIModalBaseEvent,
  RNIModalDeprecatedBaseEvent,
  OnModalDetentDidComputeEvent,
  OnModalDidChangeSelectedDetentIdentifierEvent,
} from '../../native_components/RNIModalView';

import { RNIModalViewModule } from '../../native_modules/RNIModalViewModule';

import type { ModalViewProps, ModalViewState } from './ModalViewTypes';

import {
  ModalViewEmitterEvents,
  ModalViewEventEmitter,
} from './ModalViewEmitter';

import {
  hasScrollViewContext,
  NATIVE_ID_KEYS,
  VirtualizedListContext,
} from './ModalViewConstants';
import { ModalViewEmitterEventsDeprecated } from './ModalViewEmitterDeprecated';

// prettier-ignore
export class ModalView extends
  React.PureComponent<ModalViewProps, ModalViewState> {

  private nativeRefModalView!: React.Component;
  private emitter: ModalViewEventEmitter;

  constructor(props: ModalViewProps) {
    super(props);

    const defaultProps = this.getProps(props);

    this.emitter = new TSEventEmitter();

    this.state = {
      isModalVisible: false,
      childProps: null,
      enableSwipeGesture: defaultProps.enableSwipeGesture,
      isModalInPresentation: defaultProps.isModalInPresentation,
      isModalInFocus: false,
    };
  }

  componentWillUnmount() {
    const { autoCloseOnUnmount } = this.getProps();
    const { isModalVisible: visible } = this.state;

    if (autoCloseOnUnmount && visible) {
      this.setVisibility(false);
    }
  }

  private getProps = (propOverride: ModalViewProps | null = null) => {
    const {
      // Native Props - General
      modalID,
      shouldEnableAggressiveCleanup,

      // Native Props - BG-Related
      isModalBGBlurred,
      isModalBGTransparent,
      modalBGBlurEffectStyle,

      // Native Props - Presentation/Transition
      modalPresentationStyle,
      modalTransitionStyle,
      hideNonVisibleModals,
      presentViaMount,
      enableSwipeGesture,
      allowModalForceDismiss,
      isModalInPresentation,

      // Native Props - Sheet-Related
      modalSheetDetents,
      sheetPrefersScrollingExpandsWhenScrolledToEdge,
      sheetPrefersEdgeAttachedInCompactHeight,
      sheetWidthFollowsPreferredContentSizeWhenEdgeAttached,
      sheetPrefersGrabberVisible,
      sheetShouldAnimateChanges,
      sheetLargestUndimmedDetentIdentifier,
      sheetPreferredCornerRadius,
      sheetSelectedDetentIdentifier,

      // Native Props - Events
      onModalWillPresent,
      onModalDidPresent,
      onModalWillDismiss,
      onModalDidDismiss,
      onModalWillShow,
      onModalDidShow,
      onModalWillHide,
      onModalDidHide,
      onModalWillFocus,
      onModalDidFocus,
      onModalWillBlur,
      onModalDidBlur,
      onPresentationControllerWillDismiss,
      onPresentationControllerDidDismiss,
      onPresentationControllerDidAttemptToDismiss,
      onModalDetentDidCompute,
      onModalDidChangeSelectedDetentIdentifier,

      // Component Props
      autoCloseOnUnmount,
      setEnableSwipeGestureFromProps,
      setModalInPresentationFromProps,
      containerStyle,
      isModalContentLazy,

      children,
      ...viewProps
    } = propOverride ?? this.props;

    return ({
      // A - Add Default Values
      presentViaMount: (
        presentViaMount ?? false
      ),
      isModalBGBlurred: (
        isModalBGBlurred ?? true
      ),
      enableSwipeGesture: (
        enableSwipeGesture ?? true
      ),
      hideNonVisibleModals: (
        hideNonVisibleModals ?? false
      ),
      isModalBGTransparent: (
        isModalBGTransparent ?? true
      ),
      modalTransitionStyle: (
        modalTransitionStyle ?? 'coverVertical'
      ),
      modalPresentationStyle: (
        modalPresentationStyle ?? 'automatic'
      ),
      autoCloseOnUnmount: (
        autoCloseOnUnmount ?? true
      ),
      setEnableSwipeGestureFromProps: (
        setEnableSwipeGestureFromProps ?? false
      ),
      setModalInPresentationFromProps: (
        setModalInPresentationFromProps ?? false
      ),
      isModalInPresentation: (
        isModalInPresentation ?? false
      ),
      isModalContentLazy: (
        isModalContentLazy ?? true
      ),
      shouldEnableAggressiveCleanup: (
        shouldEnableAggressiveCleanup ?? true
      ),

      // B - Pass down...
      containerStyle,
      modalID,
      allowModalForceDismiss,
      modalBGBlurEffectStyle,
      modalSheetDetents,
      sheetPrefersScrollingExpandsWhenScrolledToEdge,
      sheetPrefersEdgeAttachedInCompactHeight,
      sheetWidthFollowsPreferredContentSizeWhenEdgeAttached,
      sheetPrefersGrabberVisible,
      sheetShouldAnimateChanges,
      sheetLargestUndimmedDetentIdentifier,
      sheetPreferredCornerRadius,
      sheetSelectedDetentIdentifier,
      onModalWillPresent,
      onModalDidPresent,
      onModalWillDismiss,
      onModalDidDismiss,
      onModalWillShow,
      onModalDidShow,
      onModalWillHide,
      onModalDidHide,
      onModalWillFocus,
      onModalDidFocus,
      onModalWillBlur,
      onModalDidBlur,
      onPresentationControllerWillDismiss,
      onPresentationControllerDidDismiss,
      onPresentationControllerDidAttemptToDismiss,
      onModalDetentDidCompute,
      onModalDidChangeSelectedDetentIdentifier,

      // C - View-Related Props
      children,
      viewProps,
    });
  };

  getEmitterRef = () => {
    return this.emitter;
  };

  setVisibility = async (
    nextVisible: boolean,
    childProps: object | null = null
  ) => {
    const props = this.getProps();
    const { isModalVisible: prevVisible } = this.state;

    const didChange = (prevVisible !== nextVisible);

    if (!didChange) {
      return;
    }

    if (nextVisible) {
      // Show modal...
      // When showing modal, mount children first,
      await Helpers.setStateAsync(this, {
        isModalVisible: nextVisible,
        // pass down received props to childProps via state
        childProps: Helpers.isObject(childProps) ? childProps : null,
      });

      // wait for view to mount
      if (props.isModalContentLazy){
        await Helpers.promiseWithTimeout(500, new Promise<void>((resolve) => {
          this.emitter.once(ModalViewEmitterEvents.onLayoutModalContentContainer, () => {
            resolve();
          });
        }));
      }
    }

    try {
      // request modal to open/close
      await RNIModalViewModule.setModalVisibility(
        findNodeHandle(this.nativeRefModalView)!,
        nextVisible
      );

      // Hide modal...
      // When finish hiding modal, unmount children
      if (!nextVisible) {
        await Helpers.setStateAsync(this, {
          isModalVisible: nextVisible,
          childProps: null,
        });
      }
    } catch (error) {
      console.log('ModalView, setVisibility failed:');
      console.log(error);
      throw error;
    }
  };

  getModalInfo = async () => {
    try {
      // request modal to send modal info
      return await RNIModalViewModule.requestModalInfo(
        findNodeHandle(this.nativeRefModalView)!
      );
    } catch (error) {
      console.log('ModalView, requestModalInfo failed:');
      console.log(error);
      throw error;
    }
  };

  setEnableSwipeGesture = async (
    enableSwipeGesture: boolean
  ) => {
    const { enableSwipeGesture: prevVal } = this.state;
    if (prevVal !== enableSwipeGesture) {
      await Helpers.setStateAsync(this, { enableSwipeGesture });
    }
  };

  setIsModalInPresentation = async (
    isModalInPresentation: boolean
  ) => {
    const { isModalInPresentation: prevVal } = this.state;
    if (prevVal !== isModalInPresentation) {
      await Helpers.setStateAsync(this, { isModalInPresentation });
    }
  };

  // Event Handlers
  // --------------

  // We don't want any responder events bubbling out of the modal.
  private _shouldSetResponder() {
    return true;
  }

  private _handleOnLayoutModalContentContainer: ViewProps['onLayout'] = (event) => {
    this.emitter.emit(
      ModalViewEmitterEvents.onLayoutModalContentContainer,
      event.nativeEvent
    );

    event.stopPropagation();
  };

  // the child comp can call `props.getModalRef` to receive
  // a ref to this modal comp
  private _handleGetModalRef = () => {
    return this;
  };

  // Native Event Handlers
  // ---------------------

  private _handleOnModalWillPresent: OnModalWillPresentEvent = (event) => {
    const props = this.props;

    props.onModalWillPresent?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalWillPresent,
      event.nativeEvent
    );
  };

  private _handleOnModalDidPresent: OnModalDidPresentEvent = (event) => {
    const props = this.props;

    props.onModalDidPresent?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalDidPresent,
      event.nativeEvent
    );
  };

  private _handleOnModalWillDismiss: OnModalWillDismissEvent = (event) => {
    const props = this.props;

    props.onModalWillDismiss?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalWillDismiss,
      event.nativeEvent
    );
  };

  private _handleOnModalDidDismiss: OnModalDidDismissEvent = (event) => {
    const props = this.props;

    props.onModalDidDismiss?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalDidDismiss,
      event.nativeEvent
    );
  };

  private _handleOnModalWillShow: OnModalWillShowEvent = (event) => {
    const props = this.props;

    props.onModalWillShow?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalWillShow,
      event.nativeEvent
    );
  };

  private _handleOnModalDidShow: OnModalDidShowEvent = (event) => {
    const props = this.props;

    props.onModalDidShow?.(event);
    props.onModalShow?.(
      ModalViewHelpers.createDeprecatedBaseEventObject(event)
    );

    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalDidShow,
      event.nativeEvent
    );

    this.emitter.emit(
      ModalViewEmitterEventsDeprecated.onModalShow,
      ModalViewHelpers.createDeprecatedEventObject(
        event.nativeEvent
      )
    );

    this.setState({
      isModalVisible: true,
    });
  };

  private _handleOnModalWillHide: OnModalWillHideEvent = (event) => {
    const props = this.props;

    props.onModalWillHide?.(event);

    this.emitter.emit(
      ModalViewEmitterEvents.onModalWillHide,
      event.nativeEvent
    );

    event.stopPropagation();
  };

  private _handleOnModalDidHide: OnModalDidHideEvent = (event) => {
    const props = this.props;

    props.onModalDidHide?.(event);
    props.onModalDismiss?.(
      ModalViewHelpers.createDeprecatedBaseEventObject(event)
    );

    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalDidHide,
      event.nativeEvent
    );

    this.emitter.emit(
      ModalViewEmitterEventsDeprecated.onModalDismiss,
      ModalViewHelpers.createDeprecatedEventObject(
        event.nativeEvent
      )
    );

    this.setState({
      isModalVisible: false,
    });
  };

  private _handleOnModalWillFocus: OnModalWillFocusEvent = (event) => {
    const props = this.props;

    props.onModalWillFocus?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalWillFocus,
      event.nativeEvent
    );
  };

  private _handleOnModalDidFocus: OnModalDidFocusEvent = (event) => {
    const props = this.props;

    props.onModalDidFocus?.(event);
    props.onModalFocus?.(
      ModalViewHelpers.createDeprecatedBaseEventObject(event)
    );

    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalDidFocus,
      event.nativeEvent
    );

    this.emitter.emit(
      ModalViewEmitterEventsDeprecated.onModalFocus,
      ModalViewHelpers.createDeprecatedEventObject(
        event.nativeEvent
      )
    );

    this.setState({
      isModalInFocus: true,
    });
  };

  private _handleOnModalWillBlur: OnModalWillBlurEvent = (event) => {
    const props = this.props;

    props.onModalWillBlur?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalWillBlur,
      event.nativeEvent
    );
  };

  private _handleOnModalDidBlur: OnModalDidBlurEvent = (event) => {
    const props = this.props;

    props.onModalDidBlur?.(event);
    props.onModalBlur?.(
      ModalViewHelpers.createDeprecatedBaseEventObject(event)
    );

    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalDidBlur,
      event.nativeEvent
    );

    this.emitter.emit(
      ModalViewEmitterEventsDeprecated.onModalBlur,
      ModalViewHelpers.createDeprecatedEventObject(
        event.nativeEvent
      )
    );

    this.setState({
      isModalInFocus: false,
    });
  };

  private _handleOnPresentationControllerWillDismiss: OnPresentationControllerWillDismissEvent = (event) => {
    const props = this.props;

    props.onPresentationControllerWillDismiss?.(event);
    props._onModalWillDismiss?.(
      ModalViewHelpers.createDeprecatedBaseEventObject(event)
    );

    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onPresentationControllerWillDismiss,
      event.nativeEvent
    );

    this.emitter.emit(
      ModalViewEmitterEventsDeprecated._onModalWillDismiss,
      ModalViewHelpers.createDeprecatedEventObject(
        event.nativeEvent
      )
    );
  };

  private _handleOnPresentationControllerDidDismiss: OnPresentationControllerDidDismissEvent = (event) => {
    const props = this.props;

    props.onPresentationControllerDidDismiss?.(event);
    props._onModalDidDismiss?.(
      ModalViewHelpers.createDeprecatedBaseEventObject(event)
    );

    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onPresentationControllerDidDismiss,
      event.nativeEvent
    );

    this.emitter.emit(
      ModalViewEmitterEventsDeprecated._onModalDidDismiss,
      ModalViewHelpers.createDeprecatedEventObject(
        event.nativeEvent
      )
    );
  };

  private _handleOnPresentationControllerDidAttemptToDismiss: OnPresentationControllerDidAttemptToDismissEvent = (event) => {
    const props = this.props;

    props.onPresentationControllerDidAttemptToDismiss?.(event);
    props.onModalAttemptDismiss?.(
      ModalViewHelpers.createDeprecatedBaseEventObject(event)
    );

    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onPresentationControllerDidAttemptToDismiss,
      event.nativeEvent
    );

    this.emitter.emit(
      ModalViewEmitterEventsDeprecated.onModalAttemptDismiss,
      ModalViewHelpers.createDeprecatedEventObject(
        event.nativeEvent
      )
    );
  };

  private _handleOnModalDetentDidCompute: 
    OnModalDetentDidComputeEvent = (event) => {

    const props = this.props;

    props.onModalDetentDidCompute?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalDetentDidCompute,
      event.nativeEvent
    );
  };

  private _handleOnModalDidChangeSelectedDetentIdentifier:
    OnModalDidChangeSelectedDetentIdentifierEvent = (event) => {

    const props = this.props;

    props.onModalDidChangeSelectedDetentIdentifier?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalDidChangeSelectedDetentIdentifier,
      event.nativeEvent
    );
  };

 private _renderModal() {
    const { viewProps, ...props } = this.getProps();
    const state = this.state;

    const overrideProps = {
      ...(props.setModalInPresentationFromProps && {
        isModalInPresentation: state.isModalInPresentation,
      }),

      ...(props.setEnableSwipeGestureFromProps && {
        enableSwipeGesture: state.enableSwipeGesture,
      }),
    };

    // TODO: See TODO:2023-03-04-12-50-04 - Fix:
    // isModalContentLazy Prop
    //
    // * Error when opening modal once it's been closed
    const shouldMountModalContent =
      !props.isModalContentLazy || state.isModalVisible;

    return (
      <RNIModalView
        {...props}
        ref={(r) => {
          this.nativeRefModalView = r!;
        }}
        style={styles.nativeModalView}
        onStartShouldSetResponder={this._shouldSetResponder}
        onModalWillPresent={this._handleOnModalWillPresent}
        onModalDidPresent={this._handleOnModalDidPresent}
        onModalWillDismiss={this._handleOnModalWillDismiss}
        onModalDidDismiss={this._handleOnModalDidDismiss}
        onModalWillShow={this._handleOnModalWillShow}
        onModalDidShow={this._handleOnModalDidShow}
        onModalWillHide={this._handleOnModalWillHide}
        onModalDidHide={this._handleOnModalDidHide}
        onModalWillFocus={this._handleOnModalWillFocus}
        onModalDidFocus={this._handleOnModalDidFocus}
        onModalWillBlur={this._handleOnModalWillBlur}
        onModalDidBlur={this._handleOnModalDidBlur}
        onPresentationControllerWillDismiss={this._handleOnPresentationControllerWillDismiss}
        onPresentationControllerDidDismiss={this._handleOnPresentationControllerDidDismiss}
        onPresentationControllerDidAttemptToDismiss={this._handleOnPresentationControllerDidAttemptToDismiss}
        onModalDetentDidCompute={this._handleOnModalDetentDidCompute}
        onModalDidChangeSelectedDetentIdentifier={this._handleOnModalDidChangeSelectedDetentIdentifier}
        {...overrideProps}
        {...viewProps}
      >
        {shouldMountModalContent && (
          <RNIWrapperView
            style={styles.modalContentWrapper}
            nativeID={NATIVE_ID_KEYS.modalViewContent}
            isDummyView={false}
            collapsable={false}
            shouldAutoDetachSubviews={false}
            shouldCreateTouchHandlerForSubviews={true}
            shouldNotifyComponentWillUnmount={props.shouldEnableAggressiveCleanup}
            shouldAutoCleanupOnJSUnmount={props.shouldEnableAggressiveCleanup}
            onLayout={this._handleOnLayoutModalContentContainer}
          >
            <View style={[styles.modalContentContainer, props.containerStyle]}>
              {React.cloneElement(props.children as any, {
                getModalRef: this._handleGetModalRef,
                // pass down props received from setVisibility
                ...(Helpers.isObject(state.childProps) && state.childProps),
                // pass down modalID
                modalID: props.modalID,
              })}
            </View>
          </RNIWrapperView>
        )}
      </RNIModalView>
    );
  }

  render() {
    const state = this.state;

    if (Platform.OS !== 'ios') {
      return null;
    }

    return (
      <ModalContext.Provider
        value={{
          isModalInFocus: state.isModalInFocus,
          isModalVisible: state.isModalVisible,

          // pass down function to get modal refs
          getModalRef: this._handleGetModalRef,
          getEmitterRef: this.getEmitterRef,

          // pass ref to modal functions
          setVisibility: this.setVisibility,
          setEnableSwipeGesture: this.setEnableSwipeGesture,
          setIsModalInPresentation: this.setIsModalInPresentation,
        }}
      >
        <VirtualizedListContext.Provider value={null}>
          {hasScrollViewContext ? (
            // @ts-ignore
            <ScrollView.Context.Provider value={null}>
              {this._renderModal()}
              {/*
               // @ts-ignore */}
            </ScrollView.Context.Provider>
          ) : (
            this._renderModal()
          )}
        </VirtualizedListContext.Provider>
      </ModalContext.Provider>
    );
  }
}

const styles = StyleSheet.create({
  nativeModalView: {
    position: 'absolute',
    width: 0,
    height: 0,
    overflow: 'hidden',
  },
  modalContentWrapper: {
    position: 'absolute',
    overflow: 'visible',
    top: 0,
    bottom: 0,
    left: 0,
    right: 0,
  },
  modalContentContainer: {
    flex: 1,
  },
});

class ModalViewHelpers {
  static createDeprecatedEventObject(
    event: RNIModalBaseEvent
  ): RNIModalDeprecatedBaseEvent {
    return {
      modalUUID: event.modalNativeID,
      modalID: event.modalID,
      reactTag: event.reactTag,
      isInFocus: event.isModalInFocus,
      modalLevel: event.modalIndex,
      modalLevelPrev: event.modalIndexPrev,
      isPresented: event.isModalPresented,
    };
  }

  static createDeprecatedBaseEventObject(
    event: NativeSyntheticEvent<RNIModalBaseEvent>
  ): NativeSyntheticEvent<RNIModalDeprecatedBaseEvent> {
    return {
      ...event,
      nativeEvent: ModalViewHelpers.createDeprecatedEventObject(
        event.nativeEvent
      ),
    };
  }
}
