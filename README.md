3DTouchHelper
===

Easy to use continuous 3D touch gesture recognizer.

Install
----

#### CocoaPods

``` ruby
use_frameworks
pod '3DTouchHelper'
```

#### Manual

Copy & paste `3DTouchHelper` file into your project.

Requirements
----

* Xcode 7.1
* Swift 2.1
* iOS9+
* iDevice with 3DTouch screen

Usage
----

Call `add3DTouchGestureRecognizer:` function form your view or viewcontroller.

``` swift
add3DTouchGestureRecognizer { (touchIndex, state, force, normalizedForce, forceValue, location) in
    print("touch \(touchIndex) \(state) \(forceValue) value \(normalizedForce) at \(location)")
}
```

#### Handler

``` swift
typealias TDTouchGestureRecognizerCallback = (
    touchIndex: Int,
    state: UIGestureRecognizerState,
    force: CGFloat,
    normalizedForce: CGFloat,
    touchForce: TDTouchForce,
    location: CGPoint) -> Void
```

#### TDTouchForce

An customisable enum for simplifying 3D touch force

``` swift
enum TDTouchForce {
    case Low
    case Mid
    case High
}
```

#### TDTouchForceValue

A struct for customising `TDTouchForce` enum values

``` swift
struct TDTouchForceValue {
    var Low: CGFloat
    var Mid: CGFloat
    var High: CGFloat
}
```

You can set your own values with `add3DTouchGestureRecognizer:forceValue:` function.

``` swift
add3DTouchGestureRecognizer({ (touchIndex, state, force, normalizedForce, touchForce, location) -> Void in
    print("touch \(touchIndex) \(state) \(forceValue) value \(normalizedForce) at \(location)")
}, forceValue: TDTouchForceValue(Low: 0.2, Mid: 0.6, High: 0.8))
```
