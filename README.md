# react-native-ios-modal
A react-native component for displaying a modal on iOS by natively wrapping a react-native view inside a `UIViewController` and presenting it.
* Since this is just using a `UIViewController`, this component also supports setting the`UIModalPresentationStyle` and `UIModalTransitionStyle`.
* Supports setting `isModalInPresentation` and separately disabling the native swipe down gesture when the modal is using `pageSheet` `modalPresentationStyle`.
* You can use `ModalView` anywhere in your app and present a view modally either programmatically via a ref or automatically when a `ModalView` is mounted/unmounted.
* Support for several modal events, nested modals, and having a transparent background or a blurred background using `UIBlurEffect`.

![Modal Example 1 & 2](./assets/ModalExample-01-02.gif)

![Modal Example 3 & 4](./assets/ModalExample-03-04.gif)

![Modal Example 5 & 6](./assets/ModalExample-05-06.gif)

### Motivation
You can use this, but it's iOS only (so you have to use a different modal component on android). I just really liked the native iOS 13 `pageSheet` modal behavior + iOS automatically handles the modal dismiss gesture when using a scrollview.
- - -
<br/><br/>

## 1. Installation

```sh
npm install react-native-ios-modal
```
- - -
<br/><br/>

## 2. Usage
Please check out the examples directory for more on how to use it.
```js
import { ModalView } from 'react-native-ios-modal';
```
- - -
<br/><br/>


## 3. Documentation
### 3.1 `ModalView` Component Props
#### 3.1.1 Props: Flags
| Name                            | Default | Description                                                  |
|---------------------------------|---------|--------------------------------------------------------------|
| presentViaMount                 | false   | If this prop is set to true, the modal will be presented or dismissed when the `ModalView` is mounted/unmounted. |
| isModalBGBlurred                | true    | Set whether or not the background is blurred. When true, `modalBGBlurEffectStyle` prop takes effect. |
| enableSwipeGesture              | true    | When the modal is using `pageSheet` or similar `modalPresentationStyle`, this prop controls the whether or not the swipe gesture is enabled. |
| hideNonVisibleModals            | true    | When multiple modals are visible at the same time, the first few modals will be temporarily hidden (they will still be mounted) to improve performance. |
| isModalBGTransparent            | true    | Sets whether or not the modal background is transparent. When set to false, the background blur effect will be disabled automatically. |
| isModalInPresentation           | false   | When set to true, it prevents the modal from being dismissed via a swipe gesture. |
| setEnableSwipeGestureFromProps  | false   | When set to true, it allows you to set the `enableSwipeGesture` via the `setEnableSwipeGesture` function. |
| setModalInPresentationFromProps | false   | When set to true, it allows you to set the`isModalInPresentation` via the `setIsModalInPresentation`function. |

<br/>

#### 3.1.2 Props: Strings
| Name                   | Default or Type                                              | Description                                                  |                                             |
|------------------------|--------------------------------------------------------------|--------------------------------------------------------------|---------------------------------------------|
| modalID                | **Default**: `null`                                          | Assign a unique ID to the modal. You can use the ID to refer to this modal when using the `ModalViewModule` functions and programatically control it.  | **Type**: String                            |
| modalTransitionStyle   | **Default**: `coverVertical`                                 | The transition style to use when presenting/dismissing a modal. | **Type**: `UIModalTransitionStyles` value   |
| modalPresentationStyle | **Default**: `automatic` when on iOS 13+, otherwise  `overFullScreen` | The presentation style to use when presenting/dismissing a modal. | **Type**: `UIModalPresentationStyles` value |
| modalBGBlurEffectStyle | **Default**: `systemThinMaterial` when on iOS 13+, otherwise  `regular` | The blur style to use for the `UIBlurEffect` modal background.  | **Type**: `UIBlurEffectStyles` value        |

<br/>

#### 3.1.3 Props: Modal Events
| Name                  | Description                                                  |
|-----------------------|--------------------------------------------------------------|
| onModalShow           | Gets called after a modal is presented.                      |
| onModalDismiss        | Gets called after a modal is dismissed.                      |
| onModalDidDismiss     | Gets called after a modal is successfully dismissed via a swipe gesture. (Wrapper for `UIAdaptivePresentationControllerDelegate.presentationControllerDidDismiss`). |
| onModalWillDismiss    | Gets called when a modal is being swiped down via a gesture. ((Wrapper for  `UIAdaptivePresentationControllerDelegate.presentationControllerWillDismiss`). |
| onModalAttemptDismiss | Gets called when a modal is swiped down when `isModalInPresentation` is true. (Uses `UIAdaptivePresentationControllerDelegate.presentationControllerDidAttemptToDismiss`). |

<br/>

####  3.1.4 Props: Modal Functions
| Name                                 | Description                                                  |
|--------------------------------------|--------------------------------------------------------------|
| getEmitterRef                        | Gets a ref to the `EventEmitter` instance.                   |
| **aysnc** - setVisibility            | Programatically present/dismiss the modal. Resolved after the modal is presented/dismissed. |
| **aysnc** - setEnableSwipeGesture    | When `setEnableSwipeGestureFromProps` prop is true, it allows you to programatically set `enableSwipeGesture` prop via a function. |
| **async** - setIsModalInPresentation | When `setModalInPresentationFromProps` prop is true, it allows you to programatically set  `isModalInPresentation` via function. |
<br/>

### 3.2 `ModalViewModule`

### 3.3 Enum Values

### 3.4 `ModalContext`

### 3.5 `withModalLifecycle`
<br/><br/>


## License

MIT
