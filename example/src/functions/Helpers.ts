// @ts-nocheck

import * as React from 'react';

/** wrapper func for setState that returns a promise */
// eslint-disable-next-line consistent-this
export function setStateAsync<T extends {}>(
  that: React.Component,
  newState: T | ((prevState: T) => T)
) {
  return new Promise<void>((resolve) => {
    that.setState(newState, () => {
      resolve();
    });
  });
}

export function useStateCallback<T>(
  initialState: T
): [T, (state: T, callback?: (nextState: T) => void) => void] {
  const [state, setState] = React.useState(initialState);

  // init mutable ref container for callbacks
  const cbRef = React.useRef<((state: T) => void) | undefined>(undefined);

  const setStateCallback = React.useCallback(
    (nextState: T, cb?: (state: T) => void) => {
      // store current, passed callback in ref
      cbRef.current = cb;

      // keep object reference stable, exactly like `useState`
      setState(nextState);
    },
    []
  );

  React.useEffect(() => {
    // cb.current is `undefined` on initial render,
    // so we only invoke callback on state *updates*
    if (cbRef.current) {
      cbRef.current(state);

      // reset callback after execution
      cbRef.current = undefined;
    }
  }, [state]);

  return [state, setStateCallback];
}

export function useStateAsync<T>(
  initialState: T
): [T, (nextState: T) => Promise<void>] {
  const [state, setState] = useStateCallback(initialState);

  return [
    state,
    (nextState) => {
      return new Promise<void>((resolve) => {
        setState(nextState, () => {
          resolve();
        });
      });
    },
  ];
}

/** wrapper for timeout that returns a promise */
export function timeout(ms: number) {
  return new Promise<void>((resolve) => {
    const timeoutID = setTimeout(() => {
      clearTimeout(timeoutID);
      resolve();
    }, ms);
  });
}

/** Wraps a promise that will reject if not not resolved in <ms> milliseconds */
export function promiseWithTimeout<T>(ms: number, promise: Promise<T>) {
  // Create a promise that rejects in <ms> milliseconds
  const timeoutPromise = new Promise<T>((_, reject) => {
    const timeoutID = setTimeout(() => {
      clearTimeout(timeoutID);
      reject(`Promise timed out in ${ms} ms.`);
    }, ms);
  });

  // Returns a race between our timeout and the passed in promise
  return Promise.race([promise, timeoutPromise]);
}

export function pad(num: number | string, places = 2) {
  return String(num).padStart(places, '0');
}

export function getNextItemInCyclicArray<T>(index: number, array: Array<T>): T {
  return array[index % array.length];
}