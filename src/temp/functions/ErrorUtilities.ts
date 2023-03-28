import type { NativeError } from "../types/NativeError";
import { TypeUtils } from "./TypeUtils";


export class ErrorUtilities {
  static isNativeError(error: unknown): error is NativeError {
    if(error == null) return false;
    if(typeof error !== 'object') return false;

    if(!TypeUtils.hasKey('code'   , error)) return false;
    if(!TypeUtils.hasKey('domain' , error)) return false;
    if(!TypeUtils.hasKey('message', error)) return false;

    if(typeof error.code    !== 'string') return false;
    if(typeof error.domain  !== 'string') return false;
    if(typeof error.message !== 'string') return false;

    return true;
  };
};