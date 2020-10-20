import * as Helpers from './helpers';

export class RequestFactory {
  static initialize(that){
    that.requestID  = 1;
    that.requestMap = {};
  };

  static getRequest(that, requestID){
    return that.requestMap[requestID];
  };

  static newRequest(that, { timeout = 0 }){
    const requestID = that.requestID++;

    const promise = new Promise((resolve, reject) => {
      that.requestMap[requestID] = { resolve, reject };
    });

    return { requestID, promise: (timeout
      ? Helpers.promiseWithTimeout(timeout, promise)
      : promise
    )};
  };

  static resolveRequest(that, {requestID, success, params}){
    try {
      const promise = that.requestMap[requestID];
      (success? promise.resolve : promise.reject)(params);
  
    } catch(error){
      console.log("RequestFactory, resolveRequest: failed");
      console.log(error);
    };
  };

  static resolveRequestFromObj(that, object){
    try {
      const { requestID, success = false, ...other } = object;
      const promise = that.requestMap[requestID];
      (success? promise.resolve : promise.reject)(other);
  
    } catch(error){
      console.log("RequestFactory, resolveRequestFromObj: failed");
      console.log(error);
    };
  };

  static rejectRequest(that, {requestID, message = ""}){
    const promise = that.requestMap[requestID];
    promise.reject(message);
  };
};