//
//  TDTouchGestureRecognizer.swift
//  3DTouchHelper
//
//  Created by Cem Olcay on 25/10/15.
//  Copyright © 2015 prototapp. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

public extension UIView {
    
    public func add3DTouchGestureRecognizer(_ callback: @escaping TDTouchGestureRecognizerCallback) {
        let gesture = TDTouchGestureRecognizer(callback: callback)
        addGestureRecognizer(gesture)
    }
    
    public func add3DTouchGestureRecognizer(_ callback: @escaping TDTouchGestureRecognizerCallback, forceValue: TDTouchForceValue) {
        let gesture = TDTouchGestureRecognizer(callback: callback, forceValue: forceValue)
        addGestureRecognizer(gesture)
    }
}

public extension UIViewController {
    
    public func add3DTouchGestureRecognizer(_ callback: @escaping TDTouchGestureRecognizerCallback) {
        view.add3DTouchGestureRecognizer(callback)
    }
    
    public func add3DTouchGestureRecognizer(_ callback: @escaping TDTouchGestureRecognizerCallback, forceValue: TDTouchForceValue) {
        view.add3DTouchGestureRecognizer(callback, forceValue: forceValue)
    }
}

// MARK: - 3DTouch

public extension UITouch {
    public var normalizedForce: CGFloat {
        return force / maximumPossibleForce
    }
    
    public func forceValue(_ value: TDTouchForceValue) -> TDTouchForce {
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

public enum TDTouchForce: String, CustomDebugStringConvertible {
    case Low = "Low"
    case Mid = "Mid"
    case High = "High"
    
    public var debugDescription: String {
        return rawValue
    }
}

public struct TDTouchForceValue {
    public var Low: CGFloat
    public var Mid: CGFloat
    public var High: CGFloat
    
    public init() {
        Low = 0.3
        Mid = 0.6
        High = 1
    }
    
    public init(Low: CGFloat, Mid: CGFloat, High: CGFloat) {
        self.Low = Low
        self.Mid = Mid
        self.High = High
    }
}

// MARK: - Callback

public typealias TDTouchGestureRecognizerCallback = (
    _ touchIndex: Int,
    _ state: UIGestureRecognizerState,
    _ force: CGFloat,
    _ normalizedForce: CGFloat,
    _ touchForce: TDTouchForce,
    _ location: CGPoint) -> Void

// MARK: - Recognizer

public class TDTouchGestureRecognizer: UIGestureRecognizer {
    
    // MARK: Properties
    
    fileprivate var callback: TDTouchGestureRecognizerCallback?
    fileprivate var forceValue: TDTouchForceValue!
    
    // MARK: Init
    
    convenience init(callback: @escaping TDTouchGestureRecognizerCallback, forceValue: TDTouchForceValue = TDTouchForceValue()) {
        self.init(target: nil, action: Selector(""))
        self.callback = callback
        self.forceValue = forceValue
    }
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    // MARK: Touches
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
        handleGesture(touches)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        self.state = .changed
        handleGesture(touches)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        self.state = .ended
        handleGesture(touches)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
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
