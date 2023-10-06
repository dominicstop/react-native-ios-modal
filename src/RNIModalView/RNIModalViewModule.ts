import { requireNativeModule } from 'expo-modules-core';

interface RNIModalViewModule {
  notifyComponentWillUnmount(
    reactTag: number,
    isManuallyTriggered: boolean
  ): void;
};

export const RNIModalViewModule: RNIModalViewModule = 
  requireNativeModule('RNIModalView');