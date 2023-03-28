
/// Corresponds to `RNIGenericErrorDefaultable`, i.e. the default/base
/// error codes.
export type RNIBaseErrorCode = 
  | 'runtimeError'
  | 'libraryError'
  | 'reactError'
  | 'unknownError'
  | 'invalidArgument'
  | 'outOfBounds'
  | 'invalidReactTag'
  | 'nilValue';


export type RNIBaseError<T extends string> = {
  code: T;
  domain: string;
  message?: string;
  debug?: string;
};

export type RNIGenericError = RNIBaseError<RNIBaseErrorCode>;