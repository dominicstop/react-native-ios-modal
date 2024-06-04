import type { ViewStyle } from 'react-native';

// Section - Types - Internal
// --------------------------

export type DisplayListModePropFixed = {
  listDisplayMode: 'FIXED';
  listMaxItemsToShow?: number;
};

export type DisplayListModePropScroll = {
  listDisplayMode: 'SCROLL_ENABLED' | 'SCROLL_FIXED';
  listMaxItems?: number;
  listMinHeight?: number;
  scrollViewStyle?: ViewStyle;
  contentContainerStyle?: ViewStyle;
};

export type DisplayListModeProp =
  | DisplayListModePropFixed
  | DisplayListModePropScroll;

export type CardLogDisplayBaseProps = {
  style?: ViewStyle;
  initialLogItems?: Array<CardLogDisplayItem>;
  listEmptyMessage?: string;
  shouldShowTimestamp?: boolean;
};

export type CardLogDisplayProps = CardLogDisplayBaseProps & DisplayListModeProp;

export type InternalListMode = CardLogDisplayListMode | 'EMPTY';

// Section - Types - Public
// ------------------------

export type CardLogDisplayItem = {
  timestamp: number;
  title: string;
  index: number;
};

export type CardLogDisplayListMode = DisplayListModeProp['listDisplayMode'];

export type CardLogDisplayHandle = {
  log: (title: string) => void;
  clearLogs: () => void;
  setLogs: (nextLogs: CardLogDisplayItem[]) => void;
};
