import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

import type { BubblingEventHandler, Int32 } from 'react-native/Libraries/Types/CodegenTypes';
import type { HostComponent, ViewProps } from 'react-native';

// stubs
export interface NativeProps extends ViewProps {
  // props
  shouldAllowDismissalViaGesture?: boolean;
  // common/shared events
  onDidSetViewID?: BubblingEventHandler<{}>;

  onModalWillPresent?: BubblingEventHandler<{}>;
  onModalDidPresent?: BubblingEventHandler<{}>;

  onModalWillDismiss: BubblingEventHandler<{}>;
  onModalDidDismiss: BubblingEventHandler<{}>;

  onModalWillShow?: BubblingEventHandler<{}>;
  onModalDidShow?: BubblingEventHandler<{}>;
  onModalWillHide?: BubblingEventHandler<{}>;
  onModalDidHide?: BubblingEventHandler<{}>;

  onModalSheetStateWillChange?: BubblingEventHandler<{}>;
  onModalSheetStateDidChange?: BubblingEventHandler<{}>;

  // value prop stubs
  reactChildrenCount: Int32;
};

// stubs
export default codegenNativeComponent<NativeProps>('RNIModalSheetView', {
  excludedPlatforms: ['android'],
  interfaceOnly: true,
}) as HostComponent<NativeProps>;