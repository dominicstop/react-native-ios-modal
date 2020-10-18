# react-native-ios-modal
A react-native component for displaying a modal on iOS by natively wrapping a react-native view inside a `UIViewController` and presenting it.
* Since this is just using a `UIViewController`, this component also supports setting the`UIModalPresentationStyle` and `UIModalTransitionStyle`.
* Supports setting `isModalInPresentation` and separately disabling the native swipe down gesture when the modal is using `pageSheet` `modalPresentationStyle`.
* You can use `ModalView` anywhere in your app and present a view modally either programmatically via a ref or automatically when a `ModalView` is mounted/unmounted.
* Support for several modal events, multiple modals, and having a transparent background or a blurred background using `UIBlurEffect`.
* **Note**:  documentation under construction 🚧✨

![Modal Example 0 & 1](./assets/ModalExample-00-01.gif)

![Modal Example 2 & 3](./assets/ModalExample-02-03.gif)

![Modal Example 4 & 5](./assets/ModalExample-04-05.gif)

![Modal Example 6 & 7](./assets/ModalExample-06-07.gif)

### Motivation
* You can use this, but it's iOS only (so you have to use a different modal component on android). I just really liked the native iOS 13 `pageSheet` modal behavior, and iOS also  automatically handles the modal dismiss gesture when using a scrollview. 
* So this component exist to tap into native iOS modal behaviour. Ideally, another library will use this component (like a navigation library) to show modals and handle using a different component for android.
- - -
<br/>

## 1. Installation

```sh
# install via NPM
npm install react-native-ios-modal

# or install via yarn
yarn add react-native-ios-modal

# then run pod install (uses autolinking)
cd ios && pod install
```
- - -
<br/>

## 2. Usage
Please check out the [examples directory](https://github.com/dominicstop/react-native-ios-modal/tree/master/example/src/components) for more on how to use it.
```js
// import the library
import { ModalView } from 'react-native-ios-modal';

// and use it like this
<ModalView ref={r => this.modalRef = r}>
  <Text> Hello World </Text>
<ModalView/>
<TouchableOpacity onPress={() => {
  this.modalRef.setVisibility(true);
}}>
  <Text> Open Modal </Text>
</TouchableOpacity>
```
- - -
<br/>

## 3. Documentation
### 3.1 `ModalView` Component Props
#### 3.1.1 Props: Flags
| Name                                | Default | Description                                                  |
|-------------------------------------|---------|--------------------------------------------------------------|
| **presentViaMount**                 | false   | If this prop is set to true, the modal will be presented or dismissed when the `ModalView` is mounted/unmounted. |
| **isModalBGBlurred**                | true    | Set whether or not the background is blurred. When true, `modalBGBlurEffectStyle` prop takes effect. |
| **enableSwipeGesture**              | true    | When the modal is using `pageSheet` or similar `modalPresentationStyle`, this prop controls the whether or not the swipe gesture is enabled. |
| **hideNonVisibleModals**            | true    | When multiple modals are visible at the same time, the first few modals will be temporarily hidden (they will still be mounted) to improve performance. |
| **isModalBGTransparent**            | true    | Sets whether or not the modal background is transparent. When set to false, the background blur effect will be disabled automatically. |
| **isModalInPresentation**           | false   | When set to true, it prevents the modal from being dismissed via a swipe gesture. |
| **setEnableSwipeGestureFromProps**  | false   | When set to true, it allows you to set the `enableSwipeGesture` via the `setEnableSwipeGesture` function. |
| **setModalInPresentationFromProps** | false   | When set to true, it allows you to set the`isModalInPresentation` via the `setIsModalInPresentation`function. |

<br/>

#### 3.1.2 Props: Strings
| Name/Type                                                    | Default                                                      | Description                                                  |
|--------------------------------------------------------------|--------------------------------------------------------------|--------------------------------------------------------------|
| **modalID** -> `string`                                      | **Default**: `null`                                          | Assign a unique ID to the modal. You can use the ID to refer to this modal when using the `ModalViewModule` functions and programatically control it. |
| **modalTransitionStyle** -> `UIModalTransitionStyles` value  | **Default**: `coverVertical`                                 | The transition style to use when presenting/dismissing a modal. |
| **modalPresentationStyle** -> `UIModalPresentationStyles` value | **Default**: `automatic` when on iOS 13+, otherwise  `overFullScreen` | The presentation style to use when presenting/dismissing a modal. |
| **modalBGBlurEffectStyle** -> `UIBlurEffectStyles` value     | **Default**: `systemThinMaterial` when on iOS 13+, otherwise  `regular` | The blur style to use for the `UIBlurEffect` modal background. |

<br/>

#### 3.1.3 Props: Modal Events
| Name                                   | Description                                                  |
|----------------------------------------|--------------------------------------------------------------|
| `onModalFocus({nativeEvent})`          | Gets called when a modal is focused and is not currently the top most modal (to avoid duplicating the onModalShow event) |
| `onModalBlur({nativeEvent})`           | Gets called when a modal loses focus and is not currently the top most modal (to avoid duplicating the onModalDismiss event) |
| `onModalShow({nativeEvent})`           | Gets called after a modal is presented.                      |
| `onModalDismiss({nativeEvent})`        | Gets called after a modal is dismissed.                      |
| `onModalDidDismiss({nativeEvent})`     | Gets called after a modal is successfully dismissed via a swipe gesture. (Wrapper for `UIAdaptivePresentationControllerDelegate.presentationControllerDidDismiss`). |
| `onModalWillDismiss({nativeEvent})`    | Gets called when a modal is being swiped down via a gesture. ((Wrapper for  `UIAdaptivePresentationControllerDelegate.presentationControllerWillDismiss`). |
| `onModalAttemptDismiss({nativeEvent})` | Gets called when a modal is swiped down when `isModalInPresentation` is true. (Uses `UIAdaptivePresentationControllerDelegate.presentationControllerDidAttemptToDismiss`). |
<br/>

#### 3.1.3 Props: Misc
| Name               | Description                                           |
|--------------------|-------------------------------------------------------|
| **containerStyle** | The style for the view that holds the modal contents. |

<br/>

####  3.1.4 Props: Modal Functions
| Name                                                         | Description                                                  |
|--------------------------------------------------------------|--------------------------------------------------------------|
| `getEmitterRef()` -> `ModalVIewRef`                          | Gets a ref to the `EventEmitter` instance.                   |
| **aysnc** `setVisibility(visibility: bool, childProps: object)` | Programatically present/dismiss the modal. Resolved after the modal is presented/dismissed. |
| **aysnc** `setEnableSwipeGesture(bool)`                      | When `setEnableSwipeGestureFromProps` prop is true, it allows you to programatically set `enableSwipeGesture` prop via a function. |
| **async** `setIsModalInPresentation(bool)`                   | When `setModalInPresentationFromProps` prop is true, it allows you to programatically set  `isModalInPresentation` via function. |
<br/>

### 3.2 `ModalViewModule`
* `async ModalViewModule.dismissModalByID(modalID: string)`
* `async dismissAllModals(animated: bool)`

<br/>

### 3.3 Enum Values
#### 3.3.1 Enum: `UIBlurEffectStyles`
Enum values that you can pass to the `ModalView` `modalBGBlurEffectStyle` prop. More detailed description are available in the [Apple Developer Docs](https://developer.apple.com/documentation/uikit/uiblureffectstyle)
* Import the enum like this: `import { UIBlurEffectStyles } from 'react-native-ios-modal'`
* And use the enum in the `ModalView` `modalBGBlurEffectStyle` prop like this: `modalBGBlurEffectStyle={UIBlurEffectStyles.systemMaterial}`
* Or if you prefer, just pass in a string value directly like this: `modalBGBlurEffectStyle={'systemMaterial'}`

<br/>

* **Adaptable Styles** —  Changes based on the current system appearance. Requires iOS 13 and above.
1. `systemUltraThinMaterial`
2. `systemThinMaterial`
3. `systemMaterial`
4. `systemThickMaterial`
5. `systemChromeMaterial`

<br/>

* **Light Styles** — Blur styles that are tinted white/light. Meant to be used for system light appearance. Requires iOS 13 and above.
1. `systemMaterialLight`
2. `systemThinMaterialLight`
3. `systemUltraThinMaterialLight`
4. `systemThickMaterialLight`
5. `systemChromeMaterialLight`

<br/>

* **Dark Styles** — Blur styles that are tinted black/dark. Meant to be used for system dark appearance. Requires iOS 13 and above.
1. `systemChromeMaterialDark`
2. `systemMaterialDark`
3. `systemThickMaterialDark`
4. `systemThinMaterialDark`
5. `systemUltraThinMaterialDark`

<br/>

* **Regular Styles** — Blur styles that were originally added in iOS 8.
1. `regular`
2. `prominent`
3. `light`
4. `extraLight`
5. `dark`

<br/>

#### 3.3.2 Enum: `UIModalPresentationStyles`
Enum values that you can pass to the `ModalView` `modalPresentationStyle` prop. More detailed description are available in the [Apple Developer Docs](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle)
* Import the enum like this: `import { UIModalPresentationStyles } from 'react-native-ios-modal'`
* And use the enum in the `ModalView` `modalPresentationStyle` prop like this: `modalPresentationStyle={UIModalPresentationStyles.fullScreen}`
* Or if you prefer, just pass in a string value directly like this: `modalPresentationStyle={'fullScreen'}`

<br/>

* **Supported Presentation Styles**
1. `automatic` — Requires iOS 13 to work. The default presentation style for iOS 13 and above.
2. `fullScreen` — Present fullscreen but with an opaque background. The default presentation style on iOS 12 and below.
3. `overFullScreen` — Present fullscreen but with a transparent background.
4. `pageSheet` — The presentation style used on iPhones running iOS 13. Present a modal that can be dismissed via a swipe gesture.    
5. `formSheet` — The presentation style used on iPads. Same as `pageSheet` when on iPhone.

<br/>

* **Not Supported**
1. `none`
2. `currentContext`
3. `custom`
4. `overCurrentContext`
5. `popover`
6. `blurOverFullScreen`

<br/>

#### 3.3.3 Enum: `UIModalTransitionStyles `
Enum values that you can pass to the `ModalView` `modalTransitionStyle` prop. More detailed description are available in the [Apple Developer Docs](https://developer.apple.com/documentation/uikit/uimodaltransitionstyle)
* Import the enum like this: `import { UIModalTransitionStyles } from 'react-native-ios-modal'`
* And use the enum in the `ModalView` `modalTransitionStyle` prop like this: `modalTransitionStyle={UIModalTransitionStyles.coverVertical}`
* Or if you prefer, just pass in a string value directly like this: `modalTransitionStyle={'coverVertical'}`

<br/>

* **Supported Transition Styles**
1. `coverVertical`
2. `crossDissolve`
3. `flipHorizontal`

* **Not Supported**
1. `partialCurl`

<br/>

#### 3.3.4 Enum: `ModalEventKeys` 
Enum values that you can use in the `ModalView`  `EventEmitter` instance. Use the enum values to add/remove a listener. 
* Import the enum like this: `import { ModalEventKeys } from 'react-native-ios-modal'`
* And use the enum in the `ModalView` `EventEmitter` instance like this: `modalEmitter.addListener(ModalEventKeys.onModalShow, this._handleOnModalShow)`
* Or if you prefer, just pass in a string value directly like this: `modalEmitter.addListener('onModalShow', this._handleOnModalShow)`
* You can get a ref to a modal's `EventEmitter` like this: `modalRef.getEmitterRef()`

<br/>

1. `onModalBlur`
2. `onModalFocus`
3. `onModalShow`
4. `onModalDismiss`
5. `onModalDidDismiss`
6. `onModalWillDismiss`
7. `onModalAttemptDismiss`

<br/>

### 3.4 `ModalContext`
A context you can use inside the `ModalView` component.
* Import the context like this: `import { ModalContext } from 'react-native-ios-modal'`

<br/>

| Object Key               | Value Description                                            |
|--------------------------|--------------------------------------------------------------|
| getModalRef              | A function that returns a ref to the `ModalView`             |
| getEmitterRef            | A function that returns a ref to the `ModalView`'s `EventEmitter` instance |
| setVisibility            | A function that calls the `ModalView` `setVisibility` function |
| setEnableSwipeGesture    | A function that calls the `ModalView` `setVisibility` function |
| setIsModalInPresentation | A function that calls the `ModalView` `setIsModalInPresentation` function |

<br/>

### 3.5 `withModalLifecycle` HOC
* Import the HOC function like this: `import { withModalLifecycle } from 'react-native-ios-modal'`

<br/>

### 3.6 Modal `EventEmitter`

<br/>

### 3.7 Modal `NativeEvent` object
Example `{nativeEvent}` object that gets passed to modal events.

```json
{
  "isInFocus": true,
  "isPresented": true,
  "modalLevel": 1,
  "modalLevelPrev": -1,
  "modalUUID": "DDADB792-3F85-4849-B669-AB734EC3B610",
  "target": 197
}
```

<br/>

## 4. Examples

<br/>

## License

MIT
