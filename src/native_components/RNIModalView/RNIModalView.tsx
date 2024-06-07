import * as React from 'react';

import { RNIModalNativeView } from './RNIModalNativeView';

import type { 
	RNIContextMenuViewProps, 
	RNIModalViewRef, 
	StateReactTag, 
	StateViewID 
} from './RNIModalViewTypes';

export const RNIModalView = React.forwardRef<
	RNIModalViewRef, 
	RNIContextMenuViewProps
>((props, ref) => {

	const [viewID, setViewID] = React.useState<StateViewID>();
	const [reactTag, setReactTag] = React.useState<StateReactTag>();

	React.useImperativeHandle(ref, () => ({
		getReactTag: () => {
			return reactTag;
		},
		getViewID: () => {
			return viewID;
		},
	}));

	return (
		<RNIModalNativeView
			{...props}
			onDidSetViewID={(event) => {
				setViewID(event.nativeEvent.viewID);
				setReactTag(event.nativeEvent.reactTag);
				props.onDidSetViewID?.(event);
			}}
		>
			{props.children}
		</RNIModalNativeView>
	);
});