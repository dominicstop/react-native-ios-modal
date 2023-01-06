import { NativeModules, NativeEventEmitter } from 'react-native';
import * as Helpers from '../functions/helpers';

const MODULE_NAME = 'RNIModalViewModule';

interface RNIModalViewModule {
  dismissModalByID( //
    modalID: string,
    callback: (success: boolean) => void
  ): void;

  dismissAllModals( //
    animated: boolean,
    callback: (success: boolean) => void
  ): void;
}

export const RNIModalViewModule: RNIModalViewModule =
  NativeModules[MODULE_NAME];

export const RNIModalViewFocusEvents = //
  new NativeEventEmitter(RNIModalViewModule as any);

export class ModalViewModule {
  static dismissModalByID(modalID = ''){
    const promise = new Promise((resolve, reject) => {
      try {
        RNIModalViewModule.dismissModalByID(modalID, success => {
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
        RNIModalViewModule.dismissAllModals(animated, success => {
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
