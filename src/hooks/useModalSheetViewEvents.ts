import React from "react";
import type { EventListener } from '@dominicstop/ts-event-emitter';

import { ModalSheetViewContext } from "../context/ModalSheetViewContext";
import type { ModalSheetViewEventEmitterMap, ModalSheetViewEventKeys } from "../types/ModalSheetViewEventEmitter";


export function useModalSheetViewEvents<
  EventKey extends ModalSheetViewEventKeys
>(
  eventName: EventKey,
  listener: EventListener<ModalSheetViewEventEmitterMap[EventKey]>
) {
  const modalContext = React.useContext(ModalSheetViewContext);
  if(modalContext == null){
    return;
  };

  React.useEffect(() => {
    const ref = modalContext.getModalSheetViewRef();
    const eventEmitter = ref.getEventEmitter();

    const listenerHandle = eventEmitter.addListener(eventName, listener);
    return () => {
      listenerHandle.unsubscribe();
    };
  });
};