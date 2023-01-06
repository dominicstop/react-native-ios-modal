import { NativeModules, NativeEventEmitter } from 'react-native';
import * as Helpers from '../functions/helpers';

const moduleName   = "RNIModalViewModule";
const NativeModule = NativeModules[moduleName];

const COMMAND_KEYS = {
  dismissModalByID: 'dismissModalByID',
  dismissAllModals: 'dismissAllModals'
};

// wip
const ModalViewFocusEvents = new NativeEventEmitter(NativeModule);

export class RNIModalViewModule {
  static dismissModalByID(modalID = ''){
    const promise = new Promise((resolve, reject) => {
      try {
        NativeModule[COMMAND_KEYS.dismissModalByID](modalID, success => {
          (success? resolve : reject)();
        });

      } catch(error){
        console.log("RNIModalViewModule, dismissModalByID error:");
        console.log(error);
        reject(error);
      };
    });

    return Helpers.promiseWithTimeout(1000, promise);
  };

  static dismissAllModals(animated = true){
    const promise = new Promise((resolve, reject) => {
      try {
        NativeModule[COMMAND_KEYS.dismissAllModals](animated, success => {
          (success? resolve : reject)();
        });

      } catch(error){
        console.log("RNIModalViewModule, dismissAllModals error:");
        console.log(error);
        reject();
      };
    });

    return Helpers.promiseWithTimeout(1000, promise);
  };
};