import { RNIModalViewModule } from 'src/native_modules/RNIModalViewModule';
import * as Helpers from '../functions/helpers';

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
