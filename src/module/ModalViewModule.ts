import { RNIModalViewModule } from '../native_modules/RNIModalViewModule';

export class ModalViewModule {
  static async setModalVisibilityByID(modalID: string) {
    await RNIModalViewModule.setModalVisibilityByID(modalID);
  }

  static async dismissAllModals(animated = true) {
    await RNIModalViewModule.dismissAllModals(animated);
  }
}
