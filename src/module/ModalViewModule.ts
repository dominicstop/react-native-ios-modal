import { RNIModalViewModule } from '../native_modules/RNIModalViewModule';

export class ModalViewModule {
  static async setModalVisibilityByID(modalID: string, visibility: boolean) {
    await RNIModalViewModule.setModalVisibilityByID(modalID, visibility);
  }

  static async dismissAllModals(animated = true) {
    await RNIModalViewModule.dismissAllModals(animated);
  }
}
