import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

import type { BubblingEventHandler, Int32 } from 'react-native/Libraries/Types/CodegenTypes';
import type { HostComponent, ViewProps } from 'react-native';

// stubs
export interface NativeProps extends ViewProps {
  // props
  reactChildrenCount: Int32;
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

  // events
  onModalSheetStateWillChange?: BubblingEventHandler<{}>;
  onModalSheetStateDidChange?: BubblingEventHandler<{}>;
};

// stubs
export default codegenNativeComponent<NativeProps>('RNIModalSheetView', {
  excludedPlatforms: ['android'],
  interfaceOnly: true,
}) as HostComponent<NativeProps>;