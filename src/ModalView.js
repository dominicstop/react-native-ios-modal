import React from 'react';
import Proptypes from 'prop-types';
import { requireNativeComponent, UIManager, findNodeHandle, StyleSheet, View, ScrollView } from 'react-native';

import * as Helpers from './functions/helpers';
import { RequestFactory } from './functions/RequestFactory';

const componentName   = "RCTModalView";
const NativeCommands  = UIManager[componentName]?.Commands;
const NativeConstants = UIManager[componentName]?.Constants;
const NativeModalView = requireNativeComponent(componentName);

export const AvailableBlurEffectStyles   = NativeConstants?.availableBlurEffectStyles;
export const AvailablePresentationStyles = NativeConstants?.availablePresentationStyles;


const NATIVE_PROP_KEYS = {
  // Modal Native Props: Event Callbacks
  onRequestResult      : 'onRequestResult'      ,
  onModalBlur          : 'onModalBlur'          ,
  onModalFocus         : 'onModalFocus'         ,
  onModalShow          : 'onModalShow'          ,
  onModalDismiss       : 'onModalDismiss'       ,
  onModalDidDismiss    : 'onModalDidDismiss'    ,
  onModalWillDismiss   : 'onModalWillDismiss'   ,
  onModalAttemptDismiss: 'onModalAttemptDismiss',

  // Modal Native Props: Flags/Booleans
  presentViaMount      : 'presentViaMount'      ,
  isModalBGBlurred     : 'isModalBGBlurred'     ,
  enableSwipeGesture   : 'enableSwipeGesture'   ,
  hideNonVisibleModals : 'hideNonVisibleModals' ,
  isModalBGTransparent : 'isModalBGTransparent' ,
  isModalInPresentation: 'isModalInPresentation',

  // Modal Native Props: Strings
  modalID               : 'modalID'               ,
  modalTransitionStyle  : 'modalTransitionStyle'  ,
  modalPresentationStyle: 'modalPresentationStyle',
  modalBGBlurEffectStyle: 'modalBGBlurEffectStyle',
};

const COMMAND_KEYS = {
  requestModalPresentation: 'requestModalPresentation'
};



const VirtualizedListContext = React.createContext(null);

export class ModalView extends React.PureComponent {
  static proptypes = {
    // Props: Events ---------------------
    onRequestResult      : Proptypes.func,
    onModalShow          : Proptypes.func,
    onModalDismiss       : Proptypes.func,
    onModalDidDismiss    : Proptypes.func,
    onModalWillDismiss   : Proptypes.func,
    onModalAttemptDismiss: Proptypes.func,
    // Props: Bool/Flags --------------------------
    presentViaMount                : Proptypes.bool,
    isModalBGBlurred               : Proptypes.bool,
    enableSwipeGesture             : Proptypes.bool,
    hideNonVisibleModals           : Proptypes.bool,
    isModalBGTransparent           : Proptypes.bool,
    isModalInPresentation          : Proptypes.bool,
    setEnableSwipeGestureFromProps : Proptypes.bool,
    setModalInPresentationFromProps: Proptypes.bool,
    // Props: String ------------------------
    modalID               : Proptypes.string,
    modalTransitionStyle  : Proptypes.string,
    modalPresentationStyle: Proptypes.string,
    modalBGBlurEffectStyle: Proptypes.string,
  };

  static defaultProps = {
    enableSwipeGesture   : true ,
    isModalInPresentation: false,
    setEnableSwipeGestureFromProps: false,
    setModalInPresentationFromProps: false,
  };

  constructor(props){
    super(props);

    RequestFactory.initialize(this);
    this._childRef = null;

    this.state = {
      visible   : false,
      childProps: null ,
      enableSwipeGesture   : props.enableSwipeGesture   ,
      isModalInPresentation: props.isModalInPresentation,
    };
  };

  setVisibility = async (nextVisible, childProps = null) => {
    const { visible: prevVisible } = this.state;

    const didChange = (prevVisible != nextVisible);
    if (!didChange) return false;

    const { promise, requestID } = 
      RequestFactory.newRequest(this, { timeout: 2000 });

    try {
      if(nextVisible) {
        // when showing modal, mount children first,
        await Helpers.setStateAsync(this, {
          visible: nextVisible, 
          // pass down received props to childProps via state
          childProps: (Helpers.isObject(childProps)
            ? childProps
            : null
          ),
        });

        // wait for view to mount
        await new Promise((resolve) => {
          this.didOnLayout = resolve;
        });

        // reset didOnLayout
        this.didOnLayout = null;
      };

      // request modal to open/close
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(this.nativeModalViewRef),
        NativeCommands[COMMAND_KEYS.requestModalPresentation],
        [requestID, nextVisible]
      );

      const result = await promise;

      // when finish hiding modal, unmount children
      if(!nextVisible) await Helpers.setStateAsync(this, {
        visible   : nextVisible,
        childProps: null
      });

      return result.success;

    } catch(error){
      RequestFactory.rejectRequest(this, {requestID});
      console.log("ModalView, setVisibility failed:");
      console.log(error);

      return false;
    };
  };

  setEnableSwipeGesture = async (enableSwipeGesture) => {
    const { enableSwipeGesture: prevVal } = this.state;
    if(prevVal != enableSwipeGesture){
      await Helpers.setStateAsync(this, 
        { enableSwipeGesture }
      );
    };
  };

  setIsModalInPresentation = async (isModalInPresentation) => {
    const { isModalInPresentation: prevVal } = this.state;
    if(prevVal != isModalInPresentation){
      await Helpers.setStateAsync(this, 
        { isModalInPresentation }
      );
    };
  };

  // We don't want any responder events bubbling out of the modal.
  _shouldSetResponder() {
    return true;
  };

  _handleOnLayout = () => {
    const { didOnLayout } = this;
    didOnLayout && didOnLayout();
  };
  
  _handleChildRef = (node) => {
    // store a copy of the child comp ref
    this._childRef = node;
    
    // pass down ref
    const { ref } = this.props.children;
    if (typeof ref === 'function') {
      ref(node);
      
    } else if (ref !== null) {
      ref.current = node;
    };
  };

  // the child comp can call `props.getModalRef` to receive
  // a ref to this modal comp
  _handleChildGetRef = () => {
    return this;
  };

  //#region - Native Event Handlers

  _handleOnRequestResult = ({nativeEvent}) => {
    RequestFactory.resolveRequestFromObj(this, nativeEvent);
    this.props     .onRequestResult?.(nativeEvent);
    this._childRef?.onRequestResult?.(nativeEvent);
  };

  _handleOnModalBlur = () => {
    this.props     .onModalBlur?.();
    this._childRef?.onModalBlur?.();
  };

  _handleOnModalFocus = () => {
    this.props     .onModalFocus?.();
    this._childRef?.onModalFocus?.();
  };

  _handleOnModalShow = () => {
    this.props     .onModalShow?.();
    this._childRef?.onModalShow?.();
  };

  _handleOnModalDismiss = () => {
    this.props     .onModalDismiss?.();
    this._childRef?.onModalDismiss?.();

    this.setState({ 
      visible   : false,
      childProps: null ,
      // reset state values from props
      enableSwipeGesture   : this.props.enableSwipeGesture,
      isModalInPresentation: this.props.isModalInPresentation
    });
  };

  _handleOnModalDidDismiss = () => {
    this.props     .onModalDidDismiss?.();
    this._childRef?.onModalDidDismiss?.();
  };

  _handleOnModalWillDismiss = () => {
    this.props     .onModalWillDismiss?.();
    this._childRef?.onModalWillDismiss?.();
  };

  _handleOnModalAttemptDismiss = () => {
    this.props     .onModalAttemptDismiss?.();
    this._childRef?.onModalAttemptDismiss?.();
  };

  //#endregion

  render(){
    const props = this.props;
    const state = this.state;

    const nativeProps = {
      [NATIVE_PROP_KEYS.onModalBlur          ]: this._handleOnModalBlur          ,
      [NATIVE_PROP_KEYS.onModalFocus         ]: this._handleOnModalFocus         ,
      [NATIVE_PROP_KEYS.onModalShow          ]: this._handleOnModalShow          ,
      [NATIVE_PROP_KEYS.onModalDismiss       ]: this._handleOnModalDismiss       ,
      [NATIVE_PROP_KEYS.onRequestResult      ]: this._handleOnRequestResult      ,
      [NATIVE_PROP_KEYS.onModalDidDismiss    ]: this._handleOnModalDidDismiss    ,
      [NATIVE_PROP_KEYS.onModalWillDismiss   ]: this._handleOnModalWillDismiss   ,
      [NATIVE_PROP_KEYS.onModalAttemptDismiss]: this._handleOnModalAttemptDismiss,
      // pass down props
      ...props, ...nativeProps,
      ...(props.setModalInPresentationFromProps && {
        [NATIVE_PROP_KEYS.isModalInPresentation]: state.isModalInPresentation
      }),
      ...(props.setEnableSwipeGestureFromProps && {
        [NATIVE_PROP_KEYS.enableSwipeGesture]: state.enableSwipeGesture
      })
    };

    return(
      <NativeModalView
        ref={r => this.nativeModalViewRef = r}
        style={styles.rootContainer}
        onStartShouldSetResponder={this._shouldSetResponder}
        {...nativeProps}
      >
        <VirtualizedListContext.Provider value={null}>
          <ScrollView.Context.Provider value={null}>
            {state.visible && (
              <View 
                ref={r => this.modalContainerRef = r}
                style={[styles.modalContainer, props.containerStyle]}
                collapsable={false}
                onLayout={this._handleOnLayout}
              >
                {React.cloneElement(this.props.children, {
                  ref        : this._handleChildRef   ,
                  getModalRef: this._handleChildGetRef,
                  // pass down props received from setVisibility
                  ...(Helpers.isObject(state.childProps) && state.childProps),
                  // pass down modalID
                  modalID: props[NATIVE_PROP_KEYS.modalID]
                })}
              </View>
            )}
          </ScrollView.Context.Provider>
        </VirtualizedListContext.Provider>
      </NativeModalView>
    );
  };
};

const styles = StyleSheet.create({
  rootContainer: {
    position: 'absolute',
  },
  modalContainer: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
  },
});