import { HomeScreen } from "../components/HomeScreen";
import { AppMetadataCard } from "../examples/AppMetadataCard";

import { ModalSheetViewTest01 } from "../examples/ModalSheetViewTest01";
import { ModalSheetViewTest02 } from "../examples/ModalSheetViewTest02";

import type { ExampleItemProps } from "../examples/SharedExampleTypes";
import type { RouteEntry } from "./Routes";


type ExampleItemBase = {
  component: unknown;
};

export type ExampleItemRoute = ExampleItemBase & RouteEntry & {
  type: 'screen';
  title?: string;
  subtitle?: string;
  desc?: Array<string>;
};

export type ExampleItemCard = ExampleItemBase & {
  type: 'card';
}

export type ExampleItem = 
  | ExampleItemRoute
  | ExampleItemCard;

export type ExampleListItem = {
  id: number;
  component: React.FC<ExampleItemProps>;
};

export const EXAMPLE_ITEMS: Array<ExampleItem> = (() => {
  const screenItems: Array<ExampleItemRoute> = [
    {
      component: HomeScreen,
      type: 'screen',
      routeKey: 'home',
      desc: [
        'Used for testing navigation events + memory leaks',
      ],
    },
  ];

  const cardItems: Array<ExampleItemCard> = [
    {
      type: 'card',
      component: ModalSheetViewTest01,
    },
    {
      type: 'card',
      component: ModalSheetViewTest02,
    },
  ]; 

  // if (SHARED_ENV.enableReactNavigation) {
  //   items.splice(0, 0, ...[DebugControls]);
  // }

  return [
    {
      type: 'card',
      component: AppMetadataCard,
    },
    ...screenItems, 
    ...cardItems
  ];
})();