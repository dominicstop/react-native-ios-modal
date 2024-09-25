import { HomeScreen } from "../components/HomeScreen";
import type { RouteKey } from "./RouteKeys";


export type RouteEntry = {
  routeKey: RouteKey
  component: React.ComponentType<{}>;
};

export const ROUTE_ITEMS: Array<RouteEntry> = [
  {
    routeKey: 'home',
    component: HomeScreen,
  }
];

export const ROUTE_MAP: Record<RouteKey, RouteEntry> = (() => {
  const map: Record<string, RouteEntry> = {};

  for (const routeItem of ROUTE_ITEMS) {
    map[routeItem.routeKey] = routeItem;
  };

  return map;
})();