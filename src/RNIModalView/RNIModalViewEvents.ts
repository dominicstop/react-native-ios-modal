export type OnModalViewReactTagDidSetEventPayload = {
  reactTag?: number;
};

export type OnModalViewReactTagDidSetEvent = (event: { 
  nativeEvent: OnModalViewReactTagDidSetEventPayload 
}) => void;