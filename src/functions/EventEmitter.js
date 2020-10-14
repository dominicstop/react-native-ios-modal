

export class EventEmitter {
  constructor() {
    this._events = {};
  };

  addListener(eventKey, listener) {
    // initialize
    if (!this._events[eventKey]) {
      this._events[eventKey] = [];
    };

    this._events[eventKey].push(listener);
  };

  removeListener(eventKey, listenerToRemove) {
    // event does not exist
    if (!this._events[eventKey]) return;

    this._events[eventKey] = this._events[eventKey].filter(listener => (
      listener !== listenerToRemove
    ));
  };

  once(eventKey, listener){
    this.addListener(eventKey, (data) => {
      listener?.();
      this.removeListener(eventKey, listener);
    });
  };

  removeAllListeners(){
    this._events = {};
  };

  emit(eventKey, data) {
    // event does not exist
    if (!this._events[eventKey]) return;

    this._events[eventKey].forEach(callback => {
      callback?.(data);
    });
  };
};