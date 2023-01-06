import { NativeModules, NativeEventEmitter } from 'react-native';

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
