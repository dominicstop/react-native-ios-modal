// TODO: Move to react-native-utilities

export type ViewManagerCommandID = string | number;

export type ViewManagerCommandMap<T extends string> = {
  [K in T]: ViewManagerCommandID;
};

export type ViewManagerConstantMap<T = Record<string, unknown>> = {
  [K in keyof T]: T[K];
};
