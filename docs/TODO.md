# TODO

- [ ] `TODO:2023-03-04-03-59-43` - Re-Write Examples in Typescript

	* **Desc**: Re-write prev/existing `react-native-ios-modal` examples/tests, and other related code in typescript.

	- [x] <u>Subtask</u> - `TODO:2023-03-04-04-39-44` - Import + Re–write Example Components
		* **Desc**: Import example-related components/utilities from `react-native-ios-context-menu` (i.e. `example/src`) and retrofit it to work in  `react-native-ios-modal`'s example project.

<br>

- [x] `TODO:2023-03-04-04-20-46` - Library Typescript Re-Write
	* **Desc**: Re-write `react-native-ios-modal` to support typescript.

<br>

- [x]  `TODO:2023-03-04-05-25-44` - Library Cleanup

	* **Desc**: Cleanup library's code to be more understandable.

	- [ ] <u>Subtask</u> - `TODO:2023-03-04-04-20-46` - Library Native Cleanup
		* **Desc**: Cleanup library's native code - Preparation for library overhaul to use `react-native-ios-utilities` as a peer dependency.

<br><br>

## Old/Archive


- [x] Use Context to pass ref to functions
- [x] Impl. observable so other comps can subscribe/unsub to events via context instead of using refs to call events
- [x] Create HOC to wrap comp., consume modal context, handle subscribe/unsub to events  and then call "modal life cycle" funcs via ref to wrapped comp.
- [ ] Impl. hooks API ex: useOnModalShowCallback, useOnModalDismiss, etc. — hook to consume modal context, then handle sub/unsub to modal events and call callback

- [x] Refactor - move constants to seperate file
- [ ] Refactor - convert to typescript
- [ ] Refactor - Use built in swift error type
- [x] Update example to have multiple examples
- [x] Render nothing on android
- [x] Add Modal OnFocus/onBlur events to ModalView
- [ ] Add `waitFor` on modal `setVisibility` to fix modal flicker on mount
- [x] Implement modal `nativeEvent`
- [x] Add global `ModalEvents` EventEmitter to listen to modal events
- [ ] Add library to react native directory repo/site
- [x] Finish Initial Documentation
- [ ] Add Example Test for present modal via mount/unmount
- [ ] Add AutoDismiss when unmounted prop
- [ ] Add comments to Example
- [ ] Add test for react native versions 0.60 or older versions
- [ ] Update supported `UIModalPresentationStyles`
- [ ] Add example `UIModalTransitionStyles`
- [ ] Use `NativeModule` to programmatically open/close a modal instead of the current `requestID`/`onRequestResult`
  * `NativeModule`'s has built in functionality to create and resolving promises.