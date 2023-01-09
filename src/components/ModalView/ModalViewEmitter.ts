import type { TSEventEmitter } from '@dominicstop/ts-event-emitter';

import type {
  OnModalBlurEventObject,
  OnModalFocusEventObject,
  OnModalShowEventObject,
  OnModalDismissEventObject,
  OnModalDidDismissEventObject,
  OnModalWillDismissEventObject,
  OnModalAttemptDismissEventObject,
} from 'src/native_components/RNIModalView';

import type { KeyMapType } from '../../types/UtilityTypes';

export enum ModalViewEmitterEvents {
  onModalBlur = 'onModalBlur',
  onModalFocus = 'onModalFocus',
  onModalShow = 'onModalShow',
  onModalDismiss = 'onModalDismiss',
  onModalDidDismiss = 'onModalDidDismiss',
  onModalWillDismiss = 'onModalWillDismiss',
  onModalAttemptDismiss = 'onModalAttemptDismiss',
}

export type ModalViewEmitterEventMap =
  // prettier-ignore
  KeyMapType<ModalViewEmitterEvents, {
    onModalBlur: OnModalBlurEventObject['nativeEvent'];
    onModalFocus: OnModalFocusEventObject['nativeEvent'];
    onModalShow: OnModalShowEventObject['nativeEvent'];
    onModalDismiss: OnModalDismissEventObject['nativeEvent'];
    onModalDidDismiss: OnModalDidDismissEventObject['nativeEvent'];
    onModalWillDismiss: OnModalWillDismissEventObject['nativeEvent'];
    onModalAttemptDismiss: OnModalAttemptDismissEventObject['nativeEvent'];
  }
>;

export type ModalViewEventEmitter = TSEventEmitter<
  ModalViewEmitterEvents,
  ModalViewEmitterEventMap
>;
