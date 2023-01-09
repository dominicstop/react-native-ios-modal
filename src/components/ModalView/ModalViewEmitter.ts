import type { LayoutChangeEvent } from 'react-native';
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
  // `RNIModalView` Events
  onModalBlur = 'onModalBlur',
  onModalFocus = 'onModalFocus',
  onModalShow = 'onModalShow',
  onModalDismiss = 'onModalDismiss',
  onModalDidDismiss = 'onModalDidDismiss',
  onModalWillDismiss = 'onModalWillDismiss',
  onModalAttemptDismiss = 'onModalAttemptDismiss',

  onLayoutModalContentContainer = 'onLayoutModalContentContainer',
}

// TODO: Remove `KeyMapType` usage
export type ModalViewEmitterEventMap =
  // prettier-ignore
  KeyMapType<ModalViewEmitterEvents, {
    // `RNIModalView` Events
    onModalBlur: OnModalBlurEventObject['nativeEvent'];
    onModalFocus: OnModalFocusEventObject['nativeEvent'];
    onModalShow: OnModalShowEventObject['nativeEvent'];
    onModalDismiss: OnModalDismissEventObject['nativeEvent'];
    onModalDidDismiss: OnModalDidDismissEventObject['nativeEvent'];
    onModalWillDismiss: OnModalWillDismissEventObject['nativeEvent'];
    onModalAttemptDismiss: OnModalAttemptDismissEventObject['nativeEvent'];

    onLayoutModalContentContainer: LayoutChangeEvent['nativeEvent'];
  }
>;

export type ModalViewEventEmitter = TSEventEmitter<
  ModalViewEmitterEvents,
  ModalViewEmitterEventMap
>;
