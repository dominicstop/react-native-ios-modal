import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

import type { BubblingEventHandler, Int32 } from 'react-native/Libraries/Types/CodegenTypes';
import type { HostComponent, ViewProps } from 'react-native';

// stubs
export interface NativeProps extends ViewProps {
  // props
  reactChildrenCount: Int32;

  /** 
   * From `UIAdaptivePresentationControllerDelegate`.
   * Value from prop returned to: `presentationControllerShouldDismiss`.
   * 
   * * return false to prevent dismissal of the view controller via gesture
   * */
  shouldAllowDismissalViaGesture?: boolean;

  // common/shared events
  onDidSetViewID?: BubblingEventHandler<{}>;

  // common modal events
  onModalWillPresent?: BubblingEventHandler<{}>;
  onModalDidPresent?: BubblingEventHandler<{}>;

  onModalWillDismiss: BubblingEventHandler<{}>;
  onModalDidDismiss: BubblingEventHandler<{}>;

  onModalWillShow?: BubblingEventHandler<{}>;
  onModalDidShow?: BubblingEventHandler<{}>;

  onModalWillHide?: BubblingEventHandler<{}>;
  onModalDidHide?: BubblingEventHandler<{}>;

  onModalFocusChange?: BubblingEventHandler<{}>;

  // presentation controller delegate events
  /** 
   * From `UIAdaptivePresentationControllerDelegate`.
   * Event invoked by: `presentationControllerWillDismiss`.
   * 
   * * Invoked when sheet dismissal via gesture started
   * * Note: This is not called if the presentation is dismissed programatically.
   * */
  onModalSheetWillDismissViaGesture?: BubblingEventHandler<{}>;

  /** 
   * From `UIAdaptivePresentationControllerDelegate`.
   * Event invoked by: `presentationControllerDidDismiss`.
   * 
   * * Invoked after sheet dismissal via gesture finished (after animations)
   * * Note: This is not called if the presentation is dismissed programatically.
   * */
  onModalSheetDidDismissViaGesture?: BubblingEventHandler<{}>;

  /** 
   * From `UIAdaptivePresentationControllerDelegate`.
   * Event invoked by: `presentationControllerDidAttemptToDismiss`.
   * 
   * * Invoked after sheet dismissal via gesture was prevented
   * */
  onModalSheetDidAttemptToDismissViaGesture?: BubblingEventHandler<{}>;

  // sheet events
  onModalSheetStateWillChange?: BubblingEventHandler<{}>;
  onModalSheetStateDidChange?: BubblingEventHandler<{}>;
};

// stubs
export default codegenNativeComponent<NativeProps>('RNIModalSheetView', {
  excludedPlatforms: ['android'],
  interfaceOnly: true,
}) as HostComponent<NativeProps>;