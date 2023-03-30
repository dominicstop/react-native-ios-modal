import React from 'react';

import {
  findNodeHandle,
  StyleSheet,
  ScrollView,
  Platform,
  ViewProps,
} from 'react-native';

import { RNIWrapperView } from '../../temp';

import { TSEventEmitter } from '@dominicstop/ts-event-emitter';

import * as Helpers from '../../functions/helpers';

import { ModalContext } from '../../context/ModalContext';

import {
  OnModalAttemptDismissEvent,
  OnModalBlurEvent,
  OnModalDidDismissEvent,
  OnModalDismissEvent,
  OnModalFocusEvent,
  OnModalShowEvent,
  RNIModalView,
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
      // native props - flags
      presentViaMount,
      isModalBGBlurred,
      enableSwipeGesture,
      hideNonVisibleModals,
      isModalBGTransparent,
      isModalInPresentation,
      allowModalForceDismiss,
      shouldEnableAggressiveCleanup,

      // native props - string
      modalID,
      modalTransitionStyle,
      modalBGBlurEffectStyle,
      modalPresentationStyle,

      // native props - events
      onModalShow,
      onModalDismiss,
      onModalBlur,
      onModalFocus,
      onModalDidDismiss,
      onModalWillDismiss,
      onModalAttemptDismiss,

      // component props
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
      modalID,
      allowModalForceDismiss,
      modalBGBlurEffectStyle,
      onModalShow,
      onModalDismiss,
      onModalBlur,
      onModalFocus,
      onModalDidDismiss,
      onModalWillDismiss,
      onModalAttemptDismiss,
      containerStyle,

      // C - View-Related Props
      children,
      viewProps,
    });
  };

  getEmitterRef = () => {
    return this.emitter;
  };

  setStateIsModalVisible = (nextModalVisibility: boolean) => {
    const { isModalVisible: prevModalVisibility } = this.state;

    const didModalVisibilityChange =
      prevModalVisibility !== nextModalVisibility;

    if (!didModalVisibilityChange) {
      return;
    }

    this.setState({
      isModalVisible: nextModalVisibility,
    });
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

  private _handleOnModalBlur: OnModalBlurEvent = (event) => {
    this.props.onModalBlur?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalBlur,
      event.nativeEvent
    );

    this.setState({
      isModalInFocus: false,
    });
  };

  private _handleOnModalFocus: OnModalFocusEvent = (event) => {
    this.props.onModalFocus?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalFocus,
      event.nativeEvent
    );

    this.setState({
      isModalInFocus: true,
    });
  };

  private _handleOnModalShow: OnModalShowEvent = (event) => {
    this.props.onModalShow?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalShow,
      event.nativeEvent
    );

    this.setStateIsModalVisible(true);
  };

  private _handleOnModalDismiss: OnModalDismissEvent = (event) => {
    const props = this.getProps();

    this.props.onModalDismiss?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalDismiss,
      event.nativeEvent
    );

    this.setState({
      isModalVisible: false,
      childProps: null,

      // reset state values from props
      enableSwipeGesture: props.enableSwipeGesture,
      isModalInPresentation: props.isModalInPresentation,
    });
  };

  private _handleOnModalDidDismiss: OnModalDidDismissEvent = (event) => {
    this.props.onModalDidDismiss?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalDidDismiss,
      event.nativeEvent
    );

    this.setStateIsModalVisible(false);
  };

  private _handleOnModalWillDismiss: OnModalDidDismissEvent = (event) => {
    this.props.onModalWillDismiss?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalWillDismiss,
      event.nativeEvent
    );
  };

  private _handleOnModalAttemptDismiss: OnModalAttemptDismissEvent = (event) => {
    this.props.onModalAttemptDismiss?.(event);
    event.stopPropagation();

    this.emitter.emit(
      ModalViewEmitterEvents.onModalAttemptDismiss,
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
        onModalBlur={this._handleOnModalBlur}
        onModalFocus={this._handleOnModalFocus}
        onModalShow={this._handleOnModalShow}
        onModalDismiss={this._handleOnModalDismiss}
        onModalDidDismiss={this._handleOnModalDidDismiss}
        onModalWillDismiss={this._handleOnModalWillDismiss}
        onModalAttemptDismiss={this._handleOnModalAttemptDismiss}
        {...overrideProps}
        {...viewProps}
      >
        {shouldMountModalContent && (
          <RNIWrapperView
            style={[styles.modalContentWrapper, props.containerStyle]}
            nativeID={NATIVE_ID_KEYS.modalViewContent}
            isDummyView={false}
            collapsable={false}
            shouldAutoDetachSubviews={false}
            shouldCreateTouchHandlerForSubviews={true}
            shouldNotifyComponentWillUnmount={props.shouldEnableAggressiveCleanup}
            shouldAutoCleanupOnJSUnmount={props.shouldEnableAggressiveCleanup}
            onLayout={this._handleOnLayoutModalContentContainer}
          >
            {React.cloneElement(props.children as any, {
              getModalRef: this._handleGetModalRef,
              // pass down props received from setVisibility
              ...(Helpers.isObject(state.childProps) && state.childProps),
              // pass down modalID
              modalID: props.modalID,
            })}
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
});
