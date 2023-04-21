

<br>

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