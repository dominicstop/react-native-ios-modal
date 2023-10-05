import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ReactNativeIosModal.web.ts
// and on native platforms to ReactNativeIosModal.ts
import ReactNativeIosModalModule from './ReactNativeIosModalModule';
import ReactNativeIosModalView from './ReactNativeIosModalView';
import { ChangeEventPayload, ReactNativeIosModalViewProps } from './ReactNativeIosModal.types';

// Get the native constant value.
export const PI = ReactNativeIosModalModule.PI;

export function hello(): string {
  return ReactNativeIosModalModule.hello();
}

export async function setValueAsync(value: string) {
  return await ReactNativeIosModalModule.setValueAsync(value);
}

const emitter = new EventEmitter(ReactNativeIosModalModule ?? NativeModulesProxy.ReactNativeIosModal);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { ReactNativeIosModalView, ReactNativeIosModalViewProps, ChangeEventPayload };
