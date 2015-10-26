3DTouchHelper
===

Easy to use continuous 3D touch gesture recognizer.

Install
----

### Cocoapods

``` ruby
use_frameworks
pod '3DTouchHelper'
```

### Manual

Copy & paste `3DTouchHelper` file into your project.

Usage
----

Call `add3DTouchGestureRecognizer:` function form your view or viewcontroller.

``` swift
add3DTouchGestureRecognizer { (touchIndex, state, force, normalizedForce, forceValue, location) in
    print("touch \(touchIndex) \(state) \(forceValue) value \(normalizedForce) at \(location)")
}
```

### Handler

``` swift
typealias TDTouchGestureRecognizerCallback = (
    touchIndex: Int,
    state: UIGestureRecognizerState,
    force: CGFloat,
    normalizedForce: CGFloat,
    touchForce: TDTouchForce,
    location: CGPoint) -> Void
```