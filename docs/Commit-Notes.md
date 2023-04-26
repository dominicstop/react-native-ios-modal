

<br><br>

* `Note:2023-03-30-19-36-33` - Archived/Old

	 * From: [`RNIModalManager`](../ios/src_library/React Native/RNIModal/RNIModalManager.swift)

	 * Date Extracted: `2023-04-27`

	<br>

	 * This assumes that the app is using a single window, and all the modals are
	    being presented on that window, as a chain of view controllers.

	 * E.g. "window 1" presents a modal, and "window 2" presents a modal

	 * Those 2 modals are not related to one another, and their respective
	    modal index should both be 1, since they are the 1st modal presented on
	     their respective window instances.

	 * Instead their modal indexes are 1, and 2, respectively.

	 * This also means the internal `currentModalIndex` state, and any other
	    logic that relies on it will be wrong too.

	 * And since there is no distinction on which modal belongs to a particular
	    window, all the modal instances in the app will get notified when a event
	     occurs.

	 * This can be fixed by keeping a separate `currentModalIndex` for each
	    window instance, and only updating it based on the modal's associated
	     window instance.

	 * This can also be fixed by programmatically determining the modal's
	    `modalIndex`.

<br><br>

* `Note:2023-04-07-03-22-48` - Archived/Old

	* From: [`RNIModalManager`](../ios/src_library/React Native/RNIModal/RNIModalManager.swift)
	* Date Extracted: `2023-04-27`

	<br>

	* Manually incrementing and decrementing the `modalIndex` is fragile.
	* For example:
		1. If multiple blur/focus events were to fire consecutively, the `modalIndex` might be wrong.
		2. If a modal presented/dismissed w/o notifying `RNIModalManager`,
			the `modalIndex` will be stale.
		3. If a modal was about to be blurred (i.e. "will blur"), but was
			cancelled halfway (i.e. "did blur" not invoked), and the modal regained
			focus again (i.e. invoking "will focus" + "did focus").
		4. Invoking "will blur", or "will focus" but not invoking the invoking
			the corresponding "did blur", and "did focus" methods.
	* When a modal is hidden, it will trigger a "focus" event for the new topmost modal; subsequently, when a modal is shown, it will trigger a "blur" event for the previous topmost modal.
	* This assumes that the "modal manager" can only be notified of a pair of "focus", or "blur" at a given time, per window instance...
	    * E.g. "will focus" -> "did focus", "will blur" -> "did blur".
	* However, there might be an instance where multiple modals may be hidden at the same time...
	    * E.g. "will blur 1", "will blur 2", "did blur 1", "did blur 2", etc.
	* When multiple "blur" events are firing, the modal with the lowest
	    index should take priority.
	* Subsequently, when multiple "focus" events are firing, the modal with
	    the highest modal index should take priority.
	* Additionally, when a "blur", or "focus" event is firing at the same
	    time...
	    * E.g. "will blur 1", "will focus 2", "did blur 1", "did focus 2", etc.
	* The "focus" event should take priority, (assuming that the "focus"
	    event was fired for the topmost modal).

<br><br>

* `Note:2023-04-22-03-26-45`
	* From: `TODO:2023-04-20-23-58-24` - Impl. sheet-related props.
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