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

    func add3DTouchGestureRecognizer(_ callback: @escaping TDTouchGestureRecognizerCallback) {
        let gesture = TDTouchGestureRecognizer(callback: callback)
        addGestureRecognizer(gesture)
    }

    func add3DTouchGestureRecognizer(_ callback: @escaping TDTouchGestureRecognizerCallback, forceValue: TDTouchForceValue) {
        let gesture = TDTouchGestureRecognizer(callback: callback, forceValue: forceValue)
        addGestureRecognizer(gesture)
    }
}

extension UIViewController {

    func add3DTouchGestureRecognizer(_ callback: @escaping TDTouchGestureRecognizerCallback) {
        view.add3DTouchGestureRecognizer(callback)
    }

    func add3DTouchGestureRecognizer(_ callback: @escaping TDTouchGestureRecognizerCallback, forceValue: TDTouchForceValue) {
        view.add3DTouchGestureRecognizer(callback, forceValue: forceValue)
    }
}

// MARK: - 3DTouch

extension UITouch {
    var normalizedForce: CGFloat {
        return force / maximumPossibleForce
    }

    func forceValue(_ value: TDTouchForceValue) -> TDTouchForce {
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
    _ touchIndex: Int,
    _ state: UIGestureRecognizerState,
    _ force: CGFloat,
    _ normalizedForce: CGFloat,
    _ touchForce: TDTouchForce,
    _ location: CGPoint) -> Void

// MARK: - Recognizer

private class TDTouchGestureRecognizer: UIGestureRecognizer {

    // MARK: Properties

    fileprivate var callback: TDTouchGestureRecognizerCallback?
    fileprivate var forceValue: TDTouchForceValue!

    // MARK: Init

    convenience init(callback: @escaping TDTouchGestureRecognizerCallback, forceValue: TDTouchForceValue = TDTouchForceValue()) {
        self.init(target: nil, action: "")
        self.callback = callback
        self.forceValue = forceValue
    }

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    // MARK: Touches

    fileprivate override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
        handleGesture(touches)
    }

    fileprivate override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        self.state = .changed
        handleGesture(touches)
    }

    fileprivate override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        self.state = .ended
        handleGesture(touches)
    }

    fileprivate override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        self.state = .cancelled
        handleGesture(touches)
    }

    // MARK: Handler

    fileprivate func handleGesture(_ touches: Set<UITouch>) {
        for (index, touch) in touches.enumerated() {
            callback?(
                index,
                state,
                touch.force,
                touch.normalizedForce,
                touch.forceValue(forceValue),
                touch.location(in: touch.view))
        }
    }
}
