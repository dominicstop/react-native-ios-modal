import type { ViewProps, ViewStyle } from 'react-native';
import type { RNIModalViewProps } from 'src/native_components/RNIModalView';

export type ModalViewBaseProps = Partial<
  Pick<
    RNIModalViewProps,
    // props - flags
    | 'presentViaMount'
    | 'isModalBGBlurred'
    | 'enableSwipeGesture'
    | 'hideNonVisibleModals'
    | 'isModalBGTransparent'
    | 'isModalInPresentation'
    | 'allowModalForceDismiss'

    // props - string
    | 'modalID'
    | 'modalTransitionStyle'
    | 'modalBGBlurEffectStyle'
    | 'modalPresentationStyle'

    // props - events
    | 'onModalShow'
    | 'onModalDismiss'
    | 'onModalBlur'
    | 'onModalFocus'
    | 'onModalDidDismiss'
    | 'onModalWillDismiss'
    | 'onModalAttemptDismiss'
  >
> & {
  // TODO: See TODO:2023-03-04-13-02-45 - Refactor: Rename to
  // shouldAutoCloseOnUnmount
  autoCloseOnUnmount?: boolean;
  setEnableSwipeGestureFromProps?: boolean;
  setModalInPresentationFromProps?: boolean;
  isModalContentLazy?: boolean;

  containerStyle?: ViewStyle;
  children?: React.ReactNode;
};

// prettier-ignore
export type ModalViewProps =
  ViewProps & ModalViewBaseProps;

export type ModalViewState = {
  isModalVisible: boolean;
  childProps: unknown;
  enableSwipeGesture: boolean;
  isModalInPresentation: boolean;
  isModalInFocus: boolean;
};
