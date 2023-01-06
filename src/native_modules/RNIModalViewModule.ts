import { NativeModules, NativeEventEmitter } from 'react-native';

const MODULE_NAME = 'RNIModalViewModule';

interface RNIModalViewModule {
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
}

export const RNIModalViewModule: RNIModalViewModule =
  NativeModules[MODULE_NAME];

// prettier-ignore
export const RNIModalViewFocusEvents =
  new NativeEventEmitter(RNIModalViewModule as any);
