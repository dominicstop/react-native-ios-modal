// TODO: TODO:2023-03-04-13-22-34 - Refactor: Remove
// `ViewModuleRelatedTypes`
//
// * Move this file (i.e. `ViewModuleRelatedTypes`) to
// `react-native-utilities`

export type ViewManagerCommandID = string | number;

export type ViewManagerCommandMap<T extends string> = {
  [K in T]: ViewManagerCommandID;
};

export type ViewManagerConstantMap<T = Record<string, unknown>> = {
  [K in keyof T]: T[K];
};
