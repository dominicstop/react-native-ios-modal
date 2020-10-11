
//wrapper func for setstate that returns a promise
export function setStateAsync(that, newState) {
  return new Promise((resolve) => {
      that.setState(newState, () => {
          resolve();
      });
  });
};

//wrapper for timeout that returns a promise
export function timeout(ms) {
  return new Promise(resolve => {
    const timeoutID = setTimeout(() => {
      clearTimeout(timeoutID);
      resolve();
    }, ms)
  });
};

export function promiseWithTimeout(ms, promise){
  // Create a promise that rejects in <ms> milliseconds
  const timeoutPromise = new Promise((resolve, reject) => {
    const timeoutID = setTimeout(() => {
      clearTimeout(timeoutID);
      reject(`Promise timed out in ${ms} ms.`)
    }, ms);
  });

  // Returns a race between our timeout and the passed in promise
  return Promise.race([promise, timeoutPromise]);
};