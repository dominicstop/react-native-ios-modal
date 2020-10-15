import React from 'react';

import { ModalContext   } from '../context/ModalContext';
import { ModalEventKeys } from '../constants/Enums';


export function withModalLifecycle(WrappedComponent){
  return class extends React.PureComponent {
    static contextType = ModalContext;

    componentDidMount(){
      const modalContext = this.context;
      const modalEmitter = modalContext.getEmitterRef();

      modalEmitter.addListener(ModalEventKeys.onModalBlur          , this._handleOnModalBlur          );
      modalEmitter.addListener(ModalEventKeys.onModalFocus         , this._handleOnModalFocus         );
      modalEmitter.addListener(ModalEventKeys.onModalShow          , this._handleOnModalShow          );
      modalEmitter.addListener(ModalEventKeys.onModalDismiss       , this._handleOnModalDismiss       );
      modalEmitter.addListener(ModalEventKeys.onModalDidDismiss    , this._handleOnModalDidDismiss    );
      modalEmitter.addListener(ModalEventKeys.onModalWillDismiss   , this._handleOnModalWillDismiss   );
      modalEmitter.addListener(ModalEventKeys.onModalAttemptDismiss, this._handleOnModalAttemptDismiss);
    };

    componentWillUnmount(){
      const modalContext = this.context;
      const modalEmitter = modalContext.getEmitterRef();

      modalEmitter.removeListener(ModalEventKeys.onModalBlur          , this._handleOnModalBlur          );
      modalEmitter.removeListener(ModalEventKeys.onModalFocus         , this._handleOnModalFocus         );
      modalEmitter.removeListener(ModalEventKeys.onModalShow          , this._handleOnModalShow          );
      modalEmitter.removeListener(ModalEventKeys.onModalDismiss       , this._handleOnModalDismiss       );
      modalEmitter.removeListener(ModalEventKeys.onModalDidDismiss    , this._handleOnModalDidDismiss    );
      modalEmitter.removeListener(ModalEventKeys.onModalWillDismiss   , this._handleOnModalWillDismiss   );
      modalEmitter.removeListener(ModalEventKeys.onModalAttemptDismiss, this._handleOnModalAttemptDismiss);
    };

    //#region - Event Handlers
    _handleChildRef = (node) => {
      // store a copy of the child comp ref
      this.childRef = node;
      
      // pass down ref
      const { ref } = this.props.children;
      if (typeof ref === 'function') {
        ref(node);
        
      } else if (ref !== null) {
        ref.current = node;
      };
    };

    _handleOnModalBlur = (event) => {
      this.childRef?.onModalBlur?.(event);
    };

    _handleOnModalFocus = (event) => {
      this.childRef?.onModalFocus?.();
    };

    _handleOnModalShow = (event) => {
      this.childRef?.onModalShow?.(event);
    };

    _handleOnModalDismiss = (event) => {
      this.childRef?.onModalDismiss?.(event);
    };

    _handleOnModalDidDismiss = (event) => {
      this.childRef?.onModalDidDismiss?.(event);
    };

    _handleOnModalWillDismiss = (event) => {
      this.childRef?.onModalWillDismiss?.(event);
    };

    _handleOnModalAttemptDismiss = (event) => {
      this.childRef?.onModalAttemptDismiss?.(event);
    };
    //#endregion

    render(){
      const props = this.props;

      return (
        <WrappedComponent
          ref={r => this.childRef = r}
          {...props}
        />
      );
    };
  };
};