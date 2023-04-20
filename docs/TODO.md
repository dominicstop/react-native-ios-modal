# TODO

☀️☁️

<br><br>

## TODO - Current Tasks

<br>

- [ ] `TODO:2023-04-20-23-58-24` - Impl. sheets + detents.

	* Research
		* A sheet is an instance of a new `UIPresentationController` subclass called `UISheetPresentationController`.
			* The typical way to get an instance of this class is to read the `sheetPresentationController` property on a view controller before you present it.
			* This method returns a non-nil instance as long the view controller's `modalPresentationStyle`is form sheet or page sheet.
		* What are detents? A detent is a height where a sheet naturally rests, and these are defined as a fraction of the fully expanded sheet frame. 
			* System defined detents: `.medium`, `.large`.
		* `UIViewController.sheetPresentationController.detents`.
			* The default value of this property is an array of just the large detent, which is why if you don't set it at all, you get a standard full height sheet.
		* `sheet.prefersScrollingExpandsWhenScrolledToEdge`
			* I might prefer that scrolling not expand the sheet so the content behind the modal  is always visible unless I explicitly resize the sheet by dragging from the bar.
			* By default, this property is true, so setting it to false prevents scrolling from expanding the sheet.
		* `sheet.selectedDetentIdentifier` + `sheet.animateChanges`
			* Programmatically changing the size of the sheet.
			* Change which current detent is active, and animate the transitions of detents.
		* `sheet.smallestUndimmedDetentIdentifier`
			* By default, this property is nil, which means all of the detents are dimmed.
			* But if you want to remove dimming, set it to the identifier of the smallest detent where you don't want dimming. 
			* More than visually removing the dimming, this property also allows you to build advanced nonmodal experiences, since I can now interact not only with the content in the sheet but also with the content outside of the sheet.
			* This will not only remove the dimming but also let's you interact with  the controller that is currently presenting the bottom sheet.
		* `sheet.prefersEdgeAttachedInCompactHeight`
			* In iOS 13, we made all sheets full screen in landscape, and now we've made available an alternate appearance where sheets are only attached to the screen at their bottom edge.
			* To get this new appearance, simply set `prefersEdgeAttachedInCompactHeight` to true.
			* Now just setting this will always give you a sheet that is as wide as the safe area. 
			* "Edge attached" means that the sheet is touching the edges of the screen. This usually happens when the iPhone's screen is in landscape.
		* If you'd like a sheet whose width follows the `presentedViewControllers.preferredContentSize`, set `sheet.widthFollowsPreferredContentSizeWhenEdgeAttached` to true.  
			* Now the sheet will respect the presented VC's `preferredContentSize`.
			* This will only take effect when the sheet is "edge attached".
		* `sheet.prefersGrabberVisible`
			* A grabber often isn't necessary, but in cases where it might be less obvious that a sheet is resizable, such as when scrolling doesn't resize the sheet, displaying the grabber can be a helpful indicator of resizability.
		* `sheet.preferredCornerRadius`
			* Another option we've exposed is the ability to customize the corner radius. 
			* If your app has a more rounded appearance, you may want to match that aesthetic. 
			* Note that the system will keep stacked corners looking consistent, so if the sheet with very rounded edges expands to push back the root sheet, the root sheet will have larger corners to match. 
		* Finally, although it's possible to create a sheet with detents on iPad, often a popover is wanted instead that adapts to a sheet in compact, potentially customized with things like detents.
			* Adapt a popover to a customized sheet.
				* The `sheetPresentationController` will be available for all controllers that have the `modalPresentationStyle` set to either `.pageSheet` or `.formSheet`.
				* Small aside: These look the same on iPhone, but `.formSheet` is much smaller when presented on the iPad.
			* First, I'll set the `modalPresentationStyle` of the picker to popover. 
				* `picker.modalPresentationStyle = .popover`
			* Then, instead of grabbing the `sheetPresentationController`, because this will now return `nil`, since the `modalPresentationStyle` is not a sheet, I'll get the `popoverPresentationController`.
				* `let popover = picker.popoverPresentationController`.
			* and then I'll grab a new property on the popover called the `adaptiveSheetPresentationController`. 
				* This property returns an instance of the sheet that the popover will adapt to in compact size classes, and then I'll configure it just as I did the sheet before.
				* `let sheet = popover.adaptiveSheetPresentationController`.
		* Custom detents
			* Create a detent identifier and then create a detent with that identifier and provide a maximum height. 
				* Create an identifier for the custom detent: `let smallId = UISheetPresentationController.Detent.Identifier("small")`.
				* Then create a custom detent using the custom identifier: `UISheetPresentationController.Detent.custom(identifier: smallId) { context in return 80 }`.
				* You can now use the custom detent in the detents array: `sheetPresentationController?.detents = [smallDetent, .medium(), .large()]`.
			* In addition to system-defined `.medium` and `.large` we can create `.custom`. 
				* Custom detent takes a closure whose job is to return the desired height: `custom { _ in return 200 }`
				* Want a bottom sheet that is 30% or 60% of the available height? This is easily done thanks to the `context` we get passed in. 
					* It has `maximumDetentValue`, which specifies the maximum height possible for the sheet: `.custom { context in return context.maximumDetentValue * 0.6`
				* You can also extend `UISheetPresentationControllerDetentIdentifier` with `static` identifier for your custom sizes.
					*  this way, you can refer to them when configuring other options for the  sheet presentation controller, like controlling the dimming effect with `largestUndimmedDetentIdentifier`.

	<br>

	- [x] **Subtask** - `TODO:2023-04-21-00-43-59` - Impl. prop `sheetDetents`.
	- [ ] **Subtask** - `TODO:2023-04-21-00-31-46` - Impl.  `modalPreferredContentSize`
		* For example, `UIModalPresentationStyle.pageSheet` uses an explicit size that the system provides. 
		* By contrast, `UIModalPresentationStyle.formSheet` uses the view controller’s `preferredContentSize` property, which you can set.
		* This will also be used when `sheet.widthFollowsPreferredContentSizeWhenEdgeAttached` is set to `true`.

<br>

- [ ] `TODO:2023-03-04-13-15-11` - Refactor: Update Modal Events

	* **Desc**: Refactor `RNIModalView` events to use "will/did" prefix, update the modal event objects, and deprecate old event names (for backwards compatibility).

	<br>

	- [x] **Subtask** - `TODO:2023-03-30-15-52-53` - Move deprecated native modal event types from `RNIModalViewEvents` to `RNIModalViewDeprecatedEvents`, and update library imports/exports.
	- [x] **Subtask** - `TODO:2023-03-30-16-25-01` - Impl: `RNIModal.modalIndexPrev`
		* **Desc**: Implement in order to support deprecated event object property `modalLevelPrev`.

	<br>

	- [x] **Subtask** - `TODO:2023-04-14-23-40-15` - Impl. Update `RNIModalData` - Add more modal-related data.
	- [x] **Subtask** - `TODO:2023-03-30-19-18-20` - Impl: Types - Create `ModalDeprecatedBaseEventData`.
	- [ ] **Subtask** -`TODO:2023-03-31-18-33-52` - Add modal event object property - `triggeredVia`: `programmatic`, `gesture`, `request`, `reordering`, etc.
	- [x] **Subtask** - `TODO:2023-03-30-15-53-01` - Add `deprecated` suffix to deprecated events.
	- [x] **Subtask** - `TODO:2023-03-04-13-06-27` - Impl: Update `RNIModalView` Native Events.
	- [x] **Subtask** - `TODO:2023-03-30-15-52-42` - Update typescript types for modal event objects to match native event object.
	- [x] **Subtask** - `TODO:2023-03-30-15-53-13` - Remove deprecated native events.
	- [x] **Subtask** - `TODO:2023-03-30-15-54-06` - Impl. new `RNIModalView` native events.
	- [x] **Subtask** - `TODO:2023-03-30-16-36-50` - Update `ModalView` to use the new events.
	- [x] **Subtask** - `TODO:2023-03-30-15-55-12` - Add invocation for deprecated events: `onModalFocus`, `onModalShow`, `onModalAttemptDismiss`, `onModalDismiss`, `onModalBlur`
	- [ ] **Subtask** - `TODO:2023-04-05-15-35-49` - Impl. `onModalDismissWillCancel` and `onModalDismissDidCancel`
	- [ ] **Subtask** - `TODO:2023-03-30-15-56-38` - Update examples.

<br>

- [ ] `TODO:2023-04-07-02-33-21` Refactor: Re-write "hide non-visible modal" logic (i.e. logic for temporarily hiding bottom-most  modals).
	- [x] **Subtask** - `TODO:2023-04-07-02-39-15` - Disable `hideNonVisibleModals`-related logic from triggering.
	- [ ] **Subtask** - `TODO:2023-03-22-12-07-54` Refactor: Move to `RNIModalManager`
		* **Desc**: Move `RNIModalView.setIsHiddenForViewBelowLevel` to `RNIModalManager`.

<br>

- [ ] `TODO:2023-03-04-13-02-45` Refactor: Rename `ModalView.autoCloseOnUnmount` prop to `shouldAutoCloseOnUnmount`.

<br>

- [ ] `2023-03-24-00-37-23` Refactor: Use `react-native-utilities`

  * **Desc**: Update `react-native-ios-modal` to use `react-native-utilities` as a peer dependency.

  <br>

  - [ ] **Subtask** -  `TODO:2023-03-24-01-14-26` - Move `UIView+Helpers` extension to `react-native-utilities`.
  - [ ] **Subtask** - `TODO:2023-03-24-01-14-26` Refactor: Remove/Replace `UIWindow.key` extension.
  - [ ] **Subtask** - `TODO:2023-03-28-18-58-47` - Remove native iOS code in `ios/src_library/Temp` that was copied over from `react-native-ios-utilities` + update usage.
  - [ ] **Subtask** - `TODO:2023-03-29-04-54-56` - Remove JS/TS code in `src/temp` that was copied over from `react-native-ios-utilities` + update usage.
  - [ ] **Subtask** - `TODO:2023-03-20-21-29-36`  - Refactor: Move `RNIModalManager` helper functions to `RNIUtilities`.
  - [ ] **Subtask** - `TODO:2023-03-04-13-22-34` - Refactor: Remove `ViewModuleRelatedTypes`
    * **Desc**: Move/Consolidate `src/types/ViewModuleRelatedTypes` to  `react-native-utilities` and remove.

<br>

- [ ] `TODO:2023-03-27-23-55-09` **Refactor: Re-write `RNIModalView` error creation and handling. 

- [ ] `TODO:20230-03-04-12-58-40` Refactor: Types - Remove `KeyMapType` Usage.

<br><br>

## TODO - Bugs

- [ ] `TODO:2023-03-04-12-50-04` Fix: `isModalContentLazy` Prop 

	* **Desc: Setting `ModalView.isModalContentLazy` to `false` triggers a bug w/  `setVisibility` that causes it to throw an error stating that the modal cannot be opened be.

	<br>

	- [ ] **Subtask** - `TODO:2023-03-08-03-48-33` Update: Ex - `Test06` - Enable `ModalView.isModalContentLazy` prop for example `Test06`.

<br>

- [ ] `TODO:2023-03-04-12-45-32` Fix: `ModalView.enableSwipeGesture` prop not updating.
	* **Desc**: Fix `ModalView.enableSwipeGesture` prop not applying changes when updated via state.

<br><br>

## TODO - Non-Priority

- [ ] `TODO:2023-03-09-17-36-51` - Impl: Close preceding modals non-destructively
  * Desc: Implement a way to close proceeding modals w/o permanently closing the succeeding/topmost modals. 
  	* When trying to close a modal that is "not in focus" (i.e. a modal that isn't at the very top; e.g. a modal that has a `modalIndex` that is lower than the topmost modal), will throw an error: "`ModalView`, `setVisibility` failed: Cannot dismiss modal because it's not in focus. Enable `allowModalForceDismiss` to dismiss".

<br>

- [ ] `TODO:2023-03-08-03-51-37` Impl: `ModalEventListener` Component
  * **Desc: Implement `ModalEventListener` dummy component.
  	* A dummy component that render nothing.
  	* Used to listen to modal events via the modal context + modal event emitter ref.
  	* Complete this after refactor + rename of modal events.
  * <u>Related</u>: `TODO:2023-03-04-13-15-11` Refactor: Use Will/Did Prefix for `RNIModalView` Events

<br><br>

## TODO - Completed

<br>

- [x] `TODO:2023-03-31-18-33-34` - Unify/streamline/consolidate logic for invoking modal focus/blur.

	- [x] **Subtask** - `TODO:2023-03-31-18-37-00` - Impl. `RNIViewControllerLifeCycleNotifiable` protocol.
	- [x] **Subtask** - `TODO:2023-04-06-02-14-59` Update `RNIModalViewController` to use `RNIViewControllerLifeCycleNotifiable`.
	- [x] **Subtask** -`TODO:2023-03-31-18-34-23` - Impl. "modal presentation state" (i.e. `RNIModalPresentationState`).
	- [x] **Subtask** - `TODO:2023-04-06-02-13-24` - Update `RNIModalView` to use `RNIViewControllerLifeCycleNotifiable`.
	- [x] **Subtask** - `TODO:2023-04-07-02-41-35` - Update `RNIModalView` to use "modal presentation state" (i.e. `RNIModalPresentationState`).

	<br>

	- [x] **Subtask** - `TODO:2023-04-07-05-44-22` - Impl. `RNIModalPresentationTrigger` enum.
	- [x] **Subtask** - `TODO:2023-04-07-06-10-22` Refactor - Replace `RNIModalState.isModalPresented`  w/  `RNIModalPresentationState`.

	- [x] **Subtask** -`TODO:2023-03-31-18-33-43` - Refactor `RNIModalManager` focus/blur logic to not rely on "modal index".

<br>

- [x] `TODO:2023-04-08-18-37-57` - Replace inappropriate use of "synthesized" prefix w/ "computed".

- [x] `TODO:2023-04-07-01-44-05` - Refactor: Replace `RNIModalManager.currentModalIndex` with per window instance "modal index".

- [x] `TODO:2023-03-30-20-13-10` - Impl: `UIWindow.windowID`.

<br>

- [x] `TODO:2023-03-28-18-52-17` - Pre-migration to `react-native-ios-utilites`
	- [x] **Subtask** - `TODO:2023-03-29-04-34-35` -  Copy over `react-native-ios-utilities` native source to `ios/src_library/Temp`.
	- [x] **Subtask** - `TODO:2023-03-29-04-50-50` - Copy over `react-native-ios-utilities` js/ts source to `src/temp`.
	- [x] **Subtask** - `2023-03-29-05-04-40` - Refactor: Update `RNIModalView` + `ModalView` to use `RNIWrapperView`.

<br>

- [x] `TODO:2023-03-04-06-34-28` - Library Native Cleanup

	* **Desc: Rewrite native to be more readable/consistent.

	<br>

	* [x] **Subtask** - `TODO:2023-03-24-09-41-16` - Remove `modalLevel`
		* **Desc: Remove `RNIModalView.modalLevel`

	<br>

	* [x] **Subtask** - `TODO:2023-03-18-09-22-15` - Re-write Modal Focus Checking Logic
		* **Desc: Re-write modal "focus checking"
			* instead of manually keeping track of focus per modal instance (potentially becoming stale over time), check focus via climbing the presented view controller hierarchy.
			* ` getPresentedViewControllers().last === self.modalNVC: true`
			* ``getPresentedViewControllers.last === self.modalVC false`

	<br>

	* [x] **Subtask** - `TODO:2023-03-22-13-18-14` Refactor: Move `fromString` to enum init

	* [x] **Subtask** - `TODO:2023-03-22-12-33-26` Refactor: Remove `modalNVC`
		* Remove `RNIModalView.modalNVC` + usage.

	<br>

	* [x] **Subtask** - `TODO:2023-03-22-12-09-34` - Move to `get` property called  `synthesizedNativeEventBase`
		* **Desc: Refactor `createModalNativeEventDict`.

	<br>

	* [x] **Subtask** - `TODO:2023-03-22-11-33-06` - Add `synthesized-` prefix to properties in `RNIModalView`.
	* [x] **Subtask** - `TODO:2023-03-17-15-32-16` - Rename to `RNIModalView.isModalInFocus`
	* [x] **Subtask** - `TODO:2023-03-17-12-42-02` - Remove `RNIModalView.modalUUID`
	* [x] **Subtask** - `TODO:2023-03-16-15-16-09` - Remove `RNIModalView.DefaultValues`
	* [x] **Subtask** - `TODO:2023-03-16-15-19-13` - Remove `RCTSwiftLog`

	<br>

	* [x] **Subtask** - `TODO:2023-03-04-15-39-46` Impl: `RNIModalManager`
		* **Desc: Implement `RNIModalManager` singleton for handling modal focus/blur logic.
			* Modal focus/blur re-write.
			* Consolidate focus/blur related logic to this class, This class will be notified whenever a new modal is presented or dismissed.
			* It will then be responsible to notify/"hand out" blur/focus events to other modals.
			* Will be responsible for keeping track how many modals are currently active, etc.

	<br>

	- [x] **Subtask** - `TODO:2023-03-24-09-58-50` - Refactor `RNIModalView` to use `RNIModalManager`.
	- [x] **Subtask** - `TODO:2023-03-24-14-25-52` - Remove `RNIModalViewFocusDelegate`-related logic.
	- [x] **Subtask** - `TODO:2023-03-24-09-58-50` - Add temporary changes to  `RNIModalManager` for `RNIModalView` partial conformance. 

	<br>

	- [x] **Subtask** - `TODO:2023-03-24-09-56-09` - Remove temporary changes to `RNIModalManager`.
		* **Desc: Temporarily add changes to `RNIModalManager` so that `RNIModalView` can partially use it while it hasn't finished conforming to all the protocols in `RNIModal`.

	<br>

	- [x] **Subtask** - `TODO:2023-03-05-00-32-43` Fix: Edge Case - Modal Focus/Blur Bug
		* **Desc: Add code to manually propagate modal blur/focus events.
			* The modal is being dismissed via calling the modal view controller's dismiss method. As such, the focus/blur event is not being propagated.

	<br>

	- [x] **Subtask** - `TODO:2023-03-05-00-33-15`  Refactor: Re-write `RNIModalViewModule.dismissModalByID`.

	- [x] **Subtask** - `TODO:2023-03-04-15-38-02` Refactor: Remove `RNIModalViewManager.currentModalLevel`.

	- [x] **Subtask** - `TODO:2023-03-04-15-33-15` Refactor: Remove `RNIModalViewManager.delegatesFocus`.

	- [x] **Subtask** - `TODO:2023-03-04-15-49-02` Refactor:  Remove `RNIModalViewManager.presentedModalRefs`.

	<br>

	- <u>Related</u>:
		*  `TODO:2023-03-04-05-25-44` - Library Cleanup
		*  `Note:2023-03-04-02-58-31`

<br>

- [x] `TODO:2023-03-04-03-59-43` - Re-Write Examples in Typescript

	* **Desc: Re-write prev/existing `react-native-ios-modal` examples/tests, and other related code in typescript.

	- [x] **Subtask** - `TODO:2023-03-04-04-39-44` - Import + Re–write Example Components
		* **Desc: Import example-related components/utilities from `react-native-ios-context-menu` (i.e. `example/src`) and retrofit it to work in  `react-native-ios-modal`'s example project.

<br>

- [x] `TODO:2023-03-04-04-20-46` - Library Typescript Re-Write
	* **Desc: Re-write `react-native-ios-modal` to support typescript.

<br>

- [x]  `TODO:2023-03-04-05-25-44` - Library Cleanup

	* **Desc: Cleanup library's code to be more understandable.

	<br>
	
	- [x] **Subtask** - `TODO:2023-03-04-04-20-46` - Library Native Cleanup
		* **Desc: Cleanup library's native code - Initial preparation for library overhaul to use `react-native-ios-utilities` as a peer dependency.

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