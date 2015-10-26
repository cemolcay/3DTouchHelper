//
//  TDTouchGestureRecognizer.swift
//  3DTouchHelper
//
//  Created by Cem Olcay on 25/10/15.
//  Copyright © 2015 prototapp. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

extension UIView {

    func add3DTouchGestureRecognizer(callback: TDTouchGestureRecognizerCallback) {
        let gesture = TDTouchGestureRecognizer(callback: callback)
        addGestureRecognizer(gesture)
    }

    func add3DTouchGestureRecognizer(callback: TDTouchGestureRecognizerCallback, forceValue: TDTouchForceValue) {
        let gesture = TDTouchGestureRecognizer(callback: callback, forceValue: forceValue)
        addGestureRecognizer(gesture)
    }
}

extension UIViewController {

    func add3DTouchGestureRecognizer(callback: TDTouchGestureRecognizerCallback) {
        view.add3DTouchGestureRecognizer(callback)
    }

    func add3DTouchGestureRecognizer(callback: TDTouchGestureRecognizerCallback, forceValue: TDTouchForceValue) {
        view.add3DTouchGestureRecognizer(callback, forceValue: forceValue)
    }
}

// MARK: - 3DTouch

extension UITouch {
    var normalizedForce: CGFloat {
        return force / maximumPossibleForce
    }

    func forceValue(value: TDTouchForceValue) -> TDTouchForce {
        if normalizedForce <= value.Low {
            return .Low
        } else if normalizedForce > value.Low && normalizedForce <= value.Mid {
            return .Mid
        } else if normalizedForce > value.Mid && normalizedForce <= value.High {
            return .High
        } else {
            return .Low
        }
    }
}

enum TDTouchForce: String, CustomDebugStringConvertible {
    case Low = "Low"
    case Mid = "Mid"
    case High = "High"

    internal var debugDescription: String {
        return rawValue
    }
}

struct TDTouchForceValue {
    var Low: CGFloat
    var Mid: CGFloat
    var High: CGFloat

    init() {
        Low = 0.3
        Mid = 0.6
        High = 1
    }

    init(Low: CGFloat, Mid: CGFloat, High: CGFloat) {
        self.Low = Low
        self.Mid = Mid
        self.High = High
    }
}

// MARK: - Callback

typealias TDTouchGestureRecognizerCallback = (
    touchIndex: Int,
    state: UIGestureRecognizerState,
    force: CGFloat,
    normalizedForce: CGFloat,
    touchForce: TDTouchForce,
    location: CGPoint) -> Void

// MARK: - Recognizer

private class TDTouchGestureRecognizer: UIGestureRecognizer {

    // MARK: Properties

    private var callback: TDTouchGestureRecognizerCallback?
    private var forceValue: TDTouchForceValue!

    // MARK: Init

    convenience init(callback: TDTouchGestureRecognizerCallback, forceValue: TDTouchForceValue = TDTouchForceValue()) {
        self.init(target: nil, action: "")
        self.callback = callback
        self.forceValue = forceValue
    }

    override init(target: AnyObject?, action: Selector) {
        super.init(target: target, action: action)
    }

    // MARK: Touches

    private override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        self.state = .Began
        handleGesture(touches)
    }

    private override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        self.state = .Changed
        handleGesture(touches)
    }

    private override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        self.state = .Ended
        handleGesture(touches)
    }

    private override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)
        self.state = .Cancelled
        handleGesture(touches)
    }

    // MARK: Handler

    private func handleGesture(touches: Set<UITouch>) {
        for (index, touch) in touches.enumerate() {
            callback?(
                touchIndex: index,
                state: state,
                force: touch.force,
                normalizedForce: touch.normalizedForce,
                touchForce: touch.forceValue(forceValue),
                location: touch.locationInView(touch.view))
        }
    }
}
