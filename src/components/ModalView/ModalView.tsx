import React from 'react';

import {
  findNodeHandle,
  StyleSheet,
  View,
  ScrollView,
  Platform,
} from 'react-native';

import * as Helpers from '../../functions/helpers';

import { EventEmitter } from '../../functions/EventEmitter';
import { ModalEventKeys } from '../../constants/Enums';
import { ModalContext } from '../../context/ModalContext';

import { RNIModalView } from '../../native_components/RNIModalView';

import { RNIModalViewModule } from '../../native_modules/RNIModalViewModule';
import type { ModalViewProps, ModalViewState } from './ModalViewTypes';

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
  React.PureComponent<ModalViewProps, ModalViewState>  {

  constructor(props) {
    super(props);

    this.emitter = new EventEmitter();
    this._childRef = null;

    this.state = {
      visible: false,
      childProps: null,
      enableSwipeGesture: props.enableSwipeGesture,
      isModalInPresentation: props.isModalInPresentation,
    };
  }

  componentWillUnmount() {
    const { autoCloseOnUnmount } = this.props;
    const { visible } = this.state;

    if (autoCloseOnUnmount && visible) {
      this.setVisibility(false);
    }
  }

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
        findNodeHandle(this.nativeModalViewRef),
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
        findNodeHandle(this.nativeModalViewRef)
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

  _handleOnLayout = () => {
    const { didOnLayout } = this;
    didOnLayout && didOnLayout();
  };

  // the child comp can call `props.getModalRef` to receive
  // a ref to this modal comp
  _handleGetModalRef = () => {
    return this;
  };

  //#region - Native Event Handlers
  _handleOnRequestResult = ({ nativeEvent }) => {
    this.props.onRequestResult?.({ nativeEvent });
  };

  _handleOnModalBlur = (event) => {
    this.props.onModalBlur?.(event);
    this.emitter.emit(ModalEventKeys.onModalBlur, event);
  };

  _handleOnModalFocus = (event) => {
    this.props.onModalFocus?.(event);
    this.emitter.emit(ModalEventKeys.onModalFocus, event);
  };

  _handleOnModalShow = (event) => {
    this.props.onModalShow?.(event);
    this.emitter.emit(ModalEventKeys.onModalShow, event);
  };

  _handleOnModalDismiss = (event) => {
    this.props.onModalDismiss?.(event);
    this.emitter.emit(ModalEventKeys.onModalDismiss, event);

    this.setState({
      visible: false,
      childProps: null,
      // reset state values from props
      enableSwipeGesture: this.props.enableSwipeGesture,
      isModalInPresentation: this.props.isModalInPresentation,
    });
  };

  _handleOnModalDidDismiss = (event) => {
    this.props.onModalDidDismiss?.(event);
    this.emitter.emit(ModalEventKeys.onModalDidDismiss, event);
  };

  _handleOnModalWillDismiss = (event) => {
    this.props.onModalWillDismiss?.(event);
    this.emitter.emit(ModalEventKeys.onModalWillDismiss, event);
  };

  _handleOnModalAttemptDismiss = (event) => {
    this.props.onModalAttemptDismiss?.(event);
    this.emitter.emit(ModalEventKeys.onModalAttemptDismiss, event);
  };
  //#endregion

  _renderModal() {
    const props = this.props;
    const state = this.state;

    const nativeProps = {
      // pass down props
      ...props,
      // set handlers for native props -------------------------------------------
      [NATIVE_PROP_KEYS.onModalBlur]: this._handleOnModalBlur,
      [NATIVE_PROP_KEYS.onModalFocus]: this._handleOnModalFocus,
      [NATIVE_PROP_KEYS.onModalShow]: this._handleOnModalShow,
      [NATIVE_PROP_KEYS.onModalDismiss]: this._handleOnModalDismiss,
      [NATIVE_PROP_KEYS.onRequestResult]: this._handleOnRequestResult,
      [NATIVE_PROP_KEYS.onModalDidDismiss]: this._handleOnModalDidDismiss,
      [NATIVE_PROP_KEYS.onModalWillDismiss]: this._handleOnModalWillDismiss,
      [NATIVE_PROP_KEYS.onModalAttemptDismiss]:
        this._handleOnModalAttemptDismiss,
      // optional props ----------------------------
      ...(props.setModalInPresentationFromProps && {
        [NATIVE_PROP_KEYS.isModalInPresentation]: state.isModalInPresentation,
      }),
      ...(props.setEnableSwipeGestureFromProps && {
        [NATIVE_PROP_KEYS.enableSwipeGesture]: state.enableSwipeGesture,
      }),
    };

    return (
      <RNIModalView
        ref={(r) => {
          this.nativeModalViewRef = r;
        }}
        style={styles.rootContainer}
        onStartShouldSetResponder={this._shouldSetResponder}
        {...nativeProps}
      >
        {state.visible && (
          <View
            ref={(r) => (this.modalContainerRef = r)}
            style={[styles.modalContainer, props.containerStyle]}
            collapsable={false}
            onLayout={this._handleOnLayout}
          >
            {React.cloneElement(props.children, {
              getModalRef: this._handleGetModalRef,
              // pass down props received from setVisibility
              ...(Helpers.isObject(state.childProps) && state.childProps),
              // pass down modalID
              modalID: props[NATIVE_PROP_KEYS.modalID],
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
