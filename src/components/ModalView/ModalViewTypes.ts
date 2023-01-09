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
  // TODO: Rename to `shouldAutoCloseOnUnmount`
  autoCloseOnUnmount?: boolean;
  setEnableSwipeGestureFromProps?: boolean;
  setModalInPresentationFromProps?: boolean;

  containerStyle: ViewStyle;
  children: React.ReactChildren;
};

// prettier-ignore
export type ModalViewProps =
  ViewProps & ModalViewBaseProps;

export type ModalViewState = {
  visible: boolean;
  childProps: unknown;
  enableSwipeGesture: boolean;
  isModalInPresentation: boolean;
};
