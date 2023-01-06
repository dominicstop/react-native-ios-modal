import { NativeModules, NativeEventEmitter } from 'react-native';
import type { RNIModalViewInfo } from 'src/native_components/RNIModalView';

const MODULE_NAME = 'RNIModalViewModule';

interface RNIModalViewModule {
  // Standalone Functions
  // --------------------

  // prettier-ignore
  dismissModalByID(
    modalID: string,
    callback: (success: boolean) => void
  ): void;

  // prettier-ignore
  dismissAllModals(
    animated: boolean,
    callback: (success: boolean) => void
  ): void;

  // View-Related Functions
  // ----------------------

  // prettier-ignore
  setModalVisibility(
    node: number,
    visibility: boolean
  ): Promise<RNIModalViewInfo>;

  // prettier-ignore
  requestModalInfo(
    node: number,
  ): Promise<RNIModalViewInfo>;
}

export const RNIModalViewModule: RNIModalViewModule =
  NativeModules[MODULE_NAME];

// prettier-ignore
export const RNIModalViewFocusEvents =
  new NativeEventEmitter(RNIModalViewModule as any);
