import { NativeModules, NativeEventEmitter } from 'react-native';
import type { RNIModalBaseEventData } from 'src/native_components/RNIModalView';

const MODULE_NAME = 'RNIModalViewModule';

interface RNIModalViewModule {
  // Standalone Functions
  // --------------------

  // prettier-ignore
  setModalVisibilityByID(
    modalID: string,
    visibility: boolean,
  ): Promise<void>;

  // prettier-ignore
  dismissAllModals(
    animated: boolean,
  ): Promise<void>;

  // View-Related Functions
  // ----------------------

  // prettier-ignore
  setModalVisibility(
    node: number,
    visibility: boolean
  ): Promise<RNIModalBaseEventData>;

  // prettier-ignore
  requestModalInfo(
    node: number,
  ): Promise<RNIModalBaseEventData>;
}

export const RNIModalViewModule: RNIModalViewModule =
  NativeModules[MODULE_NAME];

// prettier-ignore
export const RNIModalViewFocusEvents =
  new NativeEventEmitter(RNIModalViewModule as any);
