import type { ViewStyle } from "react-native";


export type ExampleItemProps = {
  index: number;
  style?: ViewStyle;
  extraProps?: Record<string, unknown>;
};