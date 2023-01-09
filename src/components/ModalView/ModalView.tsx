import React from 'react';

import {
  findNodeHandle,
  StyleSheet,
  View,
  ScrollView,
  Platform,
  ViewProps,
} from 'react-native';

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
  OnRequestResultEvent,
  RNIModalView,
} from '../../native_components/RNIModalView';

import { RNIModalViewModule } from '../../native_modules/RNIModalViewModule';

import type { ModalViewProps, ModalViewState } from './ModalViewTypes';

import {
  ModalViewEmitterEvents,
  ModalViewEventEmitter,
} from './ModalViewEmitter';

//
//

const NATIVE_PROP_KEYS = {
  // Modal Native Props: Event Callbacks
  onRequestResult: 'onRequestResult',
  onModalBlur: 'onModalBlur',
  onModalFocus: 'onModalFocus',
  onModalShow: 'onModalShow',
  onModalDismiss: 'onModalDismiss',
  onModalDidDismiss: 'onModalDidDismiss',
  onModalWillDismiss: 'onModalWillDismiss',
  onModalAttemptDismiss: 'onModalAttemptDismiss',

  // Modal Native Props: Flags/Booleans
  presentViaMount: 'presentViaMount',
  isModalBGBlurred: 'isModalBGBlurred',
  enableSwipeGesture: 'enableSwipeGesture',
  hideNonVisibleModals: 'hideNonVisibleModals',
  isModalBGTransparent: 'isModalBGTransparent',
  isModalInPresentation: 'isModalInPresentation',

  // Modal Native Props: Strings
  modalID: 'modalID',
  modalTransitionStyle: 'modalTransitionStyle',
  modalPresentationStyle: 'modalPresentationStyle',
  modalBGBlurEffectStyle: 'modalBGBlurEffectStyle',
};

const VirtualizedListContext = React.createContext(null);

// fix for react-native 0.60
const hasScrollViewContext: boolean =
  (ScrollView as any).Context?.Provider != null;

//
//

// prettier-ignore
export class ModalView extends
  React.PureComponent<ModalViewProps, ModalViewState> {

  private nativeRefModalView!: React.Component;
  private emitter: ModalViewEventEmitter;


  constructor(props) {
    super(props);

    this.emitter = new TSEventEmitter();

    this.state = {
      visible: false,
      childProps: null,
      enableSwipeGesture: props.enableSwipeGesture,
      isModalInPresentation: props.isModalInPresentation,
    };
  }

  componentWillUnmount() {
    const { autoCloseOnUnmount } = this.getProps();
    const { visible } = this.state;

    if (autoCloseOnUnmount && visible) {
      this.setVisibility(false);
    }
  }

  getProps = () => {
    const {
      // native props - flags
      presentViaMount,
      isModalBGBlurred,
      enableSwipeGesture,
      hideNonVisibleModals,
      isModalBGTransparent,
      isModalInPresentation,
      allowModalForceDismiss,

      // native props - string
      modalID,
      modalTransitionStyle,
      modalBGBlurEffectStyle,
      modalPresentationStyle,

      // native props - events
      onModalShow,
      onModalDismiss,
      onRequestResult,
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

      children,
      ...viewProps
    } = this.props;

    return ({
      // A - Add Default Values
      presentViaMount: (
        presentViaMount ?? false
      ),
      isModalBGBlurred: (
        isModalBGBlurred ?? false
      ),
      enableSwipeGesture: (
        enableSwipeGesture ?? true
      ),
      hideNonVisibleModals: (
        hideNonVisibleModals ?? false
      ),
      isModalBGTransparent: (
        isModalBGTransparent ?? false
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

      // B - Pass down...
      modalID,
      isModalInPresentation,
      allowModalForceDismiss,
      modalBGBlurEffectStyle,
      onModalShow,
      onModalDismiss,
      onRequestResult,
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

  setVisibility = async (nextVisible, childProps = null) => {
    const { visible: prevVisible } = this.state;

    const didChange = prevVisible != nextVisible;

    if (!didChange) {
      return false;
    }

    if (nextVisible) {
      // when showing modal, mount children first,
      await Helpers.setStateAsync(this, {
        visible: nextVisible,
        // pass down received props to childProps via state
        childProps: Helpers.isObject(childProps) ? childProps : null,
      });

      // TODO: Use `Promise.all`
      // wait for view to mount
      await new Promise((resolve) => {
        this.didOnLayout = resolve;
      });

      // TODO: Use await event emitter
      // reset didOnLayout
      this.didOnLayout = null;
    }

    try {
      // request modal to open/close
      await RNIModalViewModule.setModalVisibility(
        findNodeHandle(this.nativeRefModalView),
        nextVisible
      );

      // when finish hiding modal, unmount children
      if (!nextVisible) {
        await Helpers.setStateAsync(this, {
          visible: nextVisible,
          childProps: null,
        });
      }
    } catch (error) {
      console.log('ModalView, setVisibility failed:');
      console.log(error);
    }
  };

  getModalInfo = async () => {
    try {
      // request modal to send modal info
      return await RNIModalViewModule.requestModalInfo(
        findNodeHandle(this.nativeRefModalView)
      );
    } catch (error) {
      console.log('ModalView, requestModalInfo failed:');
      console.log(error);
    }
  };

  setEnableSwipeGesture = async (enableSwipeGesture) => {
    const { enableSwipeGesture: prevVal } = this.state;
    if (prevVal != enableSwipeGesture) {
      await Helpers.setStateAsync(this, { enableSwipeGesture });
    }
  };

  setIsModalInPresentation = async (isModalInPresentation) => {
    const { isModalInPresentation: prevVal } = this.state;
    if (prevVal != isModalInPresentation) {
      await Helpers.setStateAsync(this, { isModalInPresentation });
    }
  };

  // We don't want any responder events bubbling out of the modal.
  _shouldSetResponder() {
    return true;
  }

  _handleOnLayout: ViewProps['onLayout'] = () => {
    const { didOnLayout } = this;
    didOnLayout && didOnLayout();
  };

  // the child comp can call `props.getModalRef` to receive
  // a ref to this modal comp
  _handleGetModalRef = () => {
    return this;
  };

  // Native Event Handlers
  // ---------------------

  _handleOnRequestResult: OnRequestResultEvent = ({ nativeEvent }) => {
    this.props.onRequestResult?.({ nativeEvent });
  };

  _handleOnModalBlur: OnModalBlurEvent = (event) => {
    this.props.onModalBlur?.(event);

    this.emitter.emit(
      ModalViewEmitterEvents.onModalBlur,
      event.nativeEvent
    );
  };

  _handleOnModalFocus: OnModalFocusEvent = (event) => {
    this.props.onModalFocus?.(event);

    this.emitter.emit(
      ModalViewEmitterEvents.onModalFocus,
      event.nativeEvent
    );
  };

  _handleOnModalShow: OnModalShowEvent = (event) => {
    this.props.onModalShow?.(event);
    this.emitter.emit(
      ModalViewEmitterEvents.onModalShow,
      event.nativeEvent
    );
  };

  _handleOnModalDismiss: OnModalDismissEvent = (event) => {
    const props = this.getProps();

    this.props.onModalDismiss?.(event);
    this.emitter.emit(
      ModalViewEmitterEvents.onModalDismiss,
      event.nativeEvent
    );

    this.setState({
      visible: false,
      childProps: null,
      // reset state values from props
      enableSwipeGesture: props.enableSwipeGesture,
      isModalInPresentation: props.isModalInPresentation,
    });
  };

  _handleOnModalDidDismiss: OnModalDidDismissEvent = (event) => {
    this.props.onModalDidDismiss?.(event);

    this.emitter.emit(
      ModalViewEmitterEvents.onModalDidDismiss,
      event.nativeEvent
    );
  };

  _handleOnModalWillDismiss: OnModalDidDismissEvent = (event) => {
    this.props.onModalWillDismiss?.(event);

    this.emitter.emit(
      ModalViewEmitterEvents.onModalWillDismiss,
      event.nativeEvent
    );
  };

  _handleOnModalAttemptDismiss: OnModalAttemptDismissEvent = (event) => {
    this.props.onModalAttemptDismiss?.(event);

    this.emitter.emit(
      ModalViewEmitterEvents.onModalAttemptDismiss,
      event.nativeEvent
    );
  };

  _renderModal() {
    const props = this.getProps();
    const state = this.state;

    const overrideProps = {
      ...(props.setModalInPresentationFromProps && {
        isModalInPresentation: state.isModalInPresentation,
      }),

      ...(props.setEnableSwipeGestureFromProps && {
        enableSwipeGesture: state.enableSwipeGesture,
      }),
    };

    return (
      <RNIModalView
        ref={(r) => {
          this.nativeRefModalView = r;
        }}
        style={styles.rootContainer}
        onStartShouldSetResponder={this._shouldSetResponder}
        onModalBlur={this._handleOnModalBlur}
        onModalFocus={this._handleOnModalFocus}
        onModalShow={this._handleOnModalShow}
        onModalDismiss={this._handleOnModalDismiss}
        onRequestResult={this._handleOnRequestResult}
        onModalDidDismiss={this._handleOnModalDidDismiss}
        onModalWillDismiss={this._handleOnModalWillDismiss}
        onModalAttemptDismiss={this._handleOnModalAttemptDismiss}
        {...props}
        {...overrideProps}
        {...props.viewProps}
      >
        {state.visible && (
          <View
            style={[styles.modalContainer, props.containerStyle]}
            collapsable={false}
            onLayout={this._handleOnLayout}
          >
            {React.cloneElement(props.children as any, {
              getModalRef: this._handleGetModalRef,
              // pass down props received from setVisibility
              ...(Helpers.isObject(state.childProps) && state.childProps),
              // pass down modalID
              modalID: props.modalID,
            })}
          </View>
        )}
      </RNIModalView>
    );
  }

  render() {
    if (Platform.OS !== 'ios') {
      return null;
    }

    return (
      <ModalContext.Provider
        value={{
          // pass down function to get modal refs
          getModalRef: this._handleGetModalRef,
          getEmitterRef: this.getEmitterRef,
          // pass ref to modal functions -------------------------
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
  rootContainer: {
    position: 'absolute',
    width: 0,
    height: 0,
    overflow: 'hidden',
  },
  modalContainer: {
    position: 'absolute',
  },
});