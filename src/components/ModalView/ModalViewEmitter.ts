import type { LayoutChangeEvent } from 'react-native';
import type { TSEventEmitter } from '@dominicstop/ts-event-emitter';

import type {
  OnModalWillPresentEventObject,
  OnModalDidPresentEventObject,
  OnModalWillDismissEventObject,
  OnModalDidDismissEventObject,
  OnModalWillShowEventObject,
  OnModalDidShowEventObject,
  OnModalWillHideEventObject,
  OnModalDidHideEventObject,
  OnModalWillFocusEventObject,
  OnModalDidFocusEventObject,
  OnModalWillBlurEventObject,
  OnModalDidBlurEventObject,
  OnPresentationControllerWillDismissEventObject,
  OnPresentationControllerDidDismissEventObject,
  OnPresentationControllerDidAttemptToDismissEventObject,
  OnModalDetentDidComputeEventObject,
  OnModalDidChangeSelectedDetentIdentifierEventObject,
} from 'src/native_components/RNIModalView';

import type { KeyMapType } from '../../types/UtilityTypes';

import type {
  ModalViewEmitterEventMapDeprecated,
  ModalViewEmitterEventsDeprecated,
} from './ModalViewEmitterDeprecated';

export enum ModalViewEmitterEvents {
  // `RNIModalView` Events
  onModalWillPresent = 'onModalWillPresent',
  onModalDidPresent = 'onModalDidPresent',
  onModalWillDismiss = 'onModalWillDismiss',
  onModalDidDismiss = 'onModalDidDismiss',
  onModalWillShow = 'onModalWillShow',
  onModalDidShow = 'onModalDidShow',
  onModalWillHide = 'onModalWillHide',
  onModalDidHide = 'onModalDidHide',
  onModalWillFocus = 'onModalWillFocus',
  onModalDidFocus = 'onModalDidFocus',
  onModalWillBlur = 'onModalWillBlur',
  onModalDidBlur = 'onModalDidBlur',
  onPresentationControllerWillDismiss = 'onPresentationControllerWillDismiss',
  onPresentationControllerDidDismiss = 'onPresentationControllerDidDismiss',
  onPresentationControllerDidAttemptToDismiss = 'onPresentationControllerDidAttemptToDismiss',
  onModalDetentDidCompute = 'onModalDetentDidCompute',
  onModalDidChangeSelectedDetentIdentifier = 'onModalDidChangeSelectedDetentIdentifier',

  onLayoutModalContentContainer = 'onLayoutModalContentContainer',
}

// TODO: See TODO:20230-03-04-12-58-40 - Refactor: Types -
// Remove KeyMapType Usage
//
export type ModalViewEmitterEventMap =
  // prettier-ignore
  KeyMapType<ModalViewEmitterEvents, {
    // `RNIModalView` Events
    onModalWillPresent: OnModalWillPresentEventObject['nativeEvent'];
    onModalDidPresent: OnModalDidPresentEventObject['nativeEvent'];
    onModalWillDismiss: OnModalWillDismissEventObject['nativeEvent'];
    onModalDidDismiss: OnModalDidDismissEventObject['nativeEvent'];
    onModalWillShow: OnModalWillShowEventObject['nativeEvent'];
    onModalDidShow: OnModalDidShowEventObject['nativeEvent'];
    onModalWillHide: OnModalWillHideEventObject['nativeEvent'];
    onModalDidHide: OnModalDidHideEventObject['nativeEvent'];
    onModalWillFocus: OnModalWillFocusEventObject['nativeEvent'];
    onModalDidFocus: OnModalDidFocusEventObject['nativeEvent'];
    onModalWillBlur: OnModalWillBlurEventObject['nativeEvent'];
    onModalDidBlur: OnModalDidBlurEventObject['nativeEvent'];
    onPresentationControllerWillDismiss: OnPresentationControllerWillDismissEventObject['nativeEvent'];
    onPresentationControllerDidDismiss: OnPresentationControllerDidDismissEventObject['nativeEvent'];
    onPresentationControllerDidAttemptToDismiss: OnPresentationControllerDidAttemptToDismissEventObject['nativeEvent'];
    onModalDetentDidCompute: OnModalDetentDidComputeEventObject['nativeEvent'];
    onModalDidChangeSelectedDetentIdentifier: OnModalDidChangeSelectedDetentIdentifierEventObject['nativeEvent'];

    onLayoutModalContentContainer: LayoutChangeEvent['nativeEvent'];
  }
>;

export type ModalViewEventEmitter = TSEventEmitter<
  ModalViewEmitterEvents & ModalViewEmitterEventsDeprecated,
  ModalViewEmitterEventMap & ModalViewEmitterEventMapDeprecated
>;
