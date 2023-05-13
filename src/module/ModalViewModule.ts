import { RNIModalViewModule } from '../native_modules/RNIModalViewModule';

export class ModalViewModule {
  static async setModalVisibilityByID(
    modalID: string,
    visibility: boolean,
    animated = true
  ) {
    await RNIModalViewModule.setModalVisibilityByID(
      modalID,
      visibility,
      animated
    );
  }

  static async dismissAllModals(animated = true) {
    await RNIModalViewModule.dismissAllModals(animated);
  }
}
