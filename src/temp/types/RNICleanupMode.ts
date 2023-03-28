

export type RNICleanupMode = 
  | 'automatic'
  | 'viewController'
  | 'reactComponentWillUnmount'
  | 'disabled';

export type RNIInternalCleanupModeProps = {
  internalCleanupMode?: RNICleanupMode;
};