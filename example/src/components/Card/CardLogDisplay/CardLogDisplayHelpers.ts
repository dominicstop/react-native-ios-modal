import type {
  CardLogDisplayProps,
  DisplayListModePropScroll,
  DisplayListModePropFixed,
} from './CardLogDisplayTypes';

export function isDisplayListModePropScroll(
  props: CardLogDisplayProps
): props is CardLogDisplayProps & DisplayListModePropScroll {
  return (
    /* 1 */ props.listDisplayMode === 'SCROLL_ENABLED' ||
    /* 2 */ props.listDisplayMode === 'SCROLL_FIXED'
  );
}

export function isDisplayListModePropFixed(
  props: CardLogDisplayProps
): props is CardLogDisplayProps & DisplayListModePropFixed {
  return props.listDisplayMode === 'FIXED';
}
