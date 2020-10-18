import React from 'react';

import { ModalContext   } from '../context/ModalContext';
import { ModalEventKeys } from '../constants/Enums';


const eventKeys = Object.keys(ModalEventKeys);

export function withModalLifecycle(WrappedComponent){
  return class extends React.PureComponent {
    static contextType = ModalContext;

    componentDidMount(){
      const modalContext = this.context;
      const modalEmitter = modalContext.getEmitterRef();

      for (const eventKey of eventKeys) {
        const functionName = `handle-${eventKey}`;
        
        this[functionName] = (event) => {
          this.childRef?.onModalShow?.(event);
        };

        modalEmitter.addListener(eventKey, this[functionName]);
      };
    };

    componentWillUnmount(){
      const modalContext = this.context;
      const modalEmitter = modalContext.getEmitterRef();

      for (const eventKey of eventKeys) {
        const functionName = `handle-${eventKey}`;
        modalEmitter.removeListener(eventKey, this[functionName]);
      };
    };

    _handleChildRef = (node) => {
      const { ref } = this.props;
      
      // store a copy of the child comp ref
      this.childRef = node;
      
      if (typeof ref === 'function') {
        ref(node);
        
      } else if (ref) {
        ref.current = node;
      };
    };

    render(){
      const props = this.props;

      return (
        <WrappedComponent
          {...props}
          ref={this._handleChildRef}
        />
      );
    };
  };
};