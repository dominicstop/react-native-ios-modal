import { RNIModalViewModule } from '../native_modules/RNIModalViewModule';
import * as Helpers from '../functions/helpers';

export class ModalViewModule {
  static async setModalVisibilityByID(modalID: string) {
    await RNIModalViewModule.setModalVisibilityByID(modalID);
  }

  static dismissAllModals(animated = true) {
    const promise = new Promise((resolve, reject) => {
      try {
        RNIModalViewModule.dismissAllModals(animated, (success) => {
          (success ? resolve : reject)();
        });

        // prettier-ignore
      } catch (error) {
        console.log('RNIModalViewModule, dismissAllModals error:');
        console.log(error);
        reject();
      }
    });

    return Helpers.promiseWithTimeout(1000, promise);
  }
}
