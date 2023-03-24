# TODO

- [ ] `2023-03-24-00-37-23` - **Refactor**: Use `react-native-utilities`

  * **Desc**: Update `react-native-ios-modal` to use `react-native-utilities` as a peer dependency.

  <br>

  - [ ] **Subtask** -  `TODO:2023-03-24-01-14-26` - Move `UIView+Helpers` extension to `react-native-utilities`.
  - [ ] **Subtask** - `TODO:2023-03-24-01-14-26` - Remove/Replace `UIWindow.key`.
  - [ ] **Subtask** - `TODO:2023-03-20-21-29-36`  - Move `RNIModalManager` helper functions to `RNIUtilities`.
  - [ ] **Subtask** - `TODO:2023-03-04-13-22-34` - **Refactor**: Remove `ViewModuleRelatedTypes`
  	* **Desc**: Move/Consolidate `src/types/ViewModuleRelatedTypes` to  `react-native-utilities` and remove.

<br>

- [ ] `TODO:2023-03-09-17-36-51` - Impl: Close Preceding Modals
  * Desc: Implement a way to close proceeding modals w/o permanently closing the succeeding/topmost modals. 
  	* When trying to close a modal that is "not in focus" (i.e. a modal that isn't at the very top; e.g. a modal that has a `modalIndex` that is lower than the topmost modal), will throw an error: "`ModalView`, `setVisibility` failed: Cannot dismiss modal because it's not in focus. Enable `allowModalForceDismiss` to dismiss".

<br>

- [ ] `TODO:2023-03-08-03-51-37` - **Impl**: `ModalEventListener` Component
  * **Desc**: Implement `ModalEventListener` dummy component.
  	* A dummy component that render nothing.
  	* Used to listen to modal events via the modal context + modal event emitter ref.
  	* Complete this after refactor + rename of modal events.
  * <u>Related</u>: `TODO:2023-03-04-13-15-11` - **Refactor**: Use Will/Did Prefix for `RNIModalView` Events

<br>

- [ ] `TODO:2023-03-08-03-48-33` - **Update**: Ex - `Test06`
  * **Desc**: Enable `ModalView.isModalContentLazy` prop for example `Test06`.

<br>

- [ ] `TODO:2023-03-04-13-02-45` - **Refactor**: Rename  to `shouldAutoCloseOnUnmount`
  * **Desc**: Rename `ModalView.autoCloseOnUnmount` prop to `autoCloseOnUnmount`.

<br>

- [ ] `TODO:20230-03-04-12-58-40` - **Refactor**: Types - Remove `KeyMapType` Usage

<br>

- [ ] `TODO:2023-03-04-12-50-04` - **Fix**: `isModalContentLazy` Prop 
  * **Desc**: Setting `ModalView.isModalContentLazy` to `false` triggers a bug w/  `setVisibility` that causes it to throw an error stating that the modal cannot be opened be

<br>

- [ ] `TODO:2023-03-04-12-45-32` - **Fix**: `enableSwipeGesture` Not Updating
  * **Desc**: Fix `ModalView.enableSwipeGesture` prop not applying changes when updated via state.

<br>

- [ ] `TODO:2023-03-04-06-34-28` - Library Native Cleanup

  * **Desc**: Rewrite native to be more readable/consistent.

  <br>

  * [ ] **Subtask** - `TODO:2023-03-24-09-41-16` - Remove `modalLevel`
    * **Desc**: Remove `RNIModalView.modalLevel`
  
  <br>
  
  * [x] **Subtask** - `TODO:2023-03-18-09-22-15` - Re-write Modal Focus Checking Logic
    * **Desc**: Re-write modal "focus checking"
    	* instead of manually keeping track of focus per modal instance (potentially becoming stale over time), check focus via climbing the presented view controller hierarchy.
    	* ` getPresentedViewControllers().last === self.modalNVC: true`
    	* ``getPresentedViewControllers.last === self.modalVC false`
  
  <br>

  * [x] **Subtask** - `TODO:2023-03-22-13-18-14` - **Refactor**: Move `fromString` to enum init

  * [x] **Subtask** - `TODO:2023-03-22-12-33-26` - **Refactor**: Remove `modalNVC`
  	* Remove `RNIModalView.modalNVC` + usage.

  <br>

  * [ ] **Subtask** - `TODO:2023-03-22-12-18-37` - **Refactor**: Remove `deinitControllers`
    * Refactor `RNIModalView` so that we don't have to constantly cleanup.

  <br>

  * [ ] **Subtask** - `TODO:2023-03-22-12-09-34` - Move to `get` property called  `synthesizedNativeEventBase`
    * **Desc**: Refactor `createModalNativeEventDict`.

  <br>

  * [ ] **Subtask** - `TODO:2023-03-22-12-07-54` - **Refactor**: Move to `RNIModalManager`
    * **Desc**: Move `RNIModalView.setIsHiddenForViewBelowLevel` to `RNIModalManager`.
  
  <br>
  
  * [x] **Subtask** - `TODO:2023-03-22-11-33-06` - Add `synthesized-` prefix to properties in `RNIModalView`.
  * [x] **Subtask** - `TODO:2023-03-17-15-32-16` - Rename to `RNIModalView.isModalInFocus`
  * [ ] **Subtask** - `TODO:2023-03-17-12-42-02` - Remove `RNIModalView.modalUUID`
  * [x] **Subtask** - `TODO:2023-03-16-15-16-09` - Remove `RNIModalView.DefaultValues`
  * [x] **Subtask** - `TODO:2023-03-16-15-19-13` - Remove `RCTSwiftLog`
  
  <br>
  
  * [ ] **Subtask** - `TODO:2023-03-04-15-39-46` - **Impl**: `RNIModalManager`
    * **Desc**: Implement `RNIModalManager` singleton for handling modal focus/blur logic.
    	* Modal focus/blur re-write.
    	* Consolidate focus/blur related logic to this class, This class will be notified whenever a new modal is presented or dismissed.
    	* It will then be responsible to notify/"hand out" blur/focus events to other modals.
    	* Will be responsible for keeping track how many modals are currently active, etc.
  
  <br>
  
  - [ ] **Subtask** - `TODO:2023-03-24-09-58-50` - Refactor `RNIModalView` to use `RNIModalManager`.
  - [ ] **Subtask** - `TODO:2023-03-24-09-58-50` - Add temporary changes to  `RNIModalManager` for `RNIModalView` partial support. 
  
  <br>
  
  - [ ] **Subtask** - `TODO:2023-03-24-09-56-09` - Remove temporary changes to `RNIModalManager`.
    * Desc: Temporarily add changes to `RNIModalManager` so that `RNIModalView` can partially use it while it hasn't finished conforming to all the protocols in `RNIModal`.
  
  <br>
  
  - [ ] **Subtask** - `TODO:2023-03-05-00-32-43` - **Fix**: Edge Case - Modal Focus/Blur Bug
    * **Desc**: Add code to manually propagate modal blur/focus events.
    	* The modal is being dismissed via calling the modal view controller's dismiss method. As such, the focus/blur event is not being propagated.
  
  <br>
  
  - [ ] **Subtask** - `TODO:2023-03-05-00-33-15`  - **Refactor**: Re-write `dismissModalByID`
  	* **Desc**: Cleanup + Re-write `RNIModalViewModule.dismissModalByID`.
  
  <br>
  
  - [ ] **Subtask** - `TODO:2023-03-04-15-38-02` - **Refactor**: Relocate `currentModalLevel`
  	- **Desc**: Relocate `RNIModalViewManager.currentModalLevel` property to a singleton called `RNIModalManager`.
  
  
  <br>
  
  - [ ] **Subtask** - `TODO:2023-03-04-15-33-15` - **Refactor**: Relocate `delegatesFocus`
  	* **Desc**: Relocate `RNIModalViewManager.delegatesFocus` property to a singleton called `RNIModalManager`.
  
  <br>
  
  - [ ] **Subtask** - `TODO:2023-03-04-15-49-02` - **Refactor**:  Relocate `presentedModalRefs`
  
  <br>
  
  - [ ] **Subtask** - `TODO:2023-03-04-13-06-27` - **Impl**: Update `RNIModalView` Native Events
  	* **Desc**: Update `RNIModalView` native event parameters (i.e. send over more relevant data).
  		* Add param `isUserInitiated` to indicate if an event was fired due to a user action.
  
  <br>
  
  * [ ] **Subtask** - `TODO:2023-03-04-13-15-11` - **Refactor**: Use Will/Did Prefix for `RNIModalView` Events
  	* **Desc**: Rename `RNIModalView` events to use "will/did" prefix, and deprecate old event names (for backwards compatibility).
  
  - <u>Related</u>:
  	*  `TODO:2023-03-04-05-25-44` - Library Cleanup
  	* `Note:2023-03-04-02-58-31`

<br><br>

## TODO - Completed

- [x] `TODO:2023-03-04-03-59-43` - Re-Write Examples in Typescript

	* **Desc**: Re-write prev/existing `react-native-ios-modal` examples/tests, and other related code in typescript.

	- [x] **Subtask** - `TODO:2023-03-04-04-39-44` - Import + Re–write Example Components
		* **Desc**: Import example-related components/utilities from `react-native-ios-context-menu` (i.e. `example/src`) and retrofit it to work in  `react-native-ios-modal`'s example project.

<br>

- [x] `TODO:2023-03-04-04-20-46` - Library Typescript Re-Write
	* **Desc**: Re-write `react-native-ios-modal` to support typescript.

<br>

- [x]  `TODO:2023-03-04-05-25-44` - Library Cleanup

	* **Desc**: Cleanup library's code to be more understandable.

	<br>
	
	- [x] **Subtask** - `TODO:2023-03-04-04-20-46` - Library Native Cleanup
		* **Desc**: Cleanup library's native code - Initial preparation for library overhaul to use `react-native-ios-utilities` as a peer dependency.

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