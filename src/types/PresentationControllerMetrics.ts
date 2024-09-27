import type { CGRectNative, CGSize } from "react-native-ios-utilities";


export type PresentationControllerMetrics = {
  instanceID: string;
  frameOfPresentedViewInContainerView: CGRectNative;
  preferredContentSize: CGSize;
  presentedViewFrame?: CGRectNative;
  containerViewFrame?: CGRectNative;
  adaptivePresentationStyle: string;
  shouldPresentInFullscreen: boolean;
  shouldRemovePresentersView: boolean;
};