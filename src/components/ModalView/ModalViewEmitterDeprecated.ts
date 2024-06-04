import type { LayoutChangeEvent } from 'react-native';
import type { TSEventEmitter } from '@dominicstop/ts-event-emitter';

import type {
  OnModalBlurEventObject,
  OnModalFocusEventObject,
  OnModalShowEventObject,
  OnModalDismissEventObject,
  OnModalAttemptDismissEventObject,
  DeprecatedOnModalWillDismissEventObject,
  DeprecatedOnModalDidDismissEventObject,
} from 'src/native_components/RNIModalView';

import type { KeyMapType } from '../../types/UtilityTypes';

/** @deprecated */
export enum ModalViewEmitterEventsDeprecated {
  // `RNIModalView` Events
  onModalBlur = 'onModalBlur',
  onModalFocus = 'onModalFocus',
  onModalShow = 'onModalShow',
  onModalDismiss = 'onModalDismiss',
  _onModalDidDismiss = '_onModalDidDismiss',
  _onModalWillDismiss = '_onModalWillDismiss',
  onModalAttemptDismiss = 'onModalAttemptDismiss',

  onLayoutModalContentContainer = 'onLayoutModalContentContainer',
}

// TODO: See TODO:20230-03-04-12-58-40 - Refactor: Types -
// Remove KeyMapType Usage
//
/** @deprecated */
export type ModalViewEmitterEventMapDeprecated =
  // prettier-ignore
  KeyMapType<ModalViewEmitterEventsDeprecated, {
    // `RNIModalView` Events
    onModalBlur: OnModalBlurEventObject['nativeEvent'];
    onModalFocus: OnModalFocusEventObject['nativeEvent'];
    onModalShow: OnModalShowEventObject['nativeEvent'];
    onModalDismiss: OnModalDismissEventObject['nativeEvent'];
    _onModalDidDismiss: DeprecatedOnModalWillDismissEventObject['nativeEvent'];
    _onModalWillDismiss: DeprecatedOnModalDidDismissEventObject['nativeEvent'];
    onModalAttemptDismiss: OnModalAttemptDismissEventObject['nativeEvent'];

    onLayoutModalContentContainer: LayoutChangeEvent['nativeEvent'];
  }
>;

/** @deprecated */
export type ModalViewEventEmitterDeprecated = TSEventEmitter<
  ModalViewEmitterEventsDeprecated,
  ModalViewEmitterEventMapDeprecated
>;
