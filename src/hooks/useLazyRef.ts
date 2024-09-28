import React from "react";

export function useLazyRef<T>(
  providerCallback: () => T
) {
  const ref = React.useRef<T>();

  if (ref.current === undefined) {
    ref.current = providerCallback();
  };

  return ref;
};